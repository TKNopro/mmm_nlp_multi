//the mmm mult of with the NLP
//author : Lee
module mmm_nlp_90b#(
    parameter       ODW         =       181,
    parameter       IDW         =       90,
    parameter       OAW         =       24,
    parameter       OBW         =       16
)(
    //system sigals
    input                       i_clk,
    input                       i_rstn,
    //input signals
    input   [IDW-1:0]           i_a,
    input   [IDW-1:0]           i_b,

    output  [ODW-1:0]           o_res
);
    //parameter defination 
    localparam      RESW        =       OAW + OBW;
    localparam      ORSW        =       RESW + 1;
    localparam      LSW         =       88;
    localparam      HSW         =       93;

    //defination of wire and reg
    wire    [OAW-1:0]           x0;
    wire    [OAW-1:0]           x1;
    wire    [OAW-1:0]           x2;
    wire    [OAW-1:0]           x3;

    wire    [OBW-1:0]           y0;
    wire    [OBW-1:0]           y1;
    wire    [OBW-1:0]           y2;
    wire    [OBW-1:0]           y3;
    wire    [OBW-1:0]           y4;
    wire    [OBW-1:0]           y5;
    //output result
    reg     [ODW-1:0]           res;
    //mid result
    reg     [RESW-1:0]          x0y0;
    reg     [RESW-1:0]          x0y1;
    reg     [RESW-1:0]          x0y2;
    reg     [RESW-1:0]          x0y3;
    reg     [RESW-1:0]          x0y4;
    reg     [RESW-1:0]          x0y5;

    reg     [RESW-1:0]          x1y0;
    reg     [RESW-1:0]          x1y1;
    reg     [RESW-1:0]          x1y2;
    reg     [RESW-1:0]          x1y3;
    reg     [RESW-1:0]          x1y4;
    reg     [RESW-1:0]          x1y5;

    reg     [RESW-1:0]          x2y0;
    reg     [RESW-1:0]          x2y1;
    reg     [RESW-1:0]          x2y2;
    reg     [RESW-1:0]          x2y3;
    reg     [RESW-1:0]          x2y4;
    reg     [RESW-1:0]          x2y5;

    reg     [RESW-1:0]          x3y0;
    reg     [RESW-1:0]          x3y1;
    reg     [RESW-1:0]          x3y2;
    reg     [RESW-1:0]          x3y3;
    reg     [RESW-1:0]          x3y4;
    reg     [RESW-1:0]          x3y5;
    //partitial add
    reg     [RESW-1:0]          x2y2_a_x0y5;
    reg     [RESW-1:0]          x3y2_a_x1y5;
    reg     [RESW-1:0]          x2y1_a_x0y4;
    reg     [RESW-1:0]          x1y3_a_x3y0;
    reg     [RESW-1:0]          x3y1_a_x1y4;
    reg     [RESW-1:0]          x2y0_a_x0y3;

    reg                         x2y2_a_x0y5_c;
    reg                         x3y2_a_x1y5_c;
    reg                         x2y1_a_x0y4_c;
    reg                         x1y3_a_x3y0_c;
    reg                         x3y1_a_x1y4_c;
    reg                         x2y0_a_x0y3_c;

    reg     [ODW-1:0]           x2y2_a_x0y5_c_a;
    reg     [ODW-1:0]           x3y2_a_x1y5_c_a;
    reg     [ODW-1:0]           x2y1_a_x0y4_c_a;
    reg     [ODW-1:0]           x1y3_a_x3y0_c_a;
    reg     [ODW-1:0]           x3y1_a_x1y4_c_a;
    reg     [ODW-1:0]           x2y0_a_x0y3_c_a;
    //make multi bits as the unit
    reg     [ODW-1:0]           shift_r_136b;
    reg     [ODW-1:0]           shift_r_120b;
    reg     [ODW-1:0]           shift_r_104b;
    reg     [ODW-1:0]           shift_r_152b;
    reg     [ODW-1:0]           shift_r_128b;
    //part of result
    reg     [LSW-1:0]           DSL;
    reg     [HSW-1:0]           DSH;


    assign  {x3,x2,x1,x0}       =   {6'b0,i_a};
    assign  {y5,y4,y3,y2,y1,y0} =   {6'b0,i_b};

    //pipeline 1
    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn) begin
            x0y0    <=   {RESW{1'b0}};
            x0y1    <=   {RESW{1'b0}};
            x0y2    <=   {RESW{1'b0}};
            x0y3    <=   {RESW{1'b0}};
            x0y4    <=   {RESW{1'b0}};
            x0y5    <=   {RESW{1'b0}};

            x1y0    <=   {RESW{1'b0}};
            x1y1    <=   {RESW{1'b0}};
            x1y2    <=   {RESW{1'b0}};
            x1y3    <=   {RESW{1'b0}};
            x1y4    <=   {RESW{1'b0}};
            x1y5    <=   {RESW{1'b0}};

            x2y0    <=   {RESW{1'b0}};
            x2y1    <=   {RESW{1'b0}};
            x2y2    <=   {RESW{1'b0}};
            x2y3    <=   {RESW{1'b0}};
            x2y4    <=   {RESW{1'b0}};
            x2y5    <=   {RESW{1'b0}};

            x3y0    <=   {RESW{1'b0}};
            x3y1    <=   {RESW{1'b0}};
            x3y2    <=   {RESW{1'b0}};
            x3y3    <=   {RESW{1'b0}};
            x3y4    <=   {RESW{1'b0}};
            x3y5    <=   {RESW{1'b0}};
        end
        else begin
            x0y0    <=   x0 * y0;   //<<0
            x0y1    <=   x0 * y1;   //<<16
            x0y2    <=   x0 * y2;   //<<32
            x0y3    <=   x0 * y3;   //<<48
            x0y4    <=   x0 * y4;   //<<64
            x0y5    <=   x0 * y5;   //<<80

            x1y0    <=   x1 * y0;   
            x1y1    <=   x1 * y1;
            x1y2    <=   x1 * y2;
            x1y3    <=   x1 * y3;
            x1y4    <=   x1 * y4;
            x1y5    <=   x1 * y5;

            x2y0    <=   x2 * y0;
            x2y1    <=   x2 * y1;
            x2y2    <=   x2 * y2;
            x2y3    <=   x2 * y3;
            x2y4    <=   x2 * y4;
            x2y5    <=   x2 * y5;

            x3y0    <=   x3 * y0;
            x3y1    <=   x3 * y1;
            x3y2    <=   x3 * y2;
            x3y3    <=   x3 * y3;
            x3y4    <=   x3 * y4;
            x3y5    <=   x3 * y5;
        end
    end

    //pipeline 2
    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn) begin
            {x2y2_a_x0y5_c, x2y2_a_x0y5}    <=  {ORSW{1'b0}};   //80
            {x3y2_a_x1y5_c, x3y2_a_x1y5}    <=  {ORSW{1'b0}};   //104
            {x2y1_a_x0y4_c, x2y1_a_x0y4}    <=  {ORSW{1'b0}};   //64
            {x1y3_a_x3y0_c, x1y3_a_x3y0}    <=  {ORSW{1'b0}};   //72
            {x3y1_a_x1y4_c, x3y1_a_x1y4}    <=  {ORSW{1'b0}};   //88
            {x2y0_a_x0y3_c, x2y0_a_x0y3}    <=  {ORSW{1'b0}};   //48
        end
        else begin
            {x2y2_a_x0y5_c, x2y2_a_x0y5}    <=  x2y2 + x0y5;
            {x3y2_a_x1y5_c, x3y2_a_x1y5}    <=  x3y2 + x1y5;
            {x2y1_a_x0y4_c, x2y1_a_x0y4}    <=  x2y1 + x0y4;
            {x1y3_a_x3y0_c, x1y3_a_x3y0}    <=  x1y3 + x3y0;
            {x3y1_a_x1y4_c, x3y1_a_x1y4}    <=  x3y1 + x1y4;
            {x2y0_a_x0y3_c, x2y0_a_x0y3}    <=  x2y0 + x0y3;
        end
    end

    //extends the carry
    always @(*) begin
        x2y2_a_x0y5_c_a     =  x2y2_a_x0y5_c   <<   80;
        x3y2_a_x1y5_c_a     =  x3y2_a_x1y5_c   <<   104;
        x2y1_a_x0y4_c_a     =  x2y1_a_x0y4_c   <<   64;
        x1y3_a_x3y0_c_a     =  x1y3_a_x3y0_c   <<   72;
        x3y1_a_x1y4_c_a     =  x3y1_a_x1y4_c   <<   88;
        x2y0_a_x0y3_c_a     =  x2y0_a_x0y3_c   <<   48;
    end

    //the conb of the multi result
    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn) begin
            shift_r_136b    <=  {ODW{1'b0}};
            shift_r_120b    <=  {ODW{1'b0}};
            shift_r_104b    <=  {ODW{1'b0}};
            shift_r_152b    <=  {ODW{1'b0}};
            shift_r_128b    <=  {ODW{1'b0}};
        end
        else begin
            shift_r_136b    <=  {x3y4,x2y3,x1y2,x0y1} << 16;
            shift_r_120b    <=  {x3y3,x2y2_a_x0y5,x1y1,x0y0};
            shift_r_104b    <=  {x3y2_a_x1y5,x2y1_a_x0y4,x1y0} << 24;
            shift_r_152b    <=  {x3y5,x2y4,x1y3_a_x3y0,x0y2} << 32;
            shift_r_128b    <=  {x2y5,x3y1_a_x1y4,x2y0_a_x0y3} << 48;
        end
    end

    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn)
            res     <=  {ODW{1'b0}};
        else
            res     <=  shift_r_152b + shift_r_136b + shift_r_128b + shift_r_120b + shift_r_104b + x2y2_a_x0y5_c_a + x2y2_a_x0y5_c_a + x2y1_a_x0y4_c_a + x1y3_a_x3y0_c_a + x3y1_a_x1y4_c_a + x2y0_a_x0y3_c_a;
    end

    assign  o_res   =   res;
    
endmodule   