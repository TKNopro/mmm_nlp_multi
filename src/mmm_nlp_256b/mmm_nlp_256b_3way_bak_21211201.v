//the mmm mult with the NLP form
//author : Lee
module mmm_nlp_256b_3way#(
    parameter       ODW     =   522,
    parameter       IDW     =   256,
    parameter       DIVW    =   87
)(
    //system signals
    input                   i_clk,
    input                   i_rstn,
    //input signals
    input   [IDW-1:0]       i_a,
    input   [IDW-1:0]       i_b,
    input   [IDW-1:0]       i_m,
    
    output  [ODW-1:0]       o_res
);
    //local parameter defination
    localparam      MRW     =   181;
    localparam      DIVA    =   DIVW + 1;
    localparam      MIW     =   90;

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
    reg     [ODW-1:0]       line02;
    reg     [ODW-1:0]       line03;
    reg     [ODW-1:0]       line04;

    reg     [ODW-1:0]       line1;
    reg     [ODW-1:0]       line2;
    reg     [ODW-1:0]       line3;
    reg     [ODW-1:0]       line4;
    reg     [ODW-1:0]       line5;

    wire    [ODW-1:0]       T;
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
    assign  {a02,a01,a00}   =   {5'b0,i_a};
    assign  {b02,b01,b00}   =   {5'b0,i_b};
    assign  {m02,m01,m00}   =   {5'b0,i_m};
    
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

    //algorithm step1
    mmm_nlp_90b #(
        .ODW        (181),
        .IDW        (90),
        .OAW        (24),
        .OBW        (16)
    ) u_mmm_nlp_90b_1 (
        .i_clk      (i_clk),
        .i_rstn     (i_rstn),    
        .i_a        (a0),
        .i_b        (b0),
        .i_carry    (0),

        .o_res      (a0b0)
    );

    mmm_nlp_90b #(
        .ODW        (181),
        .IDW        (90),
        .OAW        (24),
        .OBW        (16)
    ) u_mmm_nlp_90b_2 (
        .i_clk      (i_clk),
        .i_rstn     (i_rstn),    
        .i_a        (a1),
        .i_b        (b1),
        .i_carry    (0),

        .o_res      (a1b1)
    );

    mmm_nlp_90b #(
        .ODW        (181),
        .IDW        (90),
        .OAW        (24),
        .OBW        (16)
    ) u_mmm_nlp_90b_3 (
        .i_clk      (i_clk),
        .i_rstn     (i_rstn),    
        .i_a        (a2),
        .i_b        (b2),
        .i_carry    (0),

        .o_res      (a2b2)
    );

    mmm_nlp_90b #(
        .ODW        (181),
        .IDW        (90),
        .OAW        (24),
        .OBW        (16)
    ) u_mmm_nlp_90b_4 (
        .i_clk      (i_clk),
        .i_rstn     (i_rstn),    
        .i_a        (a0_a_a1),
        .i_b        (b0_a_b1),
        .i_carry    (0),

        .o_res      (a0a1_m_b0b1)
    );

    mmm_nlp_90b #(
        .ODW        (181),
        .IDW        (90),
        .OAW        (24),
        .OBW        (16)
    ) u_mmm_nlp_90b_5 (
        .i_clk      (i_clk),
        .i_rstn     (i_rstn),    
        .i_a        (a0_a_a2),
        .i_b        (b0_a_b2),
        .i_carry    (0),

        .o_res      (a0a2_m_b0b2)
    );

    mmm_nlp_90b #(
        .ODW        (181),
        .IDW        (90),
        .OAW        (24),
        .OBW        (16)
    ) u_mmm_nlp_90b_6 (
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

    reg     [DIVW-1:0]      P0H;
    reg     [DIVW-1:0]      P0L;
    reg     [2*DIVW-1:0]    P0;
    reg     [DIVW-1:0]      P1H;
    reg     [DIVW-1:0]      P1L;
    reg     [2*DIVW-1:0]    P1;
    reg     [DIVW-1:0]      P2H;
    reg     [DIVW-1:0]      P2L;
    reg     [2*DIVW-1:0]    P2;
    reg     [2*DIVW-1:0]    PP02;
    
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
    reg [ODW-1:0]           TP5;
    reg [ODW-1:0]           TP4;
    reg [ODW-1:0]           TP3;
    reg [ODW-1:0]           TP2;
    reg [ODW-1:0]           TP1;
    reg [ODW-1:0]           TP0;

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
    always @(*) begin
        {t5,t4,t3,t2,t1,t0} =   T;
        {u2,u1,u0}          =   {t2,t1,t0};
        u                   =   {u2,u1,u0};
    end
    
    assign  o_res   =   T;

    //register the first stage output
    /*
    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn) begin
            P0H     <=  {(DIVW-1){1'b0}};
            P0L     <=  {(DIVW-1){1'b0}};
            P0      <=  {(2*DIVW-1){1'b0}};
            P1H     <=  {(DIVW-1){1'b0}};
            P1L     <=  {(DIVW-1){1'b0}};
            P1      <=  {(2*DIVW-1){1'b0}};
            P2H     <=  {(DIVW-1){1'b0}};
            P2L     <=  {(DIVW-1){1'b0}};
            P2      <=  {(2*DIVW-1){1'b0}};
        end
        else begin
            P0H     <=  p0h;
            P0L     <=  p0l;
            P0      <=  p0;
            P1H     <=  p1h;
            P1L     <=  p1l;
            P1      <=  p1;
            P2H     <=  p2h;
            P2L     <=  p2l;
            P2      <=  p2;
        end
    end
    */
    

    ////////////////////////////////////////////////
    //The second step of the MMM multiplication
    ////////////////////////////////////////////////


endmodule