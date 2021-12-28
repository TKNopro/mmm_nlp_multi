//karastiba multi
//author : Lee
module karastuba_256b #(
    parameter                   IDW     =   256,
    parameter                   ODW     =   512
)(
    //system signals
    input                       i_clk,
    input                       i_rstn,
    //input signals
    input   [IDW-1:0]           i_a,
    input   [IDW-1:0]           i_b,

    output  [ODW-1:0]           o_res
);
    //the defination of the parameter
    localparam                  WAYW    =   87;
    localparam                  WW      =   90;
    //localparam                  = ;

    //the defination of the reg and wire
    reg     [WW-1:0]            a0;
    reg     [WW-1:0]            a1;
    reg     [WW-1:0]            a2;
    reg     [WAYW-1:0]          a0_reg;
    reg     [WAYW-1:0]          a1_reg;
    reg     [WAYW-1:0]          a2_reg;

    reg     [WW-1:0]            b0;
    reg     [WW-1:0]            b1;
    reg     [WW-1:0]            b2;
    reg     [WAYW-1:0]          b0_reg;
    reg     [WAYW-1:0]          b1_reg;
    reg     [WAYW-1:0]          b2_reg;

    reg     [WW:0]              a1_a_a0;
    reg     [WW:0]              a2_a_a0;
    reg     [WW:0]              a2_a_a1;

    reg     [WW:0]              b1_a_b0;
    reg     [WW:0]              b2_a_b0;
    reg     [WW:0]              b2_a_b1;


    wire    [2*WW:0]            a0b0;
    wire    [2*WW:0]            a1b1;
    wire    [2*WW:0]            a2b2;
    wire    [2*WW:0]            a1a0_m_b1b0;
    wire    [2*WW:0]            a2a0_m_b2b0;
    wire    [2*WW:0]            a2a1_m_b2b1;


    reg     [ODW-1:0]           line1;
    reg     [ODW-1:0]           line2;
    reg     [ODW-1:0]           line3;
    reg     [ODW-1:0]           line4;
    reg     [ODW-1:0]           line5;

    reg     [ODW-1:0]           res;

    //////////////////////////////////
    //      Main Code
    //////////////////////////////////
    
    //stage 1
    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn) begin
            {a2_reg,a1_reg,a0_reg}      <=  {(3*WAYW){1'b0}};
            {b2_reg,b1_reg,b0_reg}      <=  {(3*WAYW){1'b0}};
        end
        else begin
            {a2_reg,a1_reg,a0_reg}      <=  i_a;
            {b2_reg,b1_reg,b0_reg}      <=  i_b;
        end
    end

    //stage 2
    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn) begin
            {a2,a1,a0}      <=  {(3*WW){1'b0}};
            {b2,b1,b0}      <=  {(3*WW){1'b0}};
        end
        else begin
            {a2,a1,a0}      <=  {{3'b0,a2_reg},{3'b0,a1_reg},{3'b0,a0_reg}};
            {b2,b1,b0}      <=  {{3'b0,b2_reg},{3'b0,b1_reg},{3'b0,b0_reg}};
        end
    end

    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn) begin
            a1_a_a0         <=  {(WW){1'b0}};
            a2_a_a0         <=  {(WW){1'b0}};
            a2_a_a1         <=  {(WW){1'b0}};
            b1_a_b0         <=  {(WW){1'b0}};
            b2_a_b0         <=  {(WW){1'b0}};
            b2_a_b1         <=  {(WW){1'b0}};
        end
        else begin
            a1_a_a0         <=  a1_reg + a0_reg;
            a2_a_a0         <=  a2_reg + a0_reg;
            a2_a_a1         <=  a2_reg + a1_reg;
            b1_a_b0         <=  b1_reg + b0_reg;
            b2_a_b0         <=  b2_reg + b0_reg;
            b2_a_b1         <=  b2_reg + b1_reg;
        end
    end

    //////////////////////////////////
    //the 3way of the 90b karatsuba
    //////////////////////////////////
    karastuba_90b #(
        .IDW            (WW),
        .ODW            (2*WW+1),
        .LATENCY3       (1)
    ) u_karastuba_90b_1 (
        .i_clk          (i_clk),
        .i_rstn         (i_rstn),
        .i_a            (a0),
        .i_b            (b0),
        .i_carry        (0),

        .o_res          (a0b0)
    );

    karastuba_90b #(
        .IDW            (WW),
        .ODW            (2*WW+1),
        .LATENCY3       (1)
    ) u_karastuba_90b_2 (
        .i_clk          (i_clk),
        .i_rstn         (i_rstn),
        .i_a            (a1),
        .i_b            (b1),
        .i_carry        (0),

        .o_res          (a1b1)
    );

    karastuba_90b #(
        .IDW            (WW),
        .ODW            (2*WW+1),
        .LATENCY3       (1)
    ) u_karastuba_90b_3 (
        .i_clk          (i_clk),
        .i_rstn         (i_rstn),
        .i_a            (a2),
        .i_b            (b2),
        .i_carry        (0),

        .o_res          (a2b2)
    );
    //////////////////////////////////
    karastuba_90b #(
        .IDW            (WW),
        .ODW            (2*WW+1),
        .LATENCY3       (1)
    ) u_karastuba_90b_4 (
        .i_clk          (i_clk),
        .i_rstn         (i_rstn),
        .i_a            (a1_a_a0),
        .i_b            (b1_a_b0),
        .i_carry        (0),

        .o_res          (a1a0_m_b1b0)
    );

    karastuba_90b #(
        .IDW            (WW),
        .ODW            (2*WW+1),
        .LATENCY3       (1)
    ) u_karastuba_90b_5 (
        .i_clk          (i_clk),
        .i_rstn         (i_rstn),
        .i_a            (a2_a_a0),
        .i_b            (b2_a_b0),
        .i_carry        (0),

        .o_res          (a2a0_m_b2b0)
    );

    karastuba_90b #(
        .IDW            (WW),
        .ODW            (2*WW+1),
        .LATENCY3       (1)
    ) u_karastuba_90b_6 (
        .i_clk          (i_clk),
        .i_rstn         (i_rstn),
        .i_a            (a2_a_a1),
        .i_b            (b2_a_b1),
        .i_carry        (0),

        .o_res          (a2a1_m_b2b1)
    );

    //stage 5
    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn) begin
            line1   <=  {(ODW){1'b0}};
            line2   <=  {(ODW){1'b0}};
            line3   <=  {(ODW){1'b0}};
            line4   <=  {(ODW){1'b0}};
            line5   <=  {(ODW){1'b0}};
        end
        else begin
            line1   <=  a0b0;
            line2   <=  (a1a0_m_b1b0 - a1b1 - a0b0) << WAYW;
            line3   <=  (a2a0_m_b2b0 - a2b2 - a0b0 + a1b1) << (2*WAYW);
            line4   <=  (a2a1_m_b2b1 - a2b2 - a1b1) << (3*WAYW);
            line5   <=  a2b2 << (4*WAYW);
        end
    end

    //stage 6
    //add the result
    reg     [ODW-1:0]           line1_a_line2;
    reg     [ODW-1:0]           line3_a_line4;
    reg     [ODW-1:0]           line1234;
    reg     [ODW-1:0]           line5_reg1;
    reg     [ODW-1:0]           line5_reg2;

    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn) begin
            line1_a_line2   <=  {(ODW){1'b0}};
            line3_a_line4   <=  {(ODW){1'b0}};
            line5_reg1      <=  {(ODW){1'b0}};
        end
        else begin
            line1_a_line2   <=  line1 + line2;
            line3_a_line4   <=  line3 + line4;
            line5_reg1      <=  line5;
        end
    end

    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn) begin
            line1234        <=  {(ODW){1'b0}};
            line5_reg2      <=  {(ODW){1'b0}};
        end
        else begin
            line1234        <=  line1_a_line2 + line3_a_line4;
            line5_reg2      <=  line5_reg1;
        end
    end

    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn)
            res             <=  {(ODW){1'b0}};
        else 
            res             <=  line1234 + line5_reg2;
    end

    assign  o_res   =   res;

       
endmodule

//2241074fc178e98e9e e6cb8e638d3d29306ca3fcbf9ab3bcc12cd7d57a1ef2b2492ff7dece3b69c59bd4a231ed10bdb33e5757ea6d fe17de25c81631968ff9a8
//2241074fc178e98e9e b5ef6fc34fe19e1492190ce298faed7816fbf5dfa10620f6ec73058f57f74e2ec976697ed153e5a983e18842 fe17de25c81631968ff9a8

//2241074fc178e98e  3cfdb22f4898cb665f7c39f243e91804aed30eb4c8872e42bb479b11970e5888336218260cd6057902e82e76ea  fe17de25c81631968ff9a8
//2241074fc178e98e  9eb5ef6fc34fe19e1492190ce298faed7816fbf5dfa10620f6ec73058f57f74e2ec976697ed153e5a983e18842  fe17de25c81631968ff9a8

//003cbfc64ea25daf4c082a1b8d77e4a2e9a260ef5e4d50
//018d9c30b912c70d9b6e4982fe17de25c81631968ff9a8
//018a9f7248762462970f6a046cbd8f75e4dfb2059e484e