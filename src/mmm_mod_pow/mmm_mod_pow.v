//the modular pow (x ^ e) mod p
//author : Lee
module mmm_mod_pow #(
    parameter               WIDTH   =   256,
    parameter               POW     =   5
)(
    //system signals
    input                   i_clk,
    input                   i_rstn,
    //input signals
    //input                   i_valid,
    input   [WIDTH-1:0]     i_x,
    input   [WIDTH-1:0]     i_p,
    input   [WIDTH+2:0]     i_m_b,

    output  [WIDTH-1:0]     o_res
);
    //parameter defination 
    parameter               IDLE    =   2'b00;
    parameter               S1      =   2'b01;
    parameter               S2      =   2'b10;
    parameter               S3      =   2'b11;

    //defination of the reg and wire
    wire    [WIDTH-1:0]     c;
    wire    [WIDTH-1:0]     s;
    wire    [WIDTH-1:0]     p;
    wire    [WIDTH+2:0]     m_b;

    wire    [WIDTH-1:0]     c1;
    wire    [WIDTH-1:0]     s1;
    wire    [WIDTH-1:0]     p1;
    wire    [WIDTH+2:0]     m_b1;

    wire    [WIDTH-1:0]     c2;
    wire    [WIDTH-1:0]     s2;
    wire    [WIDTH-1:0]     p2;
    wire    [WIDTH+2:0]     m_b2;

    wire    [WIDTH-1:0]     res;
    //step 1
    mmm_nlp_shift_reg #(
        .LATENCY    (1),
        .WD         (4*WIDTH+3)
    ) shift_reg_1 (
        .i_clk      (i_clk),
        .i_rstn     (i_rstn),
        .i_a        ({{255'b0,1'b1},i_x,i_p,i_m_b}),
        .o_b        ({c,s,p,m_b})   
    );
    //step 2 : if(3'b101[2]) S*C mod N
    mmm_nlp_256b    #(
        .ODW        (WIDTH),
        .IDW        (WIDTH),
        .DIVW       (87)
    ) u_mmm_nlp_256b_1   (
        .i_clk      (i_clk),
        .i_rstn     (i_rstn),
        .i_a        (s),
        .i_b        (c),
        .i_m        (p),
        .i_m_b      (m_b),

        .o_res      (c1)
    );

    mmm_nlp_256b    #(      //S=S*S mod N
        .ODW        (WIDTH),
        .IDW        (WIDTH),
        .DIVW       (87)
    ) u_mmm_nlp_256b_2   (
        .i_clk      (i_clk),
        .i_rstn     (i_rstn),
        .i_a        (s),
        .i_b        (s),
        .i_m        (p),
        .i_m_b      (m_b),

        .o_res      (s1)
    );

    mmm_nlp_shift_reg #(
        .LATENCY    (16),
        .WD         (WIDTH+3)
    ) shift_reg_2 (
        .i_clk      (i_clk),
        .i_rstn     (i_rstn),
        .i_a        (m_b),
        .o_b        (m_b1)   
    );

     mmm_nlp_shift_reg #(
        .LATENCY    (16),
        .WD         (WIDTH)
    ) shift_reg_3 (
        .i_clk      (i_clk),
        .i_rstn     (i_rstn),
        .i_a        (p),
        .o_b        (p1)   
    );
    //step 3
     mmm_nlp_256b    #(      //need the M^-1 mod p
        .ODW        (WIDTH),
        .IDW        (WIDTH),
        .DIVW       (87)
    ) u_mmm_nlp_256b_3   (
        .i_clk      (i_clk),
        .i_rstn     (i_rstn),
        .i_a        (s1),
        .i_b        (s1),
        .i_m        (p1),
        .i_m_b      (m_b1),

        .o_res      (s2)
    );

    mmm_nlp_shift_reg #(
        .LATENCY    (16),
        .WD         (WIDTH+3)
    ) shift_reg_4 (
        .i_clk      (i_clk),
        .i_rstn     (i_rstn),
        .i_a        (m_b1),
        .o_b        (m_b2)   
    );

    mmm_nlp_shift_reg #(
        .LATENCY    (16),
        .WD         (WIDTH)
    ) shift_reg_5 (
        .i_clk      (i_clk),
        .i_rstn     (i_rstn),
        .i_a        (c1),
        .o_b        (c2)   
    );

     mmm_nlp_shift_reg #(
        .LATENCY    (16),
        .WD         (WIDTH)
    ) shift_reg_6 (
        .i_clk      (i_clk),
        .i_rstn     (i_rstn),
        .i_a        (p1),
        .o_b        (p2)   
    );
    //step 4 : C = S*C mod N
     mmm_nlp_256b    #(
        .ODW        (WIDTH),
        .IDW        (WIDTH),
        .DIVW       (87)
    ) u_mmm_nlp_256b_4   (
        .i_clk      (i_clk),
        .i_rstn     (i_rstn),
        .i_a        (s2),
        .i_b        (c2),
        .i_m        (p2),
        .i_m_b      (m_b2),

        .o_res      (res)
    );
    /*
    //defination of the reg and wire
    reg     [1:0]           cur_sta;
    reg     [1:0]           nxt_sta;

    //reg     [:] ;
    reg     [3:0]           cyc_cnt1;
    reg     [3:0]           cyc_cnt2;

    //defination of the fsm
    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn)
            cur_sta     <=  IDLE;
        else
            cur_sta     <=  nxt_sta;
    end

    always @(*) begin
        nxt_sta     =   IDLE;
        case(cur_sta)
            IDLE : begin
                if(i_valid)
                    nxt_sta =   S1;
                else
                    nxt_sta =   IDLE;
            end

            S1 : begin
                if(cyc_cnt == 16)
                    nxt_sta =   S2;
                else
                    nxt_sta =   S1;
            end

            S2 : begin
                
            end
        endcase
    end*/

    assign  o_res = res;
endmodule