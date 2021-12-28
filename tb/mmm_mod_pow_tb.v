//the mmm mult's tb
//author ： Lee
`timescale 1ns/1ns

module mmm_nlp_90b_pip_tb;
    //defination of paramete 
    parameter       ODW         =       256;
    parameter       IDW         =       256;
    parameter       DIVW        =       87;
    parameter       CYC         =       10;
    parameter       N           =       10;

    //defination of signals
    reg                     clk;
    reg                     rstn;
    reg     [IDW-1:0]       i_a;
    reg     [IDW-1:0]       i_b;
    reg     [IDW-1:0]       i_m;
    reg     [IDW+3:0]       i_m_b;
    reg     [IDW+3:0]       i_r;
    reg     [IDW-1:0]       i_mod_inv;

    reg     [IDW-1:0]       a;
    reg     [IDW-1:0]       b;
    reg     [IDW-1:0]       m;
    reg     [IDW+3:0]       m_b;
    reg     [IDW+3:0]       r;
    reg     [3*IDW-1:0]     mod_inv;
    //simulation register
    reg     [IDW-1:0]       sim_ret;
    reg     [IDW-1:0]       sim_ret_1;
    reg     [IDW-1:0]       sim_ret_2;
    reg     [IDW-1:0]       sim_ret_3;
    reg     [IDW-1:0]       sim_ret_4;

    reg     [IDW-1:0]       sim_ret_5;
    reg     [IDW-1:0]       sim_ret_6;
    reg     [IDW-1:0]       sim_ret_7;
    reg     [IDW-1:0]       sim_ret_8;

    reg     [IDW-1:0]       sim_ret_9;
    reg     [IDW-1:0]       sim_ret_10;
    reg     [IDW-1:0]       sim_ret_11;
    reg     [IDW-1:0]       sim_ret_12;

    reg     [IDW-1:0]       sim_ret_13;
    reg     [IDW-1:0]       sim_ret_14;
    reg     [IDW-1:0]       sim_ret_15;
    reg     [IDW-1:0]       sim_ret_16;

    reg     [IDW-1:0]       sim_ret_17;
    reg     [IDW-1:0]       sim_ret_18;

    wire    [ODW-1:0]       res;

    always @(*) begin
        a           =       i_a      ;
        b           =       i_b      ;
        m           =       i_m      ;
        m_b         =       i_m_b    ;
        r           =       i_r      ;
        mod_inv     =       i_mod_inv;
    end

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

    //task read_file;
    //    begin
    //        $readmemh("/home/ldp/graduate/mmm_nlp_multi/scripts/x.mem",mem_x);
    //        $readmemh("/home/ldp/graduate/mmm_nlp_multi/scripts/y.mem",mem_y);
    //        $readmemh("/home/ldp/graduate/mmm_nlp_multi/scripts/m.mem",mem_m);
    //        $readmemh("/home/ldp/graduate/mmm_nlp_multi/scripts/m_b.mem",mem_m_b);
    //        $readmemh("/home/ldp/graduate/mmm_nlp_multi/scripts/mod_inv.mem",mem_inv);
    //    end
    //endtask

    //integer i;
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            a       <=  {256'b0,256'ha90daef82adef540923cffa23b9b7430214e56ec57e3df58029303804adeef92};
            b       <=  {256'b0,256'hfa432904385702ce9c83bbcade98702900e53c152fff44243383492054382348};
            m       <=  {256'b0,256'hfffffffffffffffffffffffffffffffffffffffffffffffffffffefffffffd2f};
            m_b     <=  {253'b0,259'hb1fc1e372c48eee69c46972881dd3046ea400b084641a0edb22129c28d5099631};
            mod_inv <=  {256'b0,256'h63f83c6e5891ddcd388d2e5103ba608dd48016108c8341db644253212264c354};
        end
        else begin
            a       <=  {256'b0,256'ha90daef82adef540923cffa23b9b7430214e56ec57e3df58029303804adeef92};
            b       <=  {256'b0,256'hfa432904385702ce9c83bbcade98702900e53c152fff44243383492054382348};
            m       <=  {256'b0,256'hfffffffffffffffffffffffffffffffffffffffffffffffffffffefffffffd2f};
            m_b     <=  {253'b0,259'hb1fc1e372c48eee69c46972881dd3046ea400b084641a0edb22129c28d5099631};
            mod_inv <=  {256'b0,256'h63f83c6e5891ddcd388d2e5103ba608dd48016108c8341db644253212264c354};
        end
    end

    
    //generate the input signals
    /*
    always@(posedge clk or negedge rstn) begin
        if(!rstn) begin
            a       <=  {256'b0,256'ha90daef82adef540923cffa23b9b7430214e56ec57e3df58029303804adeef92};
            b       <=  {256'b0,256'hfa432904385702ce9c83bbcade98702900e53c152fff44243383492054382348};
            m       <=  {256'b0,256'hfffffffffffffffffffffffffffffffffffffffffffffffffffffefffffffd2f};
            m_b     <=  {253'b0,259'hb1fc1e372c48eee69c46972881dd3046ea400b084641a0edb22129c28d5099631};
            mod_inv <=  {256'b0,256'h63f83c6e5891ddcd388d2e5103ba608dd48016108c8341db644253212264c354};
        end
        else begin
            a       <=  {256'b0,256'h245456345fffa25dfe3cffa23b9b7430214e56ec57e45630457938017498ffaa};
            b       <=  {256'b0,256'hadfee2ce9c83b4493254890328493028addeeff2485730498203948257fae409};
            m       <=  {256'b0,256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffeffd2f};
            m_b     <=  {253'b0,256'h89e9625b1fd5b571bfaa331a612b45521c3be7b486c9063d56d3e75317ef99631};
            mod_inv <=  {256'b0,256'h13d2c4b63fab6ae37f546634c2568aa43877cf690d920c7aada7cea62fddf562};
        end
    end
    */
    //the model of the xx*yy*r^(-1) mod m
    always @(posedge clk or negedge rstn) begin
        if(!rstn)
            r           <=  260'b0;
        else  
            r           <=  2**(259);
    end

    /*
    always @(*) begin
        sim_ret_14      =    (a * b * mod_inv) % m;
    end
    */
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            sim_ret_1   <=  {(ODW){1'b0}};
            sim_ret_2   <=  {(ODW){1'b0}};
            sim_ret_3   <=  {(ODW){1'b0}};
            sim_ret_4   <=  {(ODW){1'b0}};
            sim_ret_5   <=  {(ODW){1'b0}};
            sim_ret_6   <=  {(ODW){1'b0}};
            sim_ret_7   <=  {(ODW){1'b0}};
            sim_ret_8   <=  {(ODW){1'b0}};
            sim_ret_9   <=  {(ODW){1'b0}};
            sim_ret_10  <=  {(ODW){1'b0}};
            sim_ret_11  <=  {(ODW){1'b0}};
            sim_ret_12  <=  {(ODW){1'b0}};
            sim_ret_13  <=  {(ODW){1'b0}};
            sim_ret_14  <=  {(ODW){1'b0}};
            sim_ret_15  <=  {(ODW){1'b0}};
            sim_ret_16  <=  {(ODW){1'b0}};
            sim_ret_17  <=  {(ODW){1'b0}};
            sim_ret_18  <=  {(ODW){1'b0}};
            sim_ret     <=  {(ODW){1'b0}};
        end 
        else begin
            sim_ret_1   <=  (a * b * mod_inv) % m;
            sim_ret_2   <=  sim_ret_1;
            sim_ret_3   <=  sim_ret_2;
            sim_ret_4   <=  sim_ret_3;
            sim_ret_5   <=  sim_ret_4; 
            sim_ret_6   <=  sim_ret_5; 
            sim_ret_7   <=  sim_ret_6; 
            sim_ret_8   <=  sim_ret_7; 
            sim_ret_9   <=  sim_ret_8; 
            sim_ret_10  <=  sim_ret_9; 
            sim_ret_11  <=  sim_ret_10;
            sim_ret_12  <=  sim_ret_11;
            sim_ret_13  <=  sim_ret_12;
            sim_ret_14  <=  sim_ret_13;
            sim_ret_15  <=  sim_ret_14;
            sim_ret_16  <=  sim_ret_15;
            sim_ret_17  <=  sim_ret_16;
            sim_ret_18  <=  sim_ret_17;
            sim_ret     <=  sim_ret_18;
        end
    end
    
    
    //assign    sim_ret_1       =  (a * b * mod_inv) % m;
    /*
    mmm_nlp_shift_reg#(
        .LATENCY            (12),
        .WD                 (ODW)
    ) mmm_nlp_shift_reg_u1 (
        .i_clk              (clk),
        .i_rstn             (rstn),

        .i_a                (sim_ret_1),
        .o_b                (sim_ret)         
    );
    */
    

    //instance of the DUT
    mmm_mod_pow#(
        .WIDTH      (256)
    )u_mmm_nlp_256b_3way   (
        .i_clk      (clk),
        .i_rstn     (rstn),
        .i_x        (a),
        .i_p        (m),
        .i_m_b      (m_b),

        .o_res      (res)
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

    wire[256:0]         sub;
    wire[1279:0]        mid;
    assign mid  =   a ** 5;
    assign sub  =   mid % m;

    initial begin
        $display("######\tStart to simulate\t\t######");
        $display("######\tStart to reset tne DUT\t\t######");
        //generate the reset signal
        rstn    =   1;
        #15;
        rstn    =   0;
        #20;
        rstn    =   1;
        $display("######\tFinish to reset tne DUT\t\t######");
        //read_file;
        while(1) begin
            @(posedge clk) begin
                if(res == sim_ret_16) begin
                    $display("######################################################################");
                    $display("######\tsuccessfully\t:");
                    $display("######sim_ret\t\t=%h",sim_ret_16);
                    $display("######res\t\t=%h",res);
                    $display("######################################################################");
                    $display(" ");
                end
                else begin
                    $display("######################################################################");
                    $display("######\tfailed\t:");
                    $display("######sim_ret\t\t=%h",sim_ret_16);
                    $display("######res\t\t=%h",res);
                    $display("######################################################################");
                    $display(" ");
                    //$stop;
                end

                 if (sim_times_oo==50) begin
                    $finish;
                end
            end
        end

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
        @1 python   :4233ad00abefaf6fd63757a1f88fc30e411c43f2cd0b19679470dcf75815b683
        @1 verilog  :4233ad00abefaf6fd63757a1f88fc30e411c43f2cd0b19679470dcf75815b681
        
        @2 python   :5f83e7d78466463bf71f1509bedcfdb0b356e58b0b6da4e37647c4bf46de1ca7
        @2 verilog  :5f83e7d78466463bf71f1509bedcfdb0b356e58b0b6da4e37647c4bf46de1ca6

                    5f83e7d78466463bf71f1509bedcfdb0b356e58b0b6da4e37647c4bf46de1ca7
                    4041b1140e4b710d8ada0ddaa6648540066316b63b24a6cff147c4bf46de1cfe

        @3 python   :962c93eca984cc9b4e73751662c1d131f33cf1a06390e7fbd66fe7dd96bc7ebb
        @3 verilog  :962c93eca984cc9b4e73751662c1d131f33cf1a06390e7fbd66fe7dd96bc7ebb

        @4 python   :d458283800709f83722aa6857e0c84e4dce4c81fbe913ace23c7c34ae929ddc4
        @4 verilog  :d458283800709f83722aa6857e0c84e4dce4c81fbe913ace23c7c34ae929ddc1

        @5 python   :4aab0eaefbe615490ca40d2027ef3a51dbc393766c0058e1597247ba92723c57
        @5 verilog  :4aab0eaefbe615490ca40d2027ef3a51dbc393766c0058e1597247ba92723c56

        @6 python   :f7f3ade373b367e6f88f4c5048c30403f64aeed8aedd4c720ad01851abee4aba
        @6 verilog  :f7f3ade373b367e6f88f4c5048c30403f64aeed8aedd4c720ad01851abee4ab4
                     13CCC932FD7179E50F909EB6872F5EB5845F9CBF4D9054452BE510DB9C607687




*/
