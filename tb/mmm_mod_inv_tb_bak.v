//the mmm mult's tb
//author ： Lee
`timescale 1ns/1ns

module mmm_mod_inv_tb;
    //defination of paramete 
    parameter       IDW         =       256;
    parameter       ODW         =       IDW + 3;
    parameter       DIVW        =       87;
    parameter       CYC         =       10;
    //parameter       N           =       10;
    parameter       N           =       256;
    parameter       NW          =       $clog2(N);

    //defination of signals
    reg                     clk;
    reg                     rstn;
  
    reg                     valid_i;
    wire                    ready_o;
    reg     [IDW-1:0]       a;
    reg     [259:0]          r;
    reg                     en;
    //simulation register
    reg                     ready_i;
    wire                    valid_o;
    wire    [ODW-1:0]       res;

    //generate the system clock
    initial begin
        clk     =   0;
        forever begin
            #(CYC/2) clk    =   ~clk;
        end
    end

    //defination of reg array
    reg [IDW-1:0]               mem_x[0:N-1];
    reg [IDW-1:0]               mem_y[0:N-1];
    reg [IDW-1:0]               mem_m[0:N-1];
    reg [IDW-1:0]               mem_m_b[0:N-1];
    reg [IDW-1:0]               mem_inv[0:N-1];

    task read_file;
        begin
            $readmemh("/home/ldp/graduate/mmm_nlp_multi/scripts/x.mem",mem_x);
            $readmemh("/home/ldp/graduate/mmm_nlp_multi/scripts/y.mem",mem_y);
            $readmemh("/home/ldp/graduate/mmm_nlp_multi/scripts/m.mem",mem_m);
            $readmemh("/home/ldp/graduate/mmm_nlp_multi/scripts/m_b.mem",mem_m_b);
            $readmemh("/home/ldp/graduate/mmm_nlp_multi/scripts/mod_inv.mem",mem_inv);
        end
    endtask

    //instance of the DUT
    mmm_mod_inv #(
        .IDW        (IDW),
        .ODW        (ODW),
        .N          (256),
        .NW         ($clog2(256)),
        .PW         (260),
        .MOD        (1))
    u_mmm_mod_inv (
        .i_clk      (clk),
        .i_rstn     (rstn),
        
        //.i_valid    (valid_i),
        //.o_ready    (ready_o),
        .i_en       (en),
        .i_a        (a),
        .i_p        (r),

        .i_ready    (ready_i),
        .o_valid    (valid_o),

        .o_m_b      (res)
    );

    integer sim_times;
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin   
            sim_times   <=  0;
        end
        else if(sim_times < N) begin
            sim_times   <=  sim_times + 1;
        end
        else begin
            sim_times   <=  0;
        end
    end

    integer sim_times_oo;
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin   
            sim_times_oo    <=  0;
        end
        else if(sim_times_oo <= 50) begin
            sim_times_oo    <=  sim_times_oo + 1;
        end
        else begin
            sim_times_oo    <=  0;
        end
    end

    wire[15:0]       sub;
    //assign sub  =   sim_ret_16 - res;

    initial begin
        $display("######\tStart to simulate\t\t######");
        $display("######\tStart to reset tne DUT\t\t######");
        //generate the reset signal
        rstn    =   1;
        valid_i =   0;
        #15;
        rstn    =   0;
        #20;
        rstn    =   1;
        $display("######\tFinish to reset tne DUT\t\t######");
        valid_i =   1;
        en      =   1;
        @(posedge clk);
        a       =   256'hfffffffffffffffffffffffffffffffffffffffffffffffffffeff2defffffff;
        r       =   {1'b1,{(259){1'b0}}};

        /*while(1) begin
            $display("the cur state is %d",mmm_mod_inv.cur_sta);
            #50;
            $finish;
        end*/

        #500;
        $finish;
    end
endmodule