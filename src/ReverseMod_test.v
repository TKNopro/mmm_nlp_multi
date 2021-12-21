module ReverseMod_test #(
    parameter WIDTH=256
)(
    input                  clk,
    input                  rst_n, // asyn
    input   [WIDTH-1:0]    p,
    input   [WIDTH-1:0]    a,
    input                  en, //pulse, p and a are ready
    output  reg            valid, //pulse, module is valid
    output  reg            ready, //pulse, module is read              
    output  reg [WIDTH-1:0]    Ramodp
);

reg [WIDTH-1:0] u_temp;
reg [WIDTH-1:0] v_temp;
reg [WIDTH-1:0] x_temp;
reg [WIDTH-1:0] y_temp;
reg [WIDTH-1:0] p_temp;


reg [WIDTH:0] temp0;
reg [WIDTH:0] temp1;

reg [WIDTH:0] temp2;
reg [WIDTH:0] temp3;
reg [WIDTH:0] temp4;
reg [WIDTH:0] temp5;
reg [WIDTH:0] temp6;
reg [WIDTH:0] temp7;

parameter IDLE      = 3'd0;
parameter START     = 3'd1;
parameter S0        = 3'd2;
parameter S1        = 3'd3;
parameter S2        = 3'd4;
parameter S3        = 3'd5;
parameter DONE      = 3'd6;


reg [2:0] curr_state;
reg [2:0] next_state;

always@(*) begin 
    temp0 = x_temp + p_temp;
    temp1 = y_temp + p_temp;
    temp2 = x_temp - y_temp;
    temp3 = x_temp + p_temp - y_temp;
    temp4 = y_temp - x_temp;
    temp5 = y_temp + p_temp - x_temp;
    temp6 = u_temp - v_temp;
    temp7 = v_temp - u_temp;
//    if(u_temp == 'd1) begin 
 //       Ramodp = y_temp;
//    end else begin 
        Ramodp = x_temp;        
//    end
end

always@(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin 
        u_temp <= 0;
        v_temp <= 0;
        x_temp <= 0;
        y_temp <= 0;
        p_temp <= 0;
        valid <= 0;
        ready <= 0;
    end else if(en && (curr_state == IDLE)) begin 
        u_temp <= a;
        v_temp <= p;
        x_temp <= 'd1;
        y_temp <= 'd0;
        p_temp <= p;        
    end else begin 
        case(next_state)
            IDLE: begin 
                valid <= 0;
                ready <= 1;
            end
            S0: begin
                ready <= 0;
                u_temp <= {1'b0,u_temp[WIDTH-1:1]};
                if(x_temp[0] == 1'b0) begin 
                    x_temp <= {1'b0, x_temp[WIDTH-1:1]};
                end else begin 
                    x_temp <= temp0[WIDTH:1];
                end
            end 
            S1: begin
                ready <= 0;
                v_temp <= {1'b0,v_temp[WIDTH-1:1]};
                if(y_temp[0] == 1'b0) begin 
                    y_temp <= {1'b0, y_temp[WIDTH-1:1]};
                end else begin 
                    y_temp <= temp1[WIDTH:1];
                end
            end
            S2: begin 
                ready <= 0;
                if((u_temp > v_temp) || (u_temp == v_temp)) begin 
                    u_temp <= temp6[WIDTH:1];
                    if(x_temp > y_temp) begin
                        if(x_temp[0] == y_temp[0]) begin 
                            x_temp <= temp2[WIDTH:1];
                        end else begin 
                            x_temp <= temp3[WIDTH:1];                            
                        end
                    end else begin
                        if(x_temp[0] != y_temp[0]) begin
                            x_temp <= temp3[WIDTH:1];
                        end else begin 
                            x_temp <= temp2[WIDTH:1] + p_temp;                             
                        end
                    end
                end else begin 
                    v_temp <= temp7[WIDTH:1];
                    if(y_temp > x_temp) begin 
                        if(x_temp[0] == y_temp[0]) begin
                            y_temp <= temp4[WIDTH:1];
                        end else begin 
                            y_temp <= temp5[WIDTH:1];                            
                        end
                    end else begin 
                        if(x_temp[0] != y_temp[0]) begin
                            y_temp <= temp5[WIDTH:1];
                        end else begin 
                            y_temp <= temp4[WIDTH:1] + p_temp;                            
                        end                    
                    end
                end
            end
            DONE: begin 
                ready <= 0;
                valid <= 1;
            end
        endcase
    end
end

always@(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
        curr_state <= IDLE;
    end else begin 
        curr_state <= next_state;
    end
end

always@(*) begin 
    case(curr_state)
        IDLE: begin 
            if(en) begin 
                next_state = START;
            end else begin 
                next_state = IDLE;
            end
        end
        START: begin 
            if(u_temp[0] == 1'b0) begin 
                next_state = S0;
            end else if(v_temp[0] == 1'b0) begin 
                next_state = S1;
            end else begin 
                next_state = S2;
            end
        end
        S0: begin
            if(u_temp[0] == 1'b0) begin 
                next_state = S0;
            end else if(v_temp[0] == 1'b0) begin 
                next_state = S1;
            end else begin 
                next_state = S2;
            end
        end
        S1: begin 
            if(v_temp[0] == 1'b0) begin 
                next_state = S1;
            end else begin 
                next_state = S2;
            end
        end
        S2: begin 
            if(u_temp == 'd1) begin 
                next_state = DONE;
            end else if(u_temp[0] == 1'b0) begin 
                next_state = S0;
            end else if(v_temp[0] == 1'b0) begin 
                next_state = S1;
            end else begin 
                next_state = S2;
            end
        end
        DONE: begin 
            next_state = IDLE;
        end 
        default: begin 
            next_state = IDLE;
        end
    endcase
end

endmodule
