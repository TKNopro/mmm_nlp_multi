//the mmm mult's tb
//author ： Lee
`timescale 1ns/1ns

module mmm_nlp_90b_tb;
    //defination of paramete 
    parameter       ODW         =       522;
    parameter       IDW         =       256;
    parameter       DIVW        =       87;
    parameter       CYC         =       10;

    //defination of signals
    reg                     clk;
    reg                     rstn;
    reg     [IDW-1:0]       a;
    reg     [IDW-1:0]       b;
    //simulation register
    reg     [ODW-1:0]       sim_ret;
    reg     [ODW-1:0]       sim_ret_1;
    reg     [ODW-1:0]       sim_ret_2;
    reg     [ODW-1:0]       sim_ret_3;
    reg     [ODW-1:0]       sim_ret_4;

    wire    [ODW-1:0]       res;

    //generate the system clock
    initial begin
        clk     =   0;
        forever begin
            #(CYC/2) clk    =   ~clk;
        end
    end
    
    //generate the input signals
    always@(posedge clk or negedge rstn) begin
        if(!rstn) begin
            a   <=  {(IDW){1'b0}};
            b   <=  {(IDW){1'b0}};
        end
        else begin
            a   <=  {{$random},{$random},{$random},{$random},{$random},{$random},{$random},{$random}};
            b   <=  {{$random},{$random},{$random},{$random},{$random},{$random},{$random},{$random}};
        end
    end

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            sim_ret_1   <=  {(ODW){1'b0}};
            sim_ret_2   <=  {(ODW){1'b0}};
            sim_ret_3   <=  {(ODW){1'b0}};
            sim_ret_4   <=  {(ODW){1'b0}};
            sim_ret     <=  {(ODW){1'b0}};
        end 
        else begin
            sim_ret_1   <=  a * b;
            sim_ret_2   <=  sim_ret_1;
            sim_ret_3   <=  sim_ret_2;
            sim_ret_4   <=  sim_ret_3;
            sim_ret     <=  sim_ret_3;
        end
    end
    //instance of the DUT
    mmm_nlp_256b_3way #(
        .ODW        (ODW),
        .IDW        (IDW),
        .DIVW       (DIVW))
    u_mmm_nlp_256b_3way   (
        .i_clk      (clk),
        .i_rstn     (rstn),
        .i_a        (a),
        .i_b        (b),

        .o_res      (res)
    );

    integer sim_times;
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin   
            sim_times   <=  0;
        end
        else if(sim_times <= 100) begin
            sim_times   <=  sim_times + 1;
        end
        else begin
            sim_times   <=  0;
        end
    end

    initial begin
        $display("######\tStart to simulate\t######");
        $display("######\tStart to reset tne DUT\t######");
        //generate the reset signal
        rstn    =   1;
        #15;
        rstn    =   0;
        #20;
        rstn    =   1;
        $display("######\tFinish to reset tne DUT\t######");

        while (1) begin
            @(posedge clk) begin
                if (sim_ret!=res) begin
                    $display("\terror");
                    $display("\ta=0x%e b=0x%e c=0x%e",a,b,res);
                    $stop;
                end 
                else begin
                    $display("######\tSuccessfully!\t######");
                //$display("\t%5d:0x%x == 0x%x",sim_times,sim_ret,res);
                end

                if (sim_times==100) begin
                    $display("#################################");
                    $display("#\tThe test passed!\t#");
                    $display("#################################");
                    $finish;
                end
            end
        end

        $finish;
    end
endmodule

/*
always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn) begin
            P2H     <=  {ODW{1'b0}};
            P2L     <=  {ODW{1'b0}};
            P12L    <=  {ODW{1'b0}};
            P02L    <=  {ODW{1'b0}};
            P01L    <=  {ODW{1'b0}};
            P0L     <=  {ODW{1'b0}};
        end
        else begin
            P2H     <=  p2h <<  (5*DIVW);
            P2L     <=  (p2l + p12h) << (4*DIVW);       
            P12L    <=  (p12l + p02h) << (3*DIVW);
            P02L    <=  p02l << (2*DIVW);
            P01L    <=  p01l << (DIVW);
            P0L     <=  p0l;
        end
    end

    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn) begin
            {p0h,p0l}   <=  {(2*DIVW){1'b0}};
            {p1h,p1l}   <=  {(2*DIVW){1'b0}};
            {p2h,p2l}   <=  {(2*DIVW){1'b0}};
            {p01h,p01l} <=  {(2*DIVW+1){1'b0}};
            {p02h,p02l} <=  {(2*DIVW+1){1'b0}};
            {p12h,p12l} <=  {(2*DIVW+1){1'b0}};
        end
        else begin
            {p0h,p0l}   <=  a0b0[173:0];
            {p1h,p1l}   <=  a1b1[173:0];
            {p2h,p2l}   <=  a2b2[173:0];
            {p01h,p01l} <=  a0a1_m_b0b1 - p0 - p1 + p0h;
            {p02h,p02l} <=  a0a2_m_b0b2 + p1 - p0 - p2 + p01h;
            {p12h,p12l} <=  a1a2_m_b1b2 - p1 - p2;
        end
    end
*/