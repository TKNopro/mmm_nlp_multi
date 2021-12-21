module mmm_mod_inv #(
    parameter WIDTH = 260
)(
    input clk,
    input rst_n,    
    input [WIDTH-1:0] N, //unsigned
    input [WIDTH-1:0] R, //unsigned
    input in_valid,

    output reg [WIDTH-1:0] result,
    output reg out_valid
);
 
reg [WIDTH:0] X1;
reg [WIDTH:0] X2;
reg [WIDTH:0] X3;

reg [WIDTH:0] Y1;
reg [WIDTH:0] Y2;
reg [WIDTH:0] Y3;

reg [WIDTH:0] N_temp;
reg [WIDTH:0] R_temp;

wire [WIDTH:0] temp1;
wire [WIDTH:0] temp2;
wire [WIDTH:0] temp3;
wire [WIDTH:0] temp4;

parameter IDLE = 4'd0;
parameter START = 4'd1;
parameter S1 = 4'd2;
parameter S2 = 4'd3;
parameter S3 = 4'd4;
parameter S4 = 4'd5;
parameter S5 = 4'd6; 
parameter S6 = 4'd7;
parameter DONE = 4'd8;


reg [3:0] current_state;
reg [3:0] next_state;

always@(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin 
        current_state <= IDLE;
    end else begin 
        current_state <= next_state;
    end
end

always@(*) begin 
    case(current_state)
        IDLE: begin 
            if(in_valid) begin 
                next_state = START;
            end else begin 
                next_state = IDLE;
            end
        end
        START: begin 
            if((X3 != 'd1) && (Y3 != 'd1))begin 
                if((X3[0] == 1'b0) && (X2[0] == 1'b0)) begin 
                    next_state = S1;
                end else if((X3[0] == 1'b0) && (X2[0] == 1'b1)) begin 
                    next_state = S2; 
                end else if((Y3[0] == 1'b0) && (Y2[0] == 1'b0)) begin 
                    next_state = S3;
                end else if((Y3[0] == 1'b0) && (Y2[0] == 1'b1)) begin 
                    next_state = S4;
                end else if( (~X3[WIDTH]&Y3[WIDTH]) || 
                    ((X3[WIDTH] == Y3[WIDTH]) && (X3[WIDTH-1:0] > Y3[WIDTH-1:0]) ) ) begin 
                    next_state = S5;
                end else begin 
                    next_state = S6;
                end
            end else begin 
                next_state = DONE;
            end
        end
        S1:begin 
            if((X3 != 'd1) && (Y3 != 'd1))begin 
                if((X3[0] == 1'b0) && (X2[0] == 1'b0)) begin 
                    next_state = S1;
                end else if((X3[0] == 1'b0) && (X2[0] == 1'b1)) begin 
                    next_state = S2; 
                end else if((Y3[0] == 1'b0) && (Y2[0] == 1'b0)) begin 
                    next_state = S3;
                end else if((Y3[0] == 1'b0) && (Y2[0] == 1'b1)) begin 
                    next_state = S4;
                end else if( (~X3[WIDTH]&Y3[WIDTH]) || 
                    ((X3[WIDTH] == Y3[WIDTH]) && (X3[WIDTH-1:0] > Y3[WIDTH-1:0]) ) ) begin 
                    next_state = S5;
                end else begin 
                    next_state = S6;
                end
            end else begin 
                next_state = DONE;
            end
        end
        S2: begin 
            if((X3 != 'd1) && (Y3 != 'd1))begin 
                if((X3[0] == 1'b0) && (X2[0] == 1'b0)) begin 
                    next_state = S1;
                end else if((X3[0] == 1'b0) && (X2[0] == 1'b1)) begin 
                    next_state = S2; 
                end else if((Y3[0] == 1'b0) && (Y2[0] == 1'b0)) begin 
                    next_state = S3;
                end else if((Y3[0] == 1'b0) && (Y2[0] == 1'b1)) begin 
                    next_state = S4;
                end else if( (~X3[WIDTH]&Y3[WIDTH]) || 
                    ((X3[WIDTH] == Y3[WIDTH]) && (X3[WIDTH-1:0] > Y3[WIDTH-1:0]) ) ) begin 
                    next_state = S5;
                end else begin 
                    next_state = S6;
                end
            end else begin 
                next_state = DONE;
            end
        end
        S3: begin
            if((X3 != 'd1) && (Y3 != 'd1))begin 
                if((X3[0] == 1'b0) && (X2[0] == 1'b0)) begin 
                    next_state = S1;
                end else if((X3[0] == 1'b0) && (X2[0] == 1'b1)) begin 
                    next_state = S2; 
                end else if((Y3[0] == 1'b0) && (Y2[0] == 1'b0)) begin 
                    next_state = S3;
                end else if((Y3[0] == 1'b0) && (Y2[0] == 1'b1)) begin 
                    next_state = S4;
                end else if( (~X3[WIDTH]&Y3[WIDTH]) || 
                    ((X3[WIDTH] == Y3[WIDTH]) && (X3[WIDTH-1:0] > Y3[WIDTH-1:0]) ) ) begin 
                    next_state = S5;
                end else begin 
                    next_state = S6;
                end
            end else begin 
                next_state = DONE;
            end
        end
        S4: begin 
            if((X3 != 'd1) && (Y3 != 'd1))begin 
                if((X3[0] == 1'b0) && (X2[0] == 1'b0)) begin 
                    next_state = S1;
                end else if((X3[0] == 1'b0) && (X2[0] == 1'b1)) begin 
                    next_state = S2; 
                end else if((Y3[0] == 1'b0) && (Y2[0] == 1'b0)) begin 
                    next_state = S3;
                end else if((Y3[0] == 1'b0) && (Y2[0] == 1'b1)) begin 
                    next_state = S4;
                end else if( (~X3[WIDTH]&Y3[WIDTH]) || 
                    ((X3[WIDTH] == Y3[WIDTH]) && (X3[WIDTH-1:0] > Y3[WIDTH-1:0]) ) ) begin 
                    next_state = S5;
                end else begin 
                    next_state = S6;
                end
            end else begin 
                next_state = DONE;
            end
        end
        S5: begin 
            if((X3 != 'd1) && (Y3 != 'd1))begin 
                if((X3[0] == 1'b0) && (X2[0] == 1'b0)) begin 
                    next_state = S1;
                end else if((X3[0] == 1'b0) && (X2[0] == 1'b1)) begin 
                    next_state = S2; 
                end else if((Y3[0] == 1'b0) && (Y2[0] == 1'b0)) begin 
                    next_state = S3;
                end else if((Y3[0] == 1'b0) && (Y2[0] == 1'b1)) begin 
                    next_state = S4;
                end else if( (~X3[WIDTH]&Y3[WIDTH]) || 
                    ((X3[WIDTH] == Y3[WIDTH]) && (X3[WIDTH-1:0] > Y3[WIDTH-1:0]) ) ) begin 
                    next_state = S5;
                end else begin 
                    next_state = S6;
                end
            end else begin 
                next_state = DONE;
            end
        end
        S6: begin 
            if((X3 != 'd1) && (Y3 != 'd1))begin 
                if((X3[0] == 1'b0) && (X2[0] == 1'b0)) begin 
                    next_state = S1;
                end else if((X3[0] == 1'b0) && (X2[0] == 1'b1)) begin 
                    next_state = S2; 
                end else if((Y3[0] == 1'b0) && (Y2[0] == 1'b0)) begin 
                    next_state = S3;
                end else if((Y3[0] == 1'b0) && (Y2[0] == 1'b1)) begin 
                    next_state = S4;
                end else if( (~X3[WIDTH]&Y3[WIDTH]) || 
                    ((X3[WIDTH] == Y3[WIDTH]) && (X3[WIDTH-1:0] > Y3[WIDTH-1:0]) ) ) begin 
                    next_state = S5;
                end else begin 
                    next_state = S6;
                end
            end else begin 
                next_state = DONE;
            end
        end
        DONE: begin 
            next_state = IDLE;
        end
        default:begin 
            next_state = IDLE;
        end
     endcase
end

assign temp1 = X1 + R_temp;
assign temp2 = X2 + ~N_temp + 1;

assign temp3 = Y1 + R_temp;
assign temp4 = Y2 + ~N_temp + 1;

always@(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin 
        X1 <= 0;
        X2 <= 0;
        X3 <= 0;
        Y1 <= 0;
        Y2 <= 0;
        Y3 <= 0;
        N_temp <= 0;
        R_temp <= 0;
    end else if(in_valid) begin 
        X1 <= 1;
        X2 <= 0;
        X3 <= {1'b0, N};
        Y1 <= 0;
        Y2 <= 1;
        Y3 <= {1'b0, R};
        R_temp <= {1'b0, R};
        N_temp <= {1'b0, N};        
    end begin 
        case(next_state)
            S1: begin 
                X1 <= {X1[WIDTH],X1[WIDTH:1]};
                X2 <= {X2[WIDTH],X2[WIDTH:1]};
                X3 <= {X3[WIDTH],X3[WIDTH:1]};
            end            
            S2: begin 
                X1 <= {temp1[WIDTH],temp1[WIDTH:1]};
                X2 <= {temp2[WIDTH],temp2[WIDTH:1]};
                X3 <= {X3[WIDTH],X3[WIDTH:1]};
            end
            S3: begin 
                Y1 <= {Y1[WIDTH],Y1[WIDTH:1]};
                Y2 <= {Y2[WIDTH],Y2[WIDTH:1]};
                Y3 <= {Y3[WIDTH],Y3[WIDTH:1]};
            end
            S4: begin 
                Y1 <= {temp3[WIDTH],temp3[WIDTH:1]};
                Y2 <= {temp4[WIDTH],temp4[WIDTH:1]};
                Y3 <= {Y3[WIDTH],Y3[WIDTH:1]};
            end
            S5: begin 
                X1 <= X1 + ~Y1 + 1;
                X2 <= X2 + ~Y2 + 1; 
                X3 <= X3 + ~Y3 + 1;    
            end
            S6: begin
                Y1 <= Y1 + ~X1 + 1;
                Y2 <= Y2 + ~X2 + 1; 
                Y3 <= Y3 + ~X3 + 1;                 
            end          
        endcase
    end
end
 

 always@(posedge clk or negedge rst_n)begin 
    if(~rst_n) begin 
        result <= 0;
        out_valid <= 0;
    end else if(next_state == DONE) begin 
        if(X3 == 'd1) begin
            result <= X1[WIDTH-1:0];
        end else if(Y3 == 'd1) begin 
            result <= Y1[WIDTH-1:0];
        end    
        out_valid <= 1'b1;           
    end else if(next_state == IDLE) begin 
        out_valid <= 0;
    end
end


endmodule