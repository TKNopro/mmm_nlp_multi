//the mmm mult with NLP form 
//author : Lee
module mmm_nlp_256b #(
    parameter               IDW         =   256,
    parameter               ODW         =   261,
    parameter               DW          =   87,
    parameter               MW          =   90,
    parameter               LATENCY3    =   1
)(
    //system signals
    input                   i_clk,
    input                   i_rstn,
    //input signals
    input   [IDW-1:0]       i_a,
    input   [IDW-1:0]       i_b,
    input   [IDW-1:0]       i_m,
    input   [IDW+2:0]       i_m_b,
    
    output  [ODW-1:0]       o_res
);  

    //parameter
    //parameter               = ;
    //reg and wire
    //the signal of input
    reg     [DW-1:0]        A0;
    reg     [DW-1:0]        A1;
    reg     [DW-1:0]        A2;

    reg     [DW-1:0]        B0;
    reg     [DW-1:0]        B1;
    reg     [DW-1:0]        B2;

    reg     [DW-1:0]        MB0;
    reg     [DW-1:0]        MB1;
    reg     [DW-1:0]        MB2;

    reg     [DW-1:0]        M0;
    reg     [DW-1:0]        M1;
    reg     [DW-1:0]        M2;

    wire    [DW-1:0]        MB0_reg;
    wire    [DW-1:0]        MB1_reg;
    wire    [DW-1:0]        MB2_reg;

    wire    [DW-1:0]        M0_reg;
    wire    [DW-1:0]        M1_reg;
    wire    [DW-1:0]        M2_reg;

    //the signal of multi
    reg     [MW-1:0]        a0;
    reg     [MW-1:0]        a1;
    reg     [MW-1:0]        a2;

    reg     [MW-1:0]        b0;
    reg     [MW-1:0]        b1;
    reg     [MW-1:0]        b2;

    reg     [MW-1:0]        m0;
    reg     [MW-1:0]        m1;
    reg     [MW-1:0]        m2;

    reg     [MW-1:0]        a1_a_a2;
    reg     [MW-1:0]        b1_a_b2;
    reg     [MW-1:0]        a0_a_a1;
    reg     [MW-1:0]        b0_a_b1;
    reg     [MW-1:0]        a0_a_a2;
    reg     [MW-1:0]        b0_a_b2;

    //the output of the multiplexer
    wire    [2*MW:0]        a0b0;
    wire    [2*MW:0]        a1b1;
    wire    [2*MW:0]        a2b2;
    wire    [2*MW:0]        a0a1_m_b0b1;
    wire    [2*MW:0]        a0a2_m_b0b2;
    wire    [2*MW:0]        a1a2_m_b1b2;

    ///////////////////////////
    //Main Code
    ///////////////////////////
    always @(*) begin
        {A2,A1,A0}      =   {{(3*DW-IDW){1'b0}},i_a};
        {B2,B1,B0}      =   {{(3*DW-IDW){1'b0}},i_b};
        {M2,M1,M0}      =   {{(3*DW-IDW){1'b0}},i_m};
        {MB2,MB1,MB0}   =   {{(3*DW-IDW-3){1'b0}},i_m_b};
    end

    ///////////////////////////
    //delay the input of M`
    ///////////////////////////
    generate 
        if(LATENCY3) begin
            //register the result T
            mmm_nlp_shift_reg   #(
                .LATENCY        (6),
                .WD             (3*DW)
            ) u_mmm_nlp_shift_reg(
                .i_clk          (i_clk),
                .i_rstn         (i_rstn),

                .i_a            ({MB2,MB1,MB0}),
                .o_b            ({MB2_reg,MB1_reg,MB0_reg})
            );
        end
        else begin
            //register the result T
            mmm_nlp_shift_reg   #(
                .LATENCY        (7),
                .WD             (3*DW)
            ) u_mmm_nlp_shift_reg(
                .i_clk          (i_clk),
                .i_rstn         (i_rstn),

                .i_a            ({MB2,MB1,MB0}),
                .o_b            ({MB2_reg,MB1_reg,MB0_reg})
            );
        end
    endgenerate

    ///////////////////////////
    //delay the input of M
    ///////////////////////////
    generate 
        if(LATENCY3) begin
            //register the result T
            mmm_nlp_shift_reg   #(
                .LATENCY        (10),
                .WD             (3*DW)
            ) u_mmm_nlp_shift_reg(
                .i_clk          (i_clk),
                .i_rstn         (i_rstn),

                .i_a            ({M2,M1,M0}),
                .o_b            ({M2_reg,M1_reg,M0_reg})
            );
        end
        else begin
            //register the result T
            mmm_nlp_shift_reg   #(
                .LATENCY        (11),
                .WD             (3*DW)
            ) u_mmm_nlp_shift_reg(
                .i_clk          (i_clk),
                .i_rstn         (i_rstn),

                .i_a            ({M2,M1,M0}),
                .o_b            ({M2_reg,M1_reg,M0_reg})
            );
        end
    endgenerate

    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn) begin
            a0      <=  {(MW){1'b0}};
            a1      <=  {(MW){1'b0}};
            a2      <=  {(MW){1'b0}};
            b0      <=  {(MW){1'b0}};
            b1      <=  {(MW){1'b0}};
            b2      <=  {(MW){1'b0}};
            a1_a_a2 <=  {(MW){1'b0}};
            b1_a_b2 <=  {(MW){1'b0}};
            a0_a_a1 <=  {(MW){1'b0}};
            b0_a_b1 <=  {(MW){1'b0}};
            a0_a_a2 <=  {(MW){1'b0}};
            b0_a_b2 <=  {(MW){1'b0}};
        end
        else begin
            a0      <=  A0;
            a1      <=  A1;
            a2      <=  A2;
            b0      <=  B0;
            b1      <=  B1;
            b2      <=  B2;
            a1_a_a2 <=  A1 + A2;
            b1_a_b2 <=  B1 + B2;
            a0_a_a1 <=  A0 + A1;
            b0_a_b1 <=  B0 + B1;
            a0_a_a2 <=  A0 + A2;
            b0_a_b2 <=  B0 + B2;
        end
    end
    //////////////////////////////////////////////////////////////////
    //algorithm step1 (Each mult use 3cycle to output the vlaid data)
    //all cycle 6
    //////////////////////////////////////////////////////////////////
    mmm_nlp_90b_pip #(
        .ODW                (181),
        .IDW                (90),
        .OAW                (24),
        .OBW                (16),
        .LATENCY3           (LATENCY3)
    ) u_mmm_nlp_90b_pip_1 (
        .i_clk              (i_clk),
        .i_rstn             (i_rstn),    
        .i_a                (a0),
        .i_b                (b0),
        .i_carry            (0),

        .o_res              (a0b0)
    );

    mmm_nlp_90b_pip #(
        .ODW                (181),
        .IDW                (90),
        .OAW                (24),
        .OBW                (16),
        .LATENCY3           (LATENCY3)
    ) u_mmm_nlp_90b_pip_2 (
        .i_clk              (i_clk),
        .i_rstn             (i_rstn),    
        .i_a                (a1),
        .i_b                (b1),
        .i_carry            (0),

        .o_res              (a1b1)
    );

    mmm_nlp_90b_pip #(
        .ODW                (181),
        .IDW                (90),
        .OAW                (24),
        .OBW                (16),
        .LATENCY3           (LATENCY3)
    ) u_mmm_nlp_90b_pip_3 (
        .i_clk              (i_clk),
        .i_rstn             (i_rstn),    
        .i_a                (a2),
        .i_b                (b2),
        .i_carry            (0),

        .o_res              (a2b2)
    );

    mmm_nlp_90b_pip #(
        .ODW                (181),
        .IDW                (90),
        .OAW                (24),
        .OBW                (16),
        .LATENCY3           (LATENCY3)
    ) u_mmm_nlp_90b_pip_4 (
        .i_clk              (i_clk),
        .i_rstn             (i_rstn),    
        .i_a                (a0_a_a1),
        .i_b                (b0_a_b1),
        .i_carry            (0),

        .o_res              (a0a1_m_b0b1)
    );

    mmm_nlp_90b_pip #(
        .ODW                (181),
        .IDW                (90),
        .OAW                (24),
        .OBW                (16),
        .LATENCY3           (LATENCY3)
    ) u_mmm_nlp_90b_pip_5 (
        .i_clk              (i_clk),
        .i_rstn             (i_rstn),    
        .i_a                (a0_a_a2),
        .i_b                (b0_a_b2),
        .i_carry            (0),

        .o_res              (a0a2_m_b0b2)
    );

    mmm_nlp_90b_pip #(
        .ODW                (181),
        .IDW                (90),
        .OAW                (24),
        .OBW                (16),
        .LATENCY3           (LATENCY3)
    ) u_mmm_nlp_90b_pip_6 (
        .i_clk              (i_clk),
        .i_rstn             (i_rstn),    
        .i_a                (a1_a_a2),
        .i_b                (b1_a_b2),
        .i_carry            (0),

        .o_res              (a1a2_m_b1b2)
    );   

    //output of the stage 1 T~
    reg [DW-1:0]            t5;
    reg [DW-1:0]            t4;
    reg [DW-1:0]            t3;
    reg [DW-1:0]            t2;
    reg [DW-1:0]            t1;
    reg [DW-1:0]            t0;
    reg [6*DW-1:0]          T;

    reg [6*DW-1:0]          t_line1;  
    reg [6*DW-1:0]          t_line2; 
    reg [6*DW-1:0]          t_line3; 
    reg [6*DW-1:0]          t_line4;  
    reg [6*DW-1:0]          t_line5;

    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn) begin
            t_line1     <=  {(6*DW){1'b0}};
            t_line2     <=  {(6*DW){1'b0}};
            t_line3     <=  {(6*DW){1'b0}};
            t_line4     <=  {(6*DW){1'b0}};
            t_line5     <=  {(6*DW){1'b0}};
        end
        else begin
            t_line1     <=  a0b0;
            t_line2     <=  (a0a1_m_b0b1 - a0b0 - a1b1) << DW;
            t_line3     <=  (a0a2_m_b0b2 - a0b0 - a2b2 + a1b1) << (2*DW);
            t_line4     <=  (a1a2_m_b1b2 - a1b1 - a2b2) << (3*DW);
            t_line5     <=  a2b2 << (4*DW);
        end
    end

    reg [DW-1:0]            u2;
    reg [DW-1:0]            u1;
    reg [DW-1:0]            u0;

    always @(*) begin
        T                   =   t_line1 + t_line2 + t_line3 + t_line4 + t_line5;
        {t5,t4,t3,t2,t1,t0} =   T;
    end

    reg [3*DW-1:0]          xx;     
    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn) begin
            {u2,u1,u0}      <=  {(3*DW){1'b0}};
            xx              <=  {(3*DW){1'b0}};
        end
        else begin
            {u2,u1,u0}      <=  {t2,t1,t0};
            xx              <=  {t2,t1,t0};
        end
    end

    //////////////////////////////////////////////////////////////////
    //algorithm step2 (Each mult use 3cycle to output the vlaid data)
    //all cycle : 4
    //////////////////////////////////////////////////////////////////

    ///////////////////////////
    //delay the input of T~
    ///////////////////////////
    wire[4*DW-1:0]              T_;

    generate 
        if(LATENCY3) begin
            //register the result T
            mmm_nlp_shift_reg   #(
                .LATENCY        (8),
                .WD             (4*DW)
            ) u_mmm_nlp_shift_reg(
                .i_clk          (i_clk),
                .i_rstn         (i_rstn),

                .i_a            ({t5,t4,t3,t2}),
                .o_b            (T_)
            );
        end
        else begin
            //register the result T
            mmm_nlp_shift_reg   #(
                .LATENCY        (11),
                .WD             (IDW)
            ) u_mmm_nlp_shift_reg(
                .i_clk          (i_clk),
                .i_rstn         (i_rstn),

                .i_a            ({t5,t4,t3,t2}),
                .o_b            (T_)
            );
        end
    endgenerate

    reg [MW-1:0]            mb0;
    reg [MW-1:0]            mb1;
    reg [MW-1:0]            mb2;

    reg [MW-1:0]            U2;
    reg [MW-1:0]            U1;
    reg [MW-1:0]            U0;

    reg [MW-1:0]            U0_a_U1;
    reg [MW-1:0]            mb0_a_mb1;

    wire[2*MW:0]            U0mb0;
    wire[2*MW:0]            U1mb1;
    wire[2*MW:0]            U2mb0;
    wire[2*MW:0]            U0mb2;
    wire[2*MW:0]            U0U1_m_mb0mb1;

    reg [4*DW-1:0]          q_line1;
    reg [4*DW-1:0]          q_line2;
    reg [4*DW-1:0]          q_line3;

    reg [DW-1:0]            q0;
    reg [DW-1:0]            q1;
    reg [DW-1:0]            q2;

    reg [IDW+2:0]           Q;
    /*
    always @(*) begin
        {mb2,mb1,mb0}       =   {{(3*MW-3*DW){1'b0}},MB2_reg,MB1_reg,MB0_reg};
        {U2,U1,U0}          =   {{(3*MW-3*DW){1'b0}},u2,u1,u0};
    end
    */
    always @(*) begin
        mb2     =   {{(MW-DW){1'b0}},MB2_reg};
        mb1     =   {{(MW-DW){1'b0}},MB1_reg};
        mb0     =   {{(MW-DW){1'b0}},MB0_reg};
    end

    always @(*) begin
        U2     =    {{(MW-DW){1'b0}},u2};
        U1     =    {{(MW-DW){1'b0}},u1};
        U0     =    {{(MW-DW){1'b0}},u0};
    end

    always @(*) begin
        U0_a_U1             =   u0 + u1;
        mb0_a_mb1           =   mb0 + mb1;
    end

    mmm_nlp_90b_pip #(
        .ODW                (181),
        .IDW                (90),
        .OAW                (24),
        .OBW                (16),
        .LATENCY3           (LATENCY3)
    ) u_mmm_nlp_90b_pip_7 (
        .i_clk              (i_clk),
        .i_rstn             (i_rstn),    
        .i_a                (U0),
        .i_b                (mb0),
        .i_carry            (0),

        .o_res              (U0mb0)
    );

    mmm_nlp_90b_pip #(
        .ODW                (181),
        .IDW                (90),
        .OAW                (24),
        .OBW                (16),
        .LATENCY3           (LATENCY3)
    ) u_mmm_nlp_90b_pip_8 (
        .i_clk              (i_clk),
        .i_rstn             (i_rstn),    
        .i_a                (U1),
        .i_b                (mb1),
        .i_carry            (0),

        .o_res              (U1mb1)
    );

    mmm_nlp_90b_pip #(
        .ODW                (181),
        .IDW                (90),
        .OAW                (24),
        .OBW                (16),
        .LATENCY3           (LATENCY3)
    ) u_mmm_nlp_90b_pip_9 (
        .i_clk              (i_clk),
        .i_rstn             (i_rstn),    
        .i_a                (U0),
        .i_b                (mb2),
        .i_carry            (0),

        .o_res              (U0mb2)
    );

    mmm_nlp_90b_pip #(
        .ODW                (181),
        .IDW                (90),
        .OAW                (24),
        .OBW                (16),
        .LATENCY3           (LATENCY3)
    ) u_mmm_nlp_90b_pip_10 (
        .i_clk              (i_clk),
        .i_rstn             (i_rstn),    
        .i_a                (U0_a_U1),
        .i_b                (mb0_a_mb1),
        .i_carry            (0),

        .o_res              (U0U1_m_mb0mb1)
    );

    mmm_nlp_90b_pip #(
        .ODW                (181),
        .IDW                (90),
        .OAW                (24),
        .OBW                (16),
        .LATENCY3           (LATENCY3)
    ) u_mmm_nlp_90b_pip_11 (
        .i_clk              (i_clk),
        .i_rstn             (i_rstn),    
        .i_a                (U2),
        .i_b                (mb0),
        .i_carry            (0),

        .o_res              (U2mb0)
    );


    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn) begin
            q_line1         <=  {(4*DW){1'b0}};
            q_line2         <=  {(4*DW){1'b0}};
            q_line3         <=  {(4*DW){1'b0}};
        end
        else begin
            q_line1         <=  U0mb0;
            q_line2         <=  (U0U1_m_mb0mb1 - U0mb0 - U1mb1) << DW;
            q_line3         <=  (U0mb2 + U2mb0 + U1mb1) << (2*DW);
        end
    end 

    always @(*) begin
        Q       =   q_line1 + q_line2 + q_line3; 
    end 


    always @(*) begin
        q2      =   {{(3*DW-IDW-3){1'b0}},Q[IDW+2:2*DW]};//{{(3*DW-IDW-3){1'b0}},Q[IDW+2:2*DW]};
        q1      =   Q[2*DW-1:DW];//Q[2*DW-1:DW];
        q0      =   Q[DW-1:0];//Q[DW-1:0];
    end

    //////////////////////////////////////////////////////////////////
    //algorithm step3 (Each mult use 3cycle to output the vlaid data)
    //all cycle : 
    //////////////////////////////////////////////////////////////////
    reg [MW-1:0]            Q0;
    reg [MW-1:0]            Q1;
    reg [MW-1:0]            Q2;

    reg [MW-1:0]            Q1_a_Q2;
    reg [MW-1:0]            m1_a_m2;

    wire[2*MW:0]            Q0m2;
    wire[2*MW:0]            Q2m0;
    wire[2*MW:0]            Q1m1;
    wire[2*MW:0]            Q2m2;
    wire[2*MW:0]            Q1Q2_m_m1m2;

    reg [4*DW-1:0]          r_line1;
    reg [4*DW-1:0]          r_line2;
    reg [4*DW-1:0]          r_line3;
    reg [4*DW-1:0]          r_line4;

    reg [4*DW-1:0]          r_line1_reg;
    reg [4*DW-1:0]          r_line2_reg;
    reg [4*DW-1:0]          r_line3_reg;
    reg [4*DW-1:0]          r_line4_reg;

    reg [4*DW-1:0]          r_cc_reg1;
    reg [4*DW-1:0]          r_cc_reg2;
    reg [4*DW-1:0]          r_cc_reg3;
    reg [4*DW-1:0]          r_cc_reg4;
    reg [4*DW-1:0]          r_cc;

    reg [5*DW-1:0]          r;
    /*
    always @(*) begin
        {m2,m1,m0}  =   {{(3*MW-3*DW){1'b0}},M2_reg,M1_reg,M0_reg};
    end
    */
    always @(*) begin
        Q2  =   {{(MW-DW){1'b0}},q2};
        Q1  =   {{(MW-DW){1'b0}},q1};
        Q0  =   {{(MW-DW){1'b0}},q0};
    end

    always @(*) begin
        m2  =   {{(MW-DW){1'b0}},M2_reg};
        m1  =   {{(MW-DW){1'b0}},M1_reg};
        m0  =   {{(MW-DW){1'b0}},M0_reg};
    end

    always @(*) begin
        Q1_a_Q2     =   q1 + q2;
        m1_a_m2     =   m1 + m2;
    end

    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn) begin
            r_cc_reg1  <=  {(4*DW){1'b0}};
            r_cc_reg2  <=  {(4*DW){1'b0}};
            r_cc_reg3  <=  {(4*DW){1'b0}};
            r_cc_reg4  <=  {(4*DW){1'b0}};
            r_cc       <=  {(4*DW){1'b0}};
        end
        else begin
            r_cc_reg1  <=  (Q0[MW-1:DW-3]/*[IDW+1-2*DW:IDW-1-2*DW]*/ * M1_reg[DW-1:DW-3] + Q1[MW-1:DW-3] * M0_reg[DW-1:DW-3]) << (DW-6);
            r_cc_reg2  <=  r_cc_reg1;
            r_cc_reg3  <=  r_cc_reg2;
            r_cc_reg4  <=  r_cc_reg3;
            r_cc       <=  r_cc_reg4;
        end
    end

    mmm_nlp_90b_pip #(
        .ODW                (181),
        .IDW                (90),
        .OAW                (24),
        .OBW                (16),
        .LATENCY3           (LATENCY3)
    ) u_mmm_nlp_90b_pip_12 (
        .i_clk              (i_clk),
        .i_rstn             (i_rstn),    
        .i_a                (Q0),
        .i_b                (m2),
        .i_carry            (0),

        .o_res              (Q0m2)
    );

    mmm_nlp_90b_pip #(
        .ODW                (181),
        .IDW                (90),
        .OAW                (24),
        .OBW                (16),
        .LATENCY3           (LATENCY3)
    ) u_mmm_nlp_90b_pip_13 (
        .i_clk              (i_clk),
        .i_rstn             (i_rstn),    
        .i_a                (Q1),
        .i_b                (m1),
        .i_carry            (0),

        .o_res              (Q1m1)
    );

    mmm_nlp_90b_pip #(
        .ODW                (181),
        .IDW                (90),
        .OAW                (24),
        .OBW                (16),
        .LATENCY3           (LATENCY3)
    ) u_mmm_nlp_90b_pip_14 (
        .i_clk              (i_clk),
        .i_rstn             (i_rstn),    
        .i_a                (Q2),
        .i_b                (m2),
        .i_carry            (0),

        .o_res              (Q2m2)
    );

    mmm_nlp_90b_pip #(
        .ODW                (181),
        .IDW                (90),
        .OAW                (24),
        .OBW                (16),
        .LATENCY3           (LATENCY3)
    ) u_mmm_nlp_90b_pip_15 (
        .i_clk              (i_clk),
        .i_rstn             (i_rstn),    
        .i_a                (Q1_a_Q2),
        .i_b                (m1_a_m2),
        .i_carry            (0),

        .o_res              (Q1Q2_m_m1m2)
    );

    mmm_nlp_90b_pip #(
        .ODW                (181),
        .IDW                (90),
        .OAW                (24),
        .OBW                (16),
        .LATENCY3           (LATENCY3)
    ) u_mmm_nlp_90b_pip_16 (
        .i_clk              (i_clk),
        .i_rstn             (i_rstn),    
        .i_a                (Q2),
        .i_b                (m0),
        .i_carry            (0),

        .o_res              (Q2m0)
    );
 
    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn) begin
            r_line1     <=  {(4*DW){1'b0}};
            r_line2     <=  {(4*DW){1'b0}};
            r_line3     <=  {(4*DW){1'b0}};
            r_line4     <=  {(4*DW){1'b0}};
        end
        else begin
            r_line1     <=  T_;
            r_line2     <=  (Q0m2 + Q2m0 + Q1m1);
            r_line3     <=  (Q1Q2_m_m1m2 - Q1m1 - Q2m2) << (DW);
            r_line4     <=  Q2m2 << (2*DW);
        end
    end

    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn) begin
            r_line1_reg <=  {(4*DW){1'b0}};
            r_line2_reg <=  {(4*DW){1'b0}};
            r_line3_reg <=  {(4*DW){1'b0}};
            r_line4_reg <=  {(4*DW){1'b0}};
        end
        else begin
            r_line1_reg <=  r_line1;
            r_line2_reg <=  r_line2;
            r_line3_reg <=  r_line3;
            r_line4_reg <=  r_line4;
        end
    end

    reg [1:0]       cr_1;
    reg [DW-1:0]    r_1;
    reg [DW-1:0]    R_1;
    reg [1:0]       ee;

    reg [DW-1:0]    T_reg1;
    reg [DW-1:0]    T_reg2;
    reg [DW-1:0]    r_line2_reg_q;

    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn) begin
            T_reg1  <=  {(DW){1'b0}};
            T_reg2  <=  {(DW){1'b0}};
        end
        else begin
            T_reg1  <=  T_[DW-1:0];
            T_reg2  <=  T_reg1;
        end
    end

    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn)
            r_line2_reg_q <=  {(DW){1'b0}};
        else 
            r_line2_reg_q <=  r_line2[DW-1:0];
    end

    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn)
            {cr_1,r_1}      <=  {(DW+2){1'b0}};
        else
            {cr_1,r_1}      <=  T_reg2 + r_line2_reg_q + r_cc;
    end

    always @(*) begin
        ee = cr_1 + r_1[DW-1];
    end

    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn) begin
            r   <=  {(4*DW){1'b0}};
        end
        else begin
            r   <=  (r_line1_reg + r_line2_reg + r_line3_reg + r_line4_reg + r_cc) << 2;
        end
    end

    assign  o_res = r[4*DW-1:DW];
    
    reg     [ODW-1:0]   res_pre;
    reg     [ODW-1:0]   res;
    reg     [1:0]       cr_;
    reg     [DW-1:0]    r_;

    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn)
            {cr_,r_}    <=  {(DW+2){1'b0}};
        else
            {cr_,r_}    <=  {cr_1,r_1};
    end

    always @(*) begin
        if(r_1[DW-1])
            res_pre     =       r[4*DW-1:DW] + 1'b1;
        else
            res_pre     =       r[4*DW-1:DW];
    end

    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn)
            res     <=  {(ODW){1'b0}};
        else
            res     <=  res_pre;
    end
    //assign  o_res = res;
endmodule