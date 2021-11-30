//the mmm mult's tb
//author ： Lee
`timescale 1ns/1ns

module mmm_nlp_90b_tb;
    //defination of paramete 
    parameter       ODW         =       181;
    parameter       IDW         =       90;
    parameter       OAW         =       24;
    parameter       OBW         =       16;
    parameter       CYC         =       10;

    //defination of signals
    reg                     clk;
    reg                     rstn;
    reg     [IDW-1:0]       a;
    reg     [IDW-1:0]       b;

    wire    [ODW-1:0]       res;

    //generate the system clock
    initial begin
        clk     =   0;
        forever begin
            #(CYC/2) clk    =   ~clk;
        end
    end

    //generate the reset signal
    initial begin
        rstn    =   1;
        #15;
        rstn    =   0;
        #20;
        rstn    =   1;
    end

    //generate the middle signals
    reg     [31:0]          a0;
    reg     [31:0]          a1;
    reg     [31:0]          a2;
    reg     [31:0]          a3;

    reg     [31:0]          b0;
    reg     [31:0]          b1;
    reg     [31:0]          b2;
    reg     [31:0]          b3;
    //reg     [23:0]          b4;
    //reg     [23:0]          b5;
    //reg     [23:0]          b6;
    //reg     [23:0]          b7;
    
    //generate the input signals
    always@(posedge clk) begin
        a0  =   {$random};
        a1  =   {$random};
        a2  =   {$random};
        a3  =   {$random}%67108863;

        b0  =   {$random};
        b1  =   {$random};
        b2  =   {$random};
        b3  =   {$random}%67108863;

        a   =   {a3,a2,a1,a0};
        b   =   {b3,b2,b1,b0};
    end

    //generate the sim result
    reg  [ODW-1:0]    sim_ret;
    always @(*) begin
        sim_ret =   a * b;
    end


    mmm_nlp_90b #(
        .ODW        (ODW),
        .IDW        (IDW),
        .OAW        (OAW),
        .OBW        (OBW))
    u_mmm_nlp_90b   (
        .i_clk      (clk),
        .i_rstn     (rstn),
        .i_a        (a),
        .i_b        (b),

        .o_res      (res)
    );

    integer sim_times=0;
    initial begin
        $display("######Start to simulate######");
        //$dumpfile("mmm_nlp_90b.vcd");
        //$dumpvars(0, mmm_nlp_90b);
        #(CYC*100)

        while (1) begin
            @(posedge clk)
            $display("######The testbench is not done!######");
            sim_times=sim_times+1;
            if (sim_ret!=res) begin
                $display("error");
                $display("a=0x%x b=0x%x c=0x%x",a,b,res);
                $stop;
            end else begin
                // $display("%5d:0x%x == 0x%x",sim_times,sim_ret,d_out);
                $write(".");
            end
            if (sim_times==10000) begin
                $finish;
            end
        end

        $finish;
    end
endmodule
