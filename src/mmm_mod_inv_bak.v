//the modular inv of the mmm_multi
//author : Lee
/*
module mmm_mod_inv #(
    parameter               IDW     =       256,
    parameter               ODW     =       IDW + 3,
    parameter               N       =       256,
    parameter               NW      =       $clog2(N),
    parameter               PW      =       260
)(
    //system signals
    input                   i_clk,
    input                   i_rstn,
    //input singals
    input                   i_valid,
    output                  o_ready,
    input   [IDW-1:0]       i_a,
    input   [PW-1:0]        i_p,

    input                   i_ready,
    output                  o_valid,
    output  [ODW-1:0]       o_m_b
);

    //defination of the localparam
    //fsm
    localparam              IDLE    =   4'b0000;
    localparam              S1      =   4'b0001;
    localparam              S2      =   4'b0010;
    localparam              S3      =   4'b0011;
    localparam              S4      =   4'b0100;
    localparam              S5      =   4'b0101;
    localparam              S6      =   4'b0110;
    localparam              S7      =   4'b0111;
    localparam              S8      =   4'b1000;

    //defination of the wire and reg
    reg     [3:0]           cur_sta;
    reg     [3:0]           nxt_sta;

    reg     [IDW-1:0]       u;
    reg     [PW-1:0]        v;

    reg     [IDW-1:0]       a;
    reg     [PW-1:0]        p;

    reg     [PW:0]          x1;
    reg     [PW:0]          x2;

    reg     [ODW-1:0]       r;

    //fsm control signal
    wire                    start;
    wire                    u_zero;
    wire                    u_even;
    wire                    v_even;
    wire                    finish;
    wire                    u_ge_v;

    assign  start           =       i_valid & o_ready;
    assign  u_zero          =       u == 0;
    assign  u_even          =       (~u[0]) ? 1'b1 : 1'b0;
    assign  v_even          =       (~v[0]) ? 1'b1 : 1'b0;
    assign  u_ge_v          =       u > v;
    //assign  u_ge_v          =       
    
    //keep the data of p
    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn) begin
            a               <=      {(IDW){1'b0}};
            p               <=      {(PW){1'b0}};
        end
        else if(start) begin
            a               <=      i_a;
            p               <=      i_p;
        end
    end

    ////////////////////////////////
    //      Main Code
    ////////////////////////////////
    //fsm first
    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn)
            cur_sta         <=      IDLE;
        else
            cur_sta         <=      nxt_sta; 
    end
    //fsm second
    always @(*) begin
        nxt_sta             =   IDLE;
        case(cur_sta) 
            IDLE : begin
                if(start)
                    nxt_sta =   S1;
                else
                    nxt_sta =   IDLE;
            end

            S1 : begin
                if(!u_zero && u_even)
                    nxt_sta =   S2;
                else if(!u_zero && !u_even && v_even)
                    nxt_sta =   S3;
                else if(!u_zero && !u_even && !v_even)
                    nxt_sta =   S4;
                else
                    nxt_sta =   S7;
            end

            S2 : begin
                if(!u_even && v_even)
                    nxt_sta =   S3;
                else if(!u_even && !v_even)
                    nxt_sta =   S4;
                else
                    nxt_sta =   S2;
            end

            S3 : begin
                if(!v_even)
                    nxt_sta =   S4;
                else
                    nxt_sta =   S3;
            end

            S4 : begin
                if(u_ge_v)
                    nxt_sta =   S5;
                else
                    nxt_sta =   S6;
            end

            S5 : begin
                if(!u_zero && !u_even && !v_even)
                    nxt_sta =   S4;
                else if(!u_zero && !u_even && v_even)
                    nxt_sta =   S3;
                else if(!u_zero && u_even)
                    nxt_sta =   S2;
                else
                    nxt_sta =   S7;
            end

            S6 : begin
                if(!u_zero && !u_even && !v_even)
                    nxt_sta =   S4;
                else if(!u_zero && !u_even && v_even)
                    nxt_sta =   S3;
                else if(!u_zero && u_even)
                    nxt_sta =   S2;
                else
                    nxt_sta =   S7;
            end

            S7 : begin
                nxt_sta     =   S8;
            end

            S8 : begin
                if(o_valid && i_ready)
                    nxt_sta =   IDLE;
                else
                    nxt_sta =   S8;
            end

            default : ;
        endcase
    end
    //fsm third
    //the input of the signals
    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn) begin
            x1                  <=      {(PW+1){1'b0}};
            x2                  <=      {(PW+1){1'b0}};
            r                   <=      {(ODW){1'b0}};
        end
        else begin
            case(nxt_sta)
                S1 : begin                    
                    x1          <=      {{(PW){1'b0}},1'b1};
                    x2          <=      {(PW+1){1'b0}};
                end

                S2 : begin
                    if(!x1[0])
                        x1      <=      x1 >> 1;
                    else 
                        x1      <=      (x1 + p) >> 1;
                end

                S3 : begin
                    if(!x2[0])
                        x2      <=      x2 >> 1;
                    else
                        x2      <=      (x2 + p) >> 1;
                end

                S5 : begin
                    if(x1 > x2)
                        x1      <=      x1 - x2;
                    else
                        x1      <=      x1 + p - x2;
                end 

                S6 : begin
                    if(x1 < x2)
                        x2      <=      x2 - x1;
                    else
                        x2      <=      x2 + p - x1; 
                end

                S7 : begin
                    r           <=      x2 % p;
                end

                default: ;
            endcase
        end
    end

    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn) begin
            u                   <=      {(IDW){1'b0}};
            v                   <=      {(PW){1'b0}};
        end
        else begin
            case(nxt_sta)
                S1 : begin
                    u           <=      i_a;
                    v           <=      i_p;
                end

                S2 : begin
                    if(!u[0])
                        u       <=      u >> 1;
                end

                S3 : begin
                    if(!v[0])
                        v       <=      v >> 1;
                end

                S5 : begin
                    if(v <= u)
                        u       <=      u - v;
                end

                S6 : begin
                    if(u < v)
                        v       <=      v - u;
                end

                default : ;
            endcase
        end
    end

    assign  finish  =   cur_sta == S8;
    assign  o_m_b   =   finish ? p - r : 0;
    assign  o_ready =   cur_sta == IDLE;
endmodule
*/

module mmm_mod_inv #(
    parameter               IDW1    =       258,
    parameter               IDW2    =       260,
    parameter               ODW     =       259,
    parameter               N       =       256,
    parameter               NW      =       $clog2(N),
    parameter               PW      =       260,
    parameter               MOD     =       0           //mode select
)(
    //system signals
    input                   i_clk,
    input                   i_rstn,
    //input singals
    //input                   i_valid,
    //output                  o_ready,
    input                   i_en,
    input   [IDW1-1:0]       i_a,
    input   [IDW2-1:0]      i_p,

    input                   i_ready,
    output                  o_valid,
    output  [ODW-1:0]       o_m_b
);

    //defination of the localparam
    //fsm
    localparam              IDLE    =   3'b000;
    localparam              INITIAL =   3'b001;
    localparam              JUDGE   =   3'b010;
    localparam              S1      =   3'b011;
    localparam              S2      =   3'b100;
    localparam              S3      =   3'b101;
    localparam              S4      =   3'b110;
    localparam              OUT     =   3'b111;

    //defination of the reg and wire
    reg     [2:0]           cur_sta;
    reg     [2:0]           nxt_sta;

    wire                    en_inv;

    //reg and wire
    reg     [IDW1-1:0]      u;
    reg     [PW:0]          v;
    reg     [PW:0]          x;
    reg     [PW:0]          y;
    reg     [PW-1:0]        p;

    wire                    flag;
    reg     [ODW-1:0]       r;

    assign  en_inv          =       i_en;

    //main code of the fsm
    //first stage
    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn)
            cur_sta         <=      IDLE;
        else
            cur_sta         <=      nxt_sta;
    end
    //second stage
    always @(*) begin
        nxt_sta             =       IDLE;
        case(cur_sta) 
            IDLE : begin
                if(en_inv)
                    nxt_sta =       INITIAL;
                else
                    nxt_sta =       IDLE;
            end

            INITIAL : begin
                if((u != 1) && (v != 1))
                    nxt_sta =       JUDGE;
                else
                    nxt_sta =       OUT;
            end

            JUDGE : begin
                if(u == 1)
                    nxt_sta =       OUT;
                else if(u[0] == 0)
                    nxt_sta =       S1;
                else if((u[0] == 1) && (v[0] == 0)) 
                    nxt_sta =       S2;
                else if(u[0] & v[0] & (!u[258]))
                    nxt_sta =       S3;
                else if(u[0] & v[0] & u[258])
                    nxt_sta =       S4;
            end

            S1 : begin
                nxt_sta     =       JUDGE;
            end

            S2 : begin
                nxt_sta     =       JUDGE;
            end

            S3 : begin
                nxt_sta     =       JUDGE;
            end

            S4 : begin
                nxt_sta     =       JUDGE;
            end

            OUT : begin
                if(!en_inv)
                    nxt_sta =       IDLE;
                else
                    nxt_sta =       OUT;
            end
        endcase
    end
    //third stage
    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn) begin
            u               <=      {(IDW1){1'b0}};
            v               <=      {(PW+1){1'b0}};
            p               <=      {(PW){1'b0}};
        end
        else begin

            case(nxt_sta) 
                INITIAL : begin
                    u       <=      i_a;
                    v       <=      i_p;
                    p       <=      i_p;
                end

                S1 : begin
                    if(u[0] == 0)
                        u       <=      u >> 1;
                end

                S2 : begin
                    if(v[0] == 0)
                        v       <=      v >> 1;
                end

                S3 : begin
                    if(v <= u)
                        u   <=      (u - v) >> 1;                 
                    else
                        u   <=      u;
                end

                S4 : begin
                    if(u < v) begin
                        v   <=      (v - u) >> 1;
                    end
                    else begin
                        v   <=      v;
                    end
                end

                default : ;
            endcase
        end
    end

    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn) begin
            x               <=      {(PW+1){1'b0}};
            y               <=      {(PW+1){1'b0}};
            r               <=      {(ODW){1'b0}};
            //flag            <=      1'b0;
        end
        else begin
            case(nxt_sta) 
                INITIAL : begin
                    x       <=      {{(260){1'b0}},1'b1};
                    y       <=      {(261){1'b0}};
                end

                S1 : begin
                    if(x[0] == 0)
                        x   <=      x >> 1;
                    else
                        x   <=      (x ^ p) >> 1;
                end

                S2 : begin
                    if(y[0] == 0)
                        y   <=      y >> 1;
                    else begin
                        y   <=      (y ^ p) >> 1;
                    end
                end

                S3 : begin
                    if(v <= u) begin                         
                        //if(x > y) begin
                        //    if(x[0] == y[0])
                        //        x   <=  (x - y) >> 1;
                        //    else
                        //        x   <=  (x - y + p) >> 1;
                        //end
                        //else begin
                        //    if(x[0] == y[0])
                        //        x   <=  (x - y) >> 1 + p;
                        //    else
                        //        x   <=  (x - y + p) >> 1; 
                        //end  
                        if(x[0] == y[0])
                            x   <=  (x ^ y) >> 1;
                        else
                            x   <=  (x ^ y ^ p) >> 1;                       
                    end
                end

                S4 : begin
                    if(u < v) begin
                        //if(x < y) begin
                        //    if(x[0] == y[0])
                        //        y   <=  (y - x) >> 1;
                        //    else
                        //        y   <=  (y - x + p) >> 1;
                        //end
                        //else begin
                        //    if(x[0] == y[0])
                        //        y   <=  (y - x + p) >> 1;
                        //    else
                        //        y   <=  ((y - x) >> 1) + p;
                        //end

                        if(x[0] == y[0])
                            y   <=  (x ^ y) >> 1;
                        else
                            y   <=  (x ^ y ^ p) >> 1;
                    end
                end

                OUT : begin
                    if(u == 1) begin
                        r                   <=  x % p;
                    end
                    else begin
                        r                   <=  y % p;          
                    end
                end
            endcase
        end
    end

    assign  flag = cur_sta == OUT;
endmodule