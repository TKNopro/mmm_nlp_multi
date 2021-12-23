//the fsm of the mod add
//author : Lee
module mmm_mod_add #(
    parameter                   WIDTH       =   260
)(
    //system signals
    input                       i_clk,
    input                       i_rstn,
    //input signals
    input                       i_en_addsub,    //1:mod add 0:mod sub
    input   [WIDTH-1:0]         i_a,
    input   [WIDTH-1:0]         i_b,
    input                       i_mode,
    input   [WIDTH-1:0]         i_p,

    //output signals
    output  [WIDTH-1:0]         o_c,
    output                      o_flag
);
    //localparam of the fsm
    localparam                  IDLE    =   2'b00;
    localparam                  S1      =   2'b01;
    localparam                  S2      =   2'b10;
    localparam                  OUT     =   2'b11;

    //defiantion of the wire and reg
    reg     [1:0]               cur_sta;
    reg     [1:0]               nxt_sta;

    reg                         en_addsub;
    reg                         mode;

    reg     [WIDTH-1:0]         a;
    reg     [WIDTH-1:0]         b;
    reg     [WIDTH-1:0]         p;
    reg     [WIDTH-1:0]         c;

    always @(*) begin
        a                   =   i_a;
        b                   =   i_b;
        p                   =   i_p;
        en_addsub           =   i_en_addsub;
        mode                =   i_mode;
    end

    //the main code of the fsm
    //first stage
    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn) 
            cur_sta         <=  IDLE;
        else
            cur_sta         <=  nxt_sta;
    end
    //secode stage
    always @(*) begin
        nxt_sta             =   IDLE;
        case(cur_sta)
            IDLE : begin
                if(en_addsub && mode)
                    nxt_sta =   S1;
                else if(en_addsub && !mode)
                    nxt_sta =   S2;
                else
                    nxt_sta =   IDLE;
            end

            S1 : begin
                if(en_addsub) begin
                    if(c < p)
                        nxt_sta =   OUT;
                    else
                        nxt_sta =   S1;
                end
                else begin
                    if(c > 0)
                        nxt_sta =   OUT;
                    else
                        nxt_sta =   S1;
                end
            end

            S2 : begin
                nxt_sta     =   OUT;
            end

            OUT : begin
                if(!en_addsub)
                    nxt_sta =   IDLE;
                else
                    nxt_sta =   OUT;
            end
        endcase
    end
    //third stage
    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn) begin
            c           <=  {(WIDTH){1'b0}};
        end
        else begin
            case (nxt_sta)
                S1 : begin
                    if(cur_sta == IDLE) begin
                        if(en_addsub)
                            c   <=  a + b;
                        else
                            c   <=  a - b;
                    end
                    else if(cur_sta == S1) begin
                        if(en_addsub)
                            c   <=  c - p;
                        else
                            c   <=  c - p;
                    end
                end

                S2 : begin
                    if(en_addsub)
                        c   <=  a + b;
                    else
                        c   <=  a ^ b;
                end

                OUT : begin
                    c   <=  c;
                end
            endcase
        end
    end

    assign  o_c     =   c;
    assign  o_flag  =   cur_sta == OUT;

endmodule
