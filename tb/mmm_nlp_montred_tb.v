//the mmm mult's tb
//author ： Lee
`timescale 1ns/1ns

module mmm_nlp_montred_tb;
    //defination of paramete 
    parameter       ODW         =       256;
    parameter       IDW         =       256;
    parameter       OAW         =       24;
    parameter       OBW         =       16;
    parameter       CYC         =       10;

    //defination of signals
    reg                     clk;
    reg                     rstn;
    reg     [IDW-1:0]       m;
    reg     [IDW-1:0]       e;
    reg     [IDW-1:0]       n;

    //simulation register
    reg     [ODW-1:0]       sim_ret;
    reg     [ODW-1:0]       sim_ret_1;
    reg     [ODW-1:0]       sim_ret_2;

    wire    [ODW-1:0]       res;

    //generate the system clock
    initial begin
        clk     =   0;
        forever begin
            #(CYC/2) clk    =   ~clk;
        end
    end
    
    //instance of the DUT
    mmm_nlp_montred #(
        .ODW        (ODW),
        .IDW        (IDW),
        .OAW        (OAW),
        .OBW        (OBW))
    u_mmm_nlp_90b   (
        .i_clk      (clk),
        .i_rstn     (rstn),
        .i_m        (m),
        .i_e        (e),
        .i_n        (n),

        .o_m        (res)
    );


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
        $display("######\tStart to simulate the DUT\t######");
        @(posedge clk)
        m       =   256'b1000_0000_1010_0001;
        e       =   256'b0001_1111_1111_1111_1111;
        n       =   256'b0100_0000_0000_0000_0000;

        sim_ret =   (m**e) % n;

        if(sim_ret == res) begin
            $display("######\tsuccessfully\t######");
        end
        else begin
            $display("######\terror\t######");
        end
    end
endmodule