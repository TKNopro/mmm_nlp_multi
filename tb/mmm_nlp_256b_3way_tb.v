//the mmm mult's tb
//author ： Lee
`timescale 1ns/1ns

module mmm_nlp_90b_pip_tb;
    //defination of paramete 
    parameter       ODW         =       256;
    parameter       IDW         =       256;
    parameter       DIVW        =       87;
    parameter       CYC         =       10;

    //defination of signals
    reg                     clk;
    reg                     rstn;
    reg     [3*IDW-1:0]     a;
    reg     [3*IDW-1:0]     b;
    reg     [IDW-1:0]       m;
    reg     [IDW+2:0]       m_b;
    reg     [IDW+3:0]       r;
    reg     [3*IDW-1:0]     mod_inv;
    //simulation register
    reg     [IDW-1:0]       sim_ret;
    reg     [IDW-1:0]       sim_ret_1;
    reg     [IDW-1:0]       sim_ret_2;
    reg     [IDW-1:0]       sim_ret_3;
    reg     [IDW-1:0]       sim_ret_4;

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
            a       <=  {(3*IDW){1'b0}};
            b       <=  {(3*IDW){1'b0}};
            m       <=  {(IDW){1'b0}};
            m_b     <=  {(IDW){1'b0}};
            mod_inv <=  {(3*IDW){1'b0}};
        end
        else begin
            a       <=  {256'b0,256'hf913b410fe0d6b547a64ce68e9b7430214e56ec57e37d50dc22be4fe5e5f8d2f};
            b       <=  {256'b0,256'h0de6501bd55b07ce9c83bbcbba280e5700e53c152304f6a1ab183a7b2e16e308};
            m       <=  {256'b0,256'hfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f};
            m_b     <=  {253'b0,259'hac9bd1905155383999c46c2c295f2b761bcb223fedc24a059d838091dd2253531};
            mod_inv <=  {256'b0,256'h5937a320a2aa70733388d85852be56ec3796447fdb84940b3b070123610d0231};
        end
    end

    //the model of the xx*yy*r^(-1) mod m
    always @(posedge clk or negedge rstn) begin
        if(!rstn)
            r           <=  260'b0;
        else  
            r           <=  2**(259);
    end
    
    always @(*) begin
        sim_ret_1       =  (a * b * mod_inv) % m;
    end

    /*
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            sim_ret_1   <=  {(ODW){1'b0}};
            sim_ret_2   <=  {(ODW){1'b0}};
            sim_ret_3   <=  {(ODW){1'b0}};
            sim_ret_4   <=  {(ODW){1'b0}};
            sim_ret     <=  {(ODW){1'b0}};
        end 
        else begin
            sim_ret_1   <=  a * b * mod_inv % m;
            sim_ret_2   <=  sim_ret_1;
            sim_ret_3   <=  sim_ret_2;
            sim_ret_4   <=  sim_ret_3;
            sim_ret     <=  sim_ret_3;
        end
    end
    */

    //instance of the DUT
    mmm_nlp_256b_3way #(
        .ODW        (ODW),
        .IDW        (IDW),
        .DIVW       (DIVW))
    u_mmm_nlp_256b_3way   (
        .i_clk      (clk),
        .i_rstn     (rstn),
        .i_a        (a[255:0]),
        .i_b        (b[255:0]),
        .i_m        (m[255:0]),
        .i_m_b      (m_b[258:0]),

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
        #1000;
        /*
        while (1) begin
            @(posedge clk) begin
                if (sim_ret!=res) begin
                    $display("\terror");
                    $display("\ta=0x%e b=0x%e c=0x%e",a,b,res);
                    $stop;
                end 
                else begin
                    $display("######\tSuccessfully!\t\t######");
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
        */

        $finish;
    end
endmodule

/*
    a * b * mod_inv mod m
    python      :0xa91e3f31c6fdc331151c02aa1aa13563110c6402f35f6ba6fa7e59a49ad4497e
    verilog     :0xf2a9960f3f073404e31238e59d4c3b9e73e87f14aa40dc0d8d926f2185d03cf8
    verilog_fix :0xa91e3f31c6fdc331151c02aa1aa13563110c6402f35f6ba6fa7e59a49ad4497e

    a * b mod m
    python      :0x9b67814c1c8f87dd543b0495924918b81d48d74e4d418f3a0135576b852a2df9
    verilog     :0x1d9427bb9d0978fd282e01531130ace9a3a20d29a716b6f1ff8b78cb41371678
    verilog_fix :0x9b67814c1c8f87dd543b0495924918b81d48d74e4d418f3a0135576b852a2df9

    a * b * mod_inv mod m
    python      :0xa91e3f31c6fdc331151c02aa1aa13563110c6402f35f6ba6fa7e59a49ad4497e
@0: DUT_res     :0x138d319067721ca7e92731b76611df6e514d5c77fd47e99221023e674919d893
@1: DUT_res     :0x138d319067721ca7e92731b76611df6e518d5c78f187e99221023e674919d893
@2: DUT_res     :0x138d319067721ca7e92731b76611df6e518d5c78f187e99221023e674919d893

*/