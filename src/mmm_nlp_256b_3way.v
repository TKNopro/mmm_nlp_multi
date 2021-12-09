//the mmm mult with the NLP form
//author : Lee
module mmm_nlp_256b_3way#(
    parameter       DW3         =   522,
    parameter       ODW         =   256,
    parameter       IDW         =   256,
    parameter       DIVW        =   87,
    parameter       LATENCY3    =   1
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
    //local parameter defination
    localparam      MRW     =   181;
    localparam      MIW     =   90;
    //output signal
    reg     [ODW-1:0]       res;
    //defination of reg and wire
    wire    [DIVW-1:0]      a00;
    wire    [DIVW-1:0]      a01;
    wire    [DIVW-1:0]      a02;

    wire    [DIVW-1:0]      b00;
    wire    [DIVW-1:0]      b01;
    wire    [DIVW-1:0]      b02;

    wire    [DIVW-1:0]      m00;
    wire    [DIVW-1:0]      m01;
    wire    [DIVW-1:0]      m02;

    wire    [DIVW-1:0]      m_b00;
    wire    [DIVW-1:0]      m_b01;
    wire    [DIVW-1:0]      m_b02;

    reg     [MIW-1:0]       a0;
    reg     [MIW-1:0]       a1;
    reg     [MIW-1:0]       a2;
    reg     [MIW-1:0]       b0;
    reg     [MIW-1:0]       b1;
    reg     [MIW-1:0]       b2;

    reg     [MIW-1:0]       a0_a_a1;
    reg     [MIW-1:0]       b0_a_b1;
    reg     [MIW-1:0]       a0_a_a2;
    reg     [MIW-1:0]       b0_a_b2;
    reg     [MIW-1:0]       a1_a_a2;
    reg     [MIW-1:0]       b1_a_b2;

    wire    [MRW-1:0]       a0b0;
    wire    [MRW-1:0]       a1b1;
    wire    [MRW-1:0]       a2b2;
    wire    [MRW-1:0]       a0a1_m_b0b1;
    wire    [MRW-1:0]       a0a2_m_b0b2;
    wire    [MRW-1:0]       a1a2_m_b1b2;
    //defination of reg
    //the reg of the p
    reg     [DIVW-1:0]      p2h;
    reg     [DIVW-1:0]      p2l;
    reg     [DIVW-1:0]      p1h;
    reg     [DIVW-1:0]      p1l;
    reg     [DIVW:0]        p12h;
    reg     [DIVW-1:0]      p12l;
    reg     [DIVW-1:0]      p0h;
    reg     [DIVW-1:0]      p0l;
    reg     [DIVW:0]        p01h;
    reg     [DIVW-1:0]      p01l;
    reg     [DIVW:0]        p02h;
    reg     [DIVW-1:0]      p02l;

    reg     [2*DIVW:0]      p0;
    reg     [2*DIVW:0]      p1;
    reg     [2*DIVW:0]      p2;
    reg     [2*DIVW:0]      p01;
    reg     [2*DIVW:0]      p02;
    reg     [2*DIVW:0]      p12;

    //the reg of the line
    /*
    reg     [DW3-1:0]       line02;
    reg     [DW3-1:0]       line03;
    reg     [DW3-1:0]       line04;
    

    reg     [DW3-1:0]       line1;
    reg     [DW3-1:0]       line2;
    reg     [DW3-1:0]       line3;
    reg     [DW3-1:0]       line4;
    reg     [DW3-1:0]       line5;
    */

    wire    [DW3-1:0]       T;
    wire    [DW3-1:0]       T_;

    reg     [DIVW-1:0]      t0;
    reg     [DIVW-1:0]      t1;
    reg     [DIVW-1:0]      t2;
    reg     [DIVW-1:0]      t3;
    reg     [DIVW-1:0]      t4;
    reg     [DIVW-1:0]      t5;

    reg     [3*DIVW-1:0]    u;
    reg     [DIVW-1:0]      u0;
    reg     [DIVW-1:0]      u1;
    reg     [DIVW-1:0]      u2;

    ////////////////////////////////////////////////
    //                   Main Code                //
    ////////////////////////////////////////////////
    assign  {a02,a01,a00}       =   {5'b0,i_a};
    assign  {b02,b01,b00}       =   {5'b0,i_b};

    ///////////to register the input of i_m/////////
    generate
        if(LATENCY3) begin
            reg [IDW-1:0]       m_reg1;
            reg [IDW-1:0]       m_reg2;
            reg [IDW-1:0]       m_reg3;
            reg [IDW-1:0]       m_reg4;
            reg [IDW-1:0]       m_reg5;
            reg [IDW-1:0]       m_reg6;
            reg [IDW-1:0]       m_reg7;
            reg [IDW-1:0]       m_reg8;
            reg [IDW-1:0]       m_reg9;
            
            always @(posedge i_clk or negedge i_rstn) begin
                if(!i_rstn) begin
                    m_reg1      <=  {(IDW){1'b0}};
                    m_reg2      <=  {(IDW){1'b0}};
                    m_reg3      <=  {(IDW){1'b0}};
                    m_reg4      <=  {(IDW){1'b0}};
                    m_reg5      <=  {(IDW){1'b0}};
                    m_reg6      <=  {(IDW){1'b0}};
                    m_reg7      <=  {(IDW){1'b0}};
                    m_reg8      <=  {(IDW){1'b0}};
                    m_reg9      <=  {(IDW){1'b0}};
                end
                else begin
                    m_reg1      <=  i_m;
                    m_reg2      <=  m_reg1;
                    m_reg3      <=  m_reg2;
                    m_reg4      <=  m_reg3;
                    m_reg5      <=  m_reg4;
                    m_reg6      <=  m_reg5;
                    m_reg7      <=  m_reg6;
                    m_reg8      <=  m_reg7;
                    m_reg9      <=  m_reg8;
                end
            end

            assign  {m02,m01,m00} =   {5'b0,m_reg9};
        end
        else begin
            reg [IDW-1:0]       m_reg1;
            reg [IDW-1:0]       m_reg2;
            reg [IDW-1:0]       m_reg3;
            reg [IDW-1:0]       m_reg4;
            reg [IDW-1:0]       m_reg5;
            reg [IDW-1:0]       m_reg6;
            reg [IDW-1:0]       m_reg7;
            
            always @(posedge i_clk or negedge i_rstn) begin
                if(!i_rstn) begin
                    m_reg1      <=  {(IDW){1'b0}};
                    m_reg2      <=  {(IDW){1'b0}};
                    m_reg3      <=  {(IDW){1'b0}};
                    m_reg4      <=  {(IDW){1'b0}};
                    m_reg5      <=  {(IDW){1'b0}};
                    m_reg6      <=  {(IDW){1'b0}};
                    m_reg7      <=  {(IDW){1'b0}};
                end
                else begin
                    m_reg1      <=  i_m;
                    m_reg2      <=  m_reg1;
                    m_reg3      <=  m_reg2;
                    m_reg4      <=  m_reg3;
                    m_reg5      <=  m_reg4;
                    m_reg6      <=  m_reg5;
                    m_reg7      <=  m_reg6;
                end
            end

            assign  {m02,m01,m00} =   {5'b0,m_reg6};
        end
    endgenerate

    //////////to register the input of i_m_b////////
    generate
        if(LATENCY3) begin
            reg [IDW+2:0]       m_b_reg1;
            reg [IDW+2:0]       m_b_reg2;
            reg [IDW+2:0]       m_b_reg3;
            reg [IDW+2:0]       m_b_reg4;
            reg [IDW+2:0]       m_b_reg5;
            
            always @(posedge i_clk or negedge i_rstn) begin
                if(!i_rstn) begin
                    m_b_reg1    <=  {(IDW){1'b0}};
                    m_b_reg2    <=  {(IDW){1'b0}};
                    m_b_reg3    <=  {(IDW){1'b0}};
                    m_b_reg4    <=  {(IDW){1'b0}};
                    m_b_reg5    <=  {(IDW){1'b0}};
                end
                else begin
                    m_b_reg1    <=  i_m_b;
                    m_b_reg2    <=  m_b_reg1;
                    m_b_reg3    <=  m_b_reg2;
                    m_b_reg4    <=  m_b_reg3;
                    m_b_reg5    <=  m_b_reg4;
                end
            end

            assign  {m_b02,m_b01,m_b00} =   {2'b0,m_b_reg5};
        end
        else begin
            reg [IDW+2:0]       m_b_reg1;
            reg [IDW+2:0]       m_b_reg2;
            reg [IDW+2:0]       m_b_reg3;
            reg [IDW+2:0]       m_b_reg4;

            always @(posedge i_clk or negedge i_rstn) begin
                if(!i_rstn) begin
                    m_b_reg1    <=  {(IDW){1'b0}};
                    m_b_reg2    <=  {(IDW){1'b0}};
                    m_b_reg3    <=  {(IDW){1'b0}};
                    m_b_reg4    <=  {(IDW){1'b0}};
                end
                else begin
                    m_b_reg1    <=  i_m_b;
                    m_b_reg2    <=  m_b_reg1;
                    m_b_reg3    <=  m_b_reg2;
                    m_b_reg4    <=  m_b_reg3;
                end
            end

            assign  {m_b02,m_b01,m_b00} =   {2'b0,m_b_reg4};
        end
    endgenerate
    //////////to register the input of i_m_b////////
    
    ////////////////////////////////////////////////
    //The first step of the MMM multiplication
    ////////////////////////////////////////////////
    //add of input (should be as a pipeline)
    //(This stage can be cancelled)
    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn) begin
            a0      <=  {MIW{1'b0}}; 
            a1      <=  {MIW{1'b0}}; 
            a2      <=  {MIW{1'b0}}; 
            b0      <=  {MIW{1'b0}}; 
            b1      <=  {MIW{1'b0}}; 
            b2      <=  {MIW{1'b0}}; 
            a0_a_a1 <=  {MIW{1'b0}};
            b0_a_b1 <=  {MIW{1'b0}};
            a0_a_a2 <=  {MIW{1'b0}};
            b0_a_b2 <=  {MIW{1'b0}};
            a1_a_a2 <=  {MIW{1'b0}};
            b1_a_b2 <=  {MIW{1'b0}};
        end
        else begin
            a0      <=  {3'b0,a00};
            a1      <=  {3'b0,a01};
            a2      <=  {3'b0,a02};
            b0      <=  {3'b0,b00};
            b1      <=  {3'b0,b01};
            b2      <=  {3'b0,b02};
            a0_a_a1 <=  a00 + a01;
            b0_a_b1 <=  b00 + b01;
            a0_a_a2 <=  a00 + a02;
            b0_a_b2 <=  b00 + b02;
            a1_a_a2 <=  a01 + a02;
            b1_a_b2 <=  b01 + b02;
        end
    end

    //algorithm step1 (Each mult use 3cycle to output the vlaid data)
    mmm_nlp_90b_pip #(
        .ODW        (181),
        .IDW        (90),
        .OAW        (24),
        .OBW        (16),
        .LATENCY3   (LATENCY3)
    ) u_mmm_nlp_90b_pip_1 (
        .i_clk      (i_clk),
        .i_rstn     (i_rstn),    
        .i_a        (a0),
        .i_b        (b0),
        .i_carry    (0),

        .o_res      (a0b0)
    );

    mmm_nlp_90b_pip #(
        .ODW        (181),
        .IDW        (90),
        .OAW        (24),
        .OBW        (16),
        .LATENCY3   (LATENCY3)
    ) u_mmm_nlp_90b_pip_2 (
        .i_clk      (i_clk),
        .i_rstn     (i_rstn),    
        .i_a        (a1),
        .i_b        (b1),
        .i_carry    (0),

        .o_res      (a1b1)
    );

    mmm_nlp_90b_pip #(
        .ODW        (181),
        .IDW        (90),
        .OAW        (24),
        .OBW        (16),
        .LATENCY3   (LATENCY3)
    ) u_mmm_nlp_90b_pip_3 (
        .i_clk      (i_clk),
        .i_rstn     (i_rstn),    
        .i_a        (a2),
        .i_b        (b2),
        .i_carry    (0),

        .o_res      (a2b2)
    );

    mmm_nlp_90b_pip #(
        .ODW        (181),
        .IDW        (90),
        .OAW        (24),
        .OBW        (16),
        .LATENCY3   (LATENCY3)
    ) u_mmm_nlp_90b_pip_4 (
        .i_clk      (i_clk),
        .i_rstn     (i_rstn),    
        .i_a        (a0_a_a1),
        .i_b        (b0_a_b1),
        .i_carry    (0),

        .o_res      (a0a1_m_b0b1)
    );

    mmm_nlp_90b_pip #(
        .ODW        (181),
        .IDW        (90),
        .OAW        (24),
        .OBW        (16),
        .LATENCY3   (LATENCY3)
    ) u_mmm_nlp_90b_pip_5 (
        .i_clk      (i_clk),
        .i_rstn     (i_rstn),    
        .i_a        (a0_a_a2),
        .i_b        (b0_a_b2),
        .i_carry    (0),

        .o_res      (a0a2_m_b0b2)
    );

    mmm_nlp_90b_pip #(
        .ODW        (181),
        .IDW        (90),
        .OAW        (24),
        .OBW        (16),
        .LATENCY3   (LATENCY3)
    ) u_mmm_nlp_90b_pip_6 (
        .i_clk      (i_clk),
        .i_rstn     (i_rstn),    
        .i_a        (a1_a_a2),
        .i_b        (b1_a_b2),
        .i_carry    (0),

        .o_res      (a1a2_m_b1b2)
    );

    //extends the nlp multi output
    /*
    always @(*) begin
        line02  =   a0a1_m_b0b1 - a0b0 - a1b1;
        line03  =   a0a2_m_b0b2 - a0b0 - a2b2 + a1b1;
        line04  =   a1a2_m_b1b2 - a1b1 - a2b2;
    end
    */
    //karatsuba stage 1
    /*
    always @(*) begin
        line1   =  {{(ODW-MIW){1'b0}},a0b0};
        line2   =  {{(ODW-MIW){1'b0}},{a0a1_m_b0b1 - a0b0 - a1b1}} << 87;
        line3   =  {{(ODW-MIW){1'b0}},{a0a2_m_b0b2 - a0b0 - a2b2 + a1b1}} << 174;
        line4   =  {{(ODW-MIW){1'b0}},{a1a2_m_b1b2 - a1b1 - a2b2}} << 261;
        line5   =  {{(ODW-MIW){1'b0}},a2b2} << 348;
    end
    */
    //The reseult of the algrothim in stage 1
    //assign  T = line1 + line2 + line3 + line4 + line5;
    //register the p MSB and LSB
    always @(*) begin
        {p0h,p0l}   =   a0b0[173:0];
        {p1h,p1l}   =   a1b1[173:0];
        {p2h,p2l}   =   a2b2[173:0];
        {p01h,p01l} =   a0a1_m_b0b1 - p0 - p1 + p0h;
        {p02h,p02l} =   a0a2_m_b0b2 + p1 - p0 - p2 + p01h;
        {p12h,p12l} =   a1a2_m_b1b2 - p1 - p2;
    end

    always @(*) begin
        p0          =   {p0h,p0l};
        p1          =   {p1h,p1l};
        p2          =   {p2h,p2l};
        p01         =   {p01h,p01l};
        p02         =   {p02h,p02l};
        p12         =   {p12h,p12l};
    end

    always @(*) begin
        P0H         =   p0h;
        P0L         =   p0l;
        P0          =   p0;
        P1H         =   p1h;
        P1L         =   p1l;
        P1          =   p1;
        P2H         =   p2h;
        P2L         =   p2l;
        P2          =   p2;
    end
    ////////////////////////////////////////////////////
    // The test part of the stage one 
    ////////////////////////////////////////////////////
    reg [DW3-1:0]           TP5;
    reg [DW3-1:0]           TP4;
    reg [DW3-1:0]           TP3;
    reg [DW3-1:0]           TP2;
    reg [DW3-1:0]           TP1;
    reg [DW3-1:0]           TP0;

    always @(*) begin
        TP5     =   p2h <<  (5*DIVW);
        TP4     =   (p2l + p12h) << (4*DIVW);       
        TP3     =   (p12l + p02h) << (3*DIVW);
        TP2     =   p02l << (2*DIVW);
        TP1     =   p01l << (DIVW);
        TP0     =   p0l;
    end


    assign  T = TP5 + TP4 + TP3 + TP2 + TP1 + TP0;
    //the output of the stage 1 in algorithm2
    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn) begin
            {t5,t4,t3,t2,t1,t0} <=  {(6*DIVW){1'b0}};
            /*
            {u2,u1,u0}          <=  {(3*DIVW){1'b0}};
            u                   <=  {(3*DIVW){1'b0}};
            */
        end
        else begin
            {t5,t4,t3,t2,t1,t0} <=  T;
            /*
            {u2,u1,u0}          <=  {t2,t1,t0};
            u                   <=  {u2,u1,u0};
            */
        end
    end

    always @(*) begin
        {u2,u1,u0}      =   {t2,t1,t0};
    end 

    //register the result T
    mmm_nlp_shift_reg   #(
        .LATENCY        (8),
        .WD             (522)
    ) u_mmm_nlp_shift_reg(
        .i_clk          (i_clk),
        .i_rstn         (i_rstn),

        .i_a            (T),
        .o_b            (T_)
    );
    
    ////////////////////////////////////////////////
    //The second step of the MMM multiplication
    ////////////////////////////////////////////////
    //the signal of the stage 2
    reg [MIW-1:0]           u0_;
    reg [MIW-1:0]           m0_;
    reg [MIW-1:0]           u1_;
    reg [MIW-1:0]           m1_;
    reg [MIW-1:0]           u2_;
    reg [MIW-1:0]           m2_;

    wire[MRW-1:0]           u0m0;
    wire[MRW-1:0]           u1m1;
    wire[MRW-1:0]           u2m0;
    wire[MRW-1:0]           u0m2;
    wire[MRW-1:0]           u0u1_m_m0m1;

    reg [MIW-1:0]           u0_a_u1;
    reg [MIW-1:0]           m0_a_m1;   
    //reg and wire (maybe not used)
    reg [DIVW-1:0]          P2H;
    reg [DIVW-1:0]          P2L;
    reg [2*DIVW-1:0]        P2;

    //the stage 2 of the second stage of the algorithm
    reg [DIVW-1:0]          P0H;
    reg [DIVW-1:0]          P0L;
    reg [2*DIVW-1:0]        P0;
    reg [DIVW-1:0]          P1H;
    reg [DIVW-1:0]          P1L;
    reg [2*DIVW-1:0]        P1;
    reg [2*DIVW-1:0]        PP02;
    reg [DIVW-1:0]          P01H;
    reg [DIVW-1:0]          P01L;
    reg [DIVW-1:0]          PP20H;
    reg [DIVW-1:0]          PP20L;

    reg [3*DIVW-1:0]        q_line1;
    reg [3*DIVW-1:0]        q_line2;
    reg [3*DIVW-1:0]        q_line3;
    reg [3*DIVW-1:0]        Q;

    always @(*) begin
        u0_     =   {3'b0,u0};
        m0_     =   {3'b0,m_b00};
        u1_     =   {3'b0,u1};
        m1_     =   {3'b0,m_b01};
        u2_     =   {3'b0,u2};
        m2_     =   {3'b0,m_b02};
    end

    always @(*) begin
        u0_a_u1 =   u0_ + u1_;
        m0_a_m1 =   m0_ + m1_;
    end

    //The multiplexer of the algorithm in stage 2
    //the multiplexer of stage 2
    //3 cycle
    mmm_nlp_90b_pip #(
        .ODW        (181),
        .IDW        (90),
        .OAW        (24),
        .OBW        (16),
        .LATENCY3   (LATENCY3)
    ) u_mmm_nlp_90b_pip_7 (
        .i_clk      (i_clk),
        .i_rstn     (i_rstn),    
        .i_a        (u0_),
        .i_b        (m0_),
        .i_carry    (0),

        .o_res      (u0m0)
    );

    mmm_nlp_90b_pip #(
        .ODW        (181),
        .IDW        (90),
        .OAW        (24),
        .OBW        (16),
        .LATENCY3   (LATENCY3)
    ) u_mmm_nlp_90b_pip_8 (
        .i_clk      (i_clk),
        .i_rstn     (i_rstn),    
        .i_a        (u1_),
        .i_b        (m1_),
        .i_carry    (0),

        .o_res      (u1m1)
    );

    mmm_nlp_90b_pip #(
        .ODW        (181),
        .IDW        (90),
        .OAW        (24),
        .OBW        (16),
        .LATENCY3   (LATENCY3)
    ) u_mmm_nlp_90b_pip_9 (
        .i_clk      (i_clk),
        .i_rstn     (i_rstn),    
        .i_a        (u0_),
        .i_b        (m2_),
        .i_carry    (0),

        .o_res      (u0m2)
    );

    mmm_nlp_90b_pip #(
        .ODW        (181),
        .IDW        (90),
        .OAW        (24),
        .OBW        (16),
        .LATENCY3   (LATENCY3)
    ) u_mmm_nlp_90b_pip_10 (
        .i_clk      (i_clk),
        .i_rstn     (i_rstn),    
        .i_a        (u0_a_u1),
        .i_b        (m0_a_m1),
        .i_carry    (0),

        .o_res      (u0u1_m_m0m1)
    );

    mmm_nlp_90b_pip #(
        .ODW        (181),
        .IDW        (90),
        .OAW        (24),
        .OBW        (16),
        .LATENCY3   (LATENCY3)
    ) u_mmm_nlp_90b_pip_11 (
        .i_clk      (i_clk),
        .i_rstn     (i_rstn),    
        .i_a        (u2_),
        .i_b        (m0_),
        .i_carry    (0),

        .o_res      (u2m0)
    );

    always @(*) begin
        {P0H,P0L}       =   u0m0[173:0];
        {P1H,P1L}       =   u1m1[173:0];
        PP02            =   u0m2[173:0];
        {P01H,P01L}     =   u0u1_m_m0m1 - P0 - P1 + P0H;
        {PP20H,PP20L}   =   u2m0 + PP02 + P1 + P01H;
    end   

    always @(*) begin
        q_line1         =   u0m0;
        q_line2         =   u0u1_m_m0m1 - u0m0 - u1m1;
        q_line3         =   u0m2 + u2m0 + u1m1;
    end

    //the output of the stage 2 result
    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn)
            Q           <=  {(3*DIVW){1'b0}};
        else 
            Q           <=  q_line1 + (q_line2 << DIVW) + (q_line3 << (2*DIVW));
    end

    ////////////////////////////////////////////////
    //The third step of the MMM multiplication
    ////////////////////////////////////////////////
    //the signal of the stage 3
    reg [DIVW-1:0]          q0;
    reg [DIVW-1:0]          q1;
    reg [DIVW-1:0]          q2;

    reg [MIW-1:0]           q0_;
    reg [MIW-1:0]           q1_;
    reg [MIW-1:0]           q2_;

    reg [MIW-1:0]           m0;
    reg [MIW-1:0]           m1;
    reg [MIW-1:0]           m2;

    always @(*) begin
        {q2,q1,q0}      =   Q[3*DIVW-1:0];
    end

    always @(*) begin
        q2_             =   {3'b0,q2};
        q1_             =   {3'b0,q1};
        q0_             =   {3'b0,q0};
    end

    always @(*) begin
        m2              =   {3'b0,m02};
        m1              =   {3'b0,m01};
        m0              =   {3'b0,m00};
    end

    //The multiplexer of the algorithm in stage 3
    //the multiplexer of stage 3
    //3 cycle
    wire[MRW-1:0]           q0_m2;
    wire[MRW-1:0]           q1_m1;
    wire[MRW-1:0]           q2_m2;
    wire[MRW-1:0]           q2_m0;
    wire[MRW-1:0]           q1_q2_m_m1m2;

    reg [MIW-1:0]           q1_a_q2;
    reg [MIW-1:0]           m1_a_m2;

    reg [ODW-1:0]           s3_line1;
    reg [ODW-1:0]           s3_line2;
    reg [ODW-1:0]           s3_line3;

    always @(*) begin
        q1_a_q2     =   q1_ + q2_;
        m1_a_m2     =   m1 + m2;
    end

    //The multiplexer of the algorithm in stage 3
    //the multiplexer of stage 3
    //3 cycle
    mmm_nlp_90b_pip #(
        .ODW        (181),
        .IDW        (90),
        .OAW        (24),
        .OBW        (16),
        .LATENCY3   (LATENCY3)
    ) u_mmm_nlp_90b_pip_12 (
        .i_clk      (i_clk),
        .i_rstn     (i_rstn),    
        .i_a        (q0_),
        .i_b        (m2),
        .i_carry    (0),

        .o_res      (q0_m2)
    );

    mmm_nlp_90b_pip #(
        .ODW        (181),
        .IDW        (90),
        .OAW        (24),
        .OBW        (16),
        .LATENCY3   (LATENCY3)
    ) u_mmm_nlp_90b_pip_13 (
        .i_clk      (i_clk),
        .i_rstn     (i_rstn),    
        .i_a        (q1_),
        .i_b        (m1),
        .i_carry    (0),

        .o_res      (q1_m1)
    );

    mmm_nlp_90b_pip #(
        .ODW        (181),
        .IDW        (90),
        .OAW        (24),
        .OBW        (16),
        .LATENCY3   (LATENCY3)
    ) u_mmm_nlp_90b_pip_14 (
        .i_clk      (i_clk),
        .i_rstn     (i_rstn),    
        .i_a        (q2_),
        .i_b        (m2),
        .i_carry    (0),

        .o_res      (q2_m2)
    );

    mmm_nlp_90b_pip #(
        .ODW        (181),
        .IDW        (90),
        .OAW        (24),
        .OBW        (16),
        .LATENCY3   (LATENCY3)
    ) u_mmm_nlp_90b_pip_15 (
        .i_clk      (i_clk),
        .i_rstn     (i_rstn),    
        .i_a        (q1_a_q2),
        .i_b        (m1_a_m2),
        .i_carry    (0),

        .o_res      (q1_q2_m_m1m2)
    );

    mmm_nlp_90b_pip #(
        .ODW        (181),
        .IDW        (90),
        .OAW        (24),
        .OBW        (16),
        .LATENCY3   (LATENCY3)
    ) u_mmm_nlp_90b_pip_16 (
        .i_clk      (i_clk),
        .i_rstn     (i_rstn),    
        .i_a        (q2_),
        .i_b        (m0),
        .i_carry    (0),

        .o_res      (q2_m0)
    );

    always @(*) begin
        s3_line1    =   q0_m2 + q2_m0 + q1_m1;
        s3_line2    =   q1_q2_m_m1m2 - q1_m1 - q2_m2;
        s3_line3    =   q2_m2; 
    end

    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn)
            res     =   {(ODW){1'b0}};
        else
            res     =   (s3_line2) + (s3_line3 << DIVW) + T_[6*DIVW-1:3*DIVW];
    end

    assign  o_res   =   res;

endmodule