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
            sim_ret     <=  {(ODW){1'b0}};
        end 
        else begin
            sim_ret_1   <=  a * b;
            sim_ret_2   <=  sim_ret_1;
            sim_ret_3   <=  sim_ret_2;
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