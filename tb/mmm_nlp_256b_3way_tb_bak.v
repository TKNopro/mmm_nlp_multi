//the mmm mult's tb
//author ： Lee
`timescale 1ns/1ns

module mmm_nlp_90b_pip_tb;
    //defination of paramete 
    parameter       ODW         =       261;
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

    reg     [3*DIVW-1:0]    a;
    reg     [3*IDW-1:0]     b;
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

    task read_file;
        begin
            $readmemh("/home/ldp/graduate/mmm_nlp_multi/scripts/x.mem",mem_x);
            $readmemh("/home/ldp/graduate/mmm_nlp_multi/scripts/y.mem",mem_y);
            $readmemh("/home/ldp/graduate/mmm_nlp_multi/scripts/m.mem",mem_m);
            $readmemh("/home/ldp/graduate/mmm_nlp_multi/scripts/m_b.mem",mem_m_b);
            $readmemh("/home/ldp/graduate/mmm_nlp_multi/scripts/mod_inv.mem",mem_inv);
        end
    endtask

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
            a       <=  mem_x[sim_times];
            b       <=  mem_y[sim_times];
            m       <=  mem_m[sim_times];
            m_b     <=  mem_m_b[sim_times];
            mod_inv <=  mem_inv[sim_times];
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
            sim_ret     <=  sim_ret_14;
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
    mmm_nlp_256b /*_3way*/ #(
        .ODW        (ODW),
        .IDW        (IDW),
        .DIVW       (DIVW))
    u_mmm_nlp_256b_3way   (
        .i_clk      (clk),
        .i_rstn     (rstn),
        .i_a        (a[255:0]),
        .i_b        (b[255:0]),
        .i_m        (m[255:0]),
        .i_m_b      (m_b[260:0]),

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

    wire[3:0]       sub;
    assign sub  =   sim_ret_14 - res;

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
        read_file;
        while(1) begin
            @(posedge clk) begin
                if(res == sim_ret_14) begin
                    $display("######################################################################");
                    $display("######\tsuccessfully\t:");
                    $display("######sim_ret\t\t=%h",sim_ret);
                    $display("######res\t\t=%h",res);
                    $display("######################################################################");
                    $display(" ");
                end
                else begin
                    $display("######################################################################");
                    $display("######\tfailed\t:");
                    $display("######sim_ret\t\t=%h",sim_ret);
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
@3: DUT_res     :0x3121594c047b95a51155330a77428c57f4df69a1674ea084208db7328a50ef0b
@4: DUT_res     :0x55435426ac62218c805e6bed74df4fcb34535a883b085fe2bff0b28d2d0e794b
@4: DUT_res     :0xaa478fcc71bf70cc454700aa86a84d58c4431900bc75b7d5439ba5683a569410
@4: DUT_res     :0xeb9181b467a6a41ff929d45d2930912bc74f4de2c8d1c20847a95fc7f24f13d3

    u` * m mod r
    python      :0x53b6be3c456d3e76c3e5344e34c6419dc8729fa49cc6dd98477db9464928a24f8
                   53b6be3c456d3e76c3e5344e34c6419dc8729fa49cc6dd98477db9464928a24f8
                   53b6be3c456d3e76c3e5344e34c6419dc8729fa49cc6dd98477db9464928a24f8

    verilog     :0x 3b6be3c456d3e76c3e5344e34c6419dc8729fa49cc6dd98477db9464928a24f8
                   13b6be3c456d3e76c3e5344e34c6419dc8729fa49cc6dd98477db9464928a24f8
                   53b6be3c456d3e76c3e5344e34c6419dc8729fa49cc6dd98477db9464928a24f8
                   153b6be3c456d3e76c3e5344e34c6419dc8729fa49cc6dd98477db9464928a24f8
                   0055435426ac62218c805e6bed74df4fcb34935a892f485fe2bff0b28d2d0e794b

    53b6be3c456d3e76c3e5344e34c6419dc8729fa49cc6dd98477db9464928a24f8
    53b6be3c456d3e76c3e5344e34c6419dc8729fa49cc6dd98477db9464928a24f8
    /////////
    0x233bbf293b8c62e153d84372670659c3802c6df9583f283f48ebfd5efe7e2d84
    0x233bbf293b8c62e153d84372670659c3802c6df9583f283f48ebfd5efe7e2d84

    0x5f83e7d78466463bf71f1509bedcfdb0b356e58b0b6da4e37647c4bf46de1ca7
    0x5f83e7d78466463bf71f1509bedcfdb0b356e58b0b6da4e37647c4bf46de1ca7
    
    /////////

    python      :0xa91e3f31c6fdc331151c02aa1aa13563110c6402f35f6ba6fa7e59a49ad4497e
                   a91e3f31c6fdc331151c02aa1aa13563110c6402f35f6ba6fa7e59a49ad4497e
                 00a91e3f31c6fdc331151c02aa1aa13563110c6402f35f6ba6fa7e59a49ad4497c
    mmm_module  :0x002a478fcc71bf70cc454700aa86a84d58c4431900bcd7dae9be9f966926b5125e

                1010100100011110001111110011000111000110111111011100001100110001000101010001110000000010101010100001101010100001001101010110001100010001000011000110010000000010111100110101111101101011101001101111101001111110010110011010010010011010110101000100100101111110
         000000010101001000111100011111100110001110001101111110111000011001100010001010100011100000000101010101000011010101000010011010101100011000100010000110001100100000000101111001101011111011010111010011011111010011111100101100110100100100110101101010001001001011111

                0101111110000011111001111101011110000100011001100100011000111011111101110001111100010101000010011011111011011100111111011011000010110011010101101110010110001011000010110110110110100100111000110111011001000111110001001011111101000110110111100001110010100111
         000000001011111100000111110011111010111100001000110011001000110001110111111011100011111000101010000100110111110110111001111110110110000101100110101011011100101100010110000101101101101101001001110001101110110010001111100010010111111010001101101111000011100101001

                1111011111110011101011011110001101110011101100110110011111100110111110001000111101001100010100000100100011000011000001000000001111110110010010101110111011011000101011101101110101001100011100100000101011010000000110000101000110101011111011100100101010111010
         000000011110111111100111010110111100011011100111011001101100111111001101111100010001111010011000101000001001000110000110000010000000011111101100100101011101110110110001010111011011101010011000111001000001010110100000001100001010001101010111110111001001010101100

                0100101010101011000011101010111011111011111001100001010101001001000011001010010000001101001000000010011111101111001110100101000111011011110000111001001101110110011011000000000001011000111000010101100101110010010001111011101010010010011100100011110001010111
         000000001001010101010110000111010101110111110111110011000010101010010010000110010100100000011010010000000100111111011110011101001010001110110111100001110010011011101100110110000000000010110001110000101011001011100100100011110111010100100100111001000111100010101

                1111011111110011101011011110001101110011101100110110011111100110111110001000111101001100010100000100100011000011000001000000001111110110010010101110111011011000101011101101110101001100011100100000101011010000000110000101000110101011111011100100101010111010
         000000011110111111100111010110111100011011100111011001101100111111001101111100010001111010011000101000001001000110000110000010000000011111101100100101011101110110110001010111011011101010011000111001000001010110100000001100001010001101010111110111001001010101110
         
         000000011110111111100111010110111100011011100111011001101100111111001101111100010001111010011000101000001001000110000110000010000000011111101100100101011101110110110001010111011011101010011000111001000001010110100000001100001010001101010111110111001001010101100100010010010111101001100100001011101110010110011011101110110001011110111001011000000001
         000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001100010000000000000000000000000000000000000000000000000000000000000000000000000000000000
                                                                                                                                                                                                                                                                             1100010
                                                                                                                                                                                                                                                                              100010000000000000000000000000000000000000000000000000000000000000000000000000000000000
                                                                                                                                                                                              000000000000000000000000000000000000000000000000000000000000000000000000000000001100010

        0100101010101011000011101010111011111011111001100001010101001001000011001010010000001101001000000010011111101111001110100101000111011011110000111001001101110110011011000000000001011000111000010101100101110010010001111011101010010010011100100011110001010110
        f7f3ade373b367e6f88f4c5048c30403f64aeed8aedd4c720ad01851abee4aba
        f7f3ade373b367e6f88f4c5048c30403f64aeed8aedd4c720ad01851abee4ab8
        f7f3ade373b367e6f88f4c5048c30403f64aeed8aedd4c720ad01851abee4ab4
        000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001100010000000000000000000000000000000000000000000000000000000000000000000000000000000000

        f7f3ade373b367e6f88f4c5048c30403f64aeed8aedd4c720ad01851abee4aba
        f7f3ade373b367e6f88f4c5048c30403f64aeed8aedd4c720ad01851abee4ab8

        4aab0eaefbe615490ca40d2027ef3a51dbc393766c0058e1597247ba92723c57
        4aab0eaefbe615490ca40d2027ef3a51dbc393766c0058e1597247ba92723c57

        
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

f7f3ade373b367e6f88f4c5048c30403f64aeed8aedd4c720ad01851abee4aba
f7f3ade373b367e6f88f4c5048c30403f64aeed8aedd4c720ad01851abee4aba
           0100001000110011101011010000000010101011111011111010111101101111110101100011011101010111101000011111100010001111110000110000111001000001000111000100001111110010110011010000101100011001011001111001010001110000110111001111011101011000000101011011011010000011
    000000001000010001100111010110100000000101010111110111110101111011011111101011000110111010101111010000111111000100011111100001100001110010000010001110001000011111100101100110100001011000110010110011110010100011100001101110011110111010110000001010110110110100000

           1001011000101100100100111110110010101001100001001100110010011011010011100111001101110101000101100110001011000001110100010011000111110011001111001111000110100000011000111001000011100111111110111101011001101111111001111101110110010110101111000111111010111011
    000000010010110001011001001001111101100101010011000010011001100100110110100111001110011011101010001011001100010110000011101000100110001111100110011110011110001101000000110001110010000111001111111101111010110011011111110011111011101100101101011110001111110101110

           0100001000110011101011010000000010101011111011111010111101101111110101100011011101010111101000011111100010001111110000110000111001000001000111000100001111110010110011010000101100011001011001111001010001110000110111001111011101011000000101011011011010000011
    000000001000010001100111010110100000000101010111110111110101111011011111101011000110111010101111010000111111000100011111100001100001110010000010001110001000011111100101100110100001011000110010110011110010100011100001101110011110111010110000001010110110110100000

           0100101010101011000011101010111011111011111001100001010101001001000011001010010000001101001000000010011111101111001110100101000111011011110000111001001101110110011011000000000001011000111000010101100101110010010001111011101010010010011100100011110001010111
    000000001001010101010110000111010101110111110111110011000010101010010010000110010100100000011010010000000100111111011110011101001010001110110111100001110010011011101100110110000000000010110001110000101011001011100100100011110111010100100100111001000111100010101

           1111011111110011101011011110001101110011101100110110011111100110111110001000111101001100010100000100100011000011000001000000001111110110010010101110111011011000101011101101110101001100011100100000101011010000000110000101000110101011111011100100101010111010
    000000011110111111100111010110111100011011100111011001101100111111001101111100010001111010011000101000001001000110000110000010000000011111101100100101011101110110110001010111011011101010011000111001000001010110100000001100001010001101010111110111001001010101110

    001001111011110001000110100101101011001101000011111000111011001011001000101011100010000
    110010001111100111001111110111010010011001111100100101110000100011010010001000111110000
    100011000000000000000000000000000000000000000000000000000000000000000000000000000000000

    1000101011000111010001110101111001101011001000010111101010011010110011010110100101011010001111010101110100101100010010111110101110111101010110011000000001011000010101100100111010101011000011100111111101111100011011111110010010001010110001000000100111111010
    0100000001000001101100010001010000001110010010110111000100001101100010101101101000001101110110101010011001100100100001010100000000000110011000110001011010110110001110110010010010100110110011111111000101000111110001001011111101000110110111100001110011111100

        0100001000110011101011010000000010101011111011111010111101101111110101100011011101010111101000011111100010001111110000110000111001000001000111000100001111110010110011010000101100011001011001111001010001110000110111001111011101011000000101011011011010000011
 000000001000010001100111010110100000000101010111110111110101111011011111101011000110111010101111010000111111000100011111100001100001110010000010001110001000011111100101100110100001011000110010110011110010100011100001101110011110111010110000001010110110110100000

        1001011000101100100100111110110010101001100001001100110010011011010011100111001101110101000101100110001011000001110100010011000111110011001111001111000110100000011000111001000011100111111110111101011001101111111001111101110110010110101111000111111010111011
 000000010010110001011001001001111101100101010011000010011001100100110110100111001110011011101010001011001100010110000011101000100110001111100110011110011110001101000000110001110010000111001111111101111010110011011111110011111011101100101101011110001111110101110

        0100001000110011101011010000000010101011111011111010111101101111110101100011011101010111101000011111100010001111110000110000111001000001000111000100001111110010110011010000101100011001011001111001010001110000110111001111011101011000000101011011011010000011
 000000001000010001100111010110100000000101010111110111110101111011011111101011000110111010101111010000111111000100011111100001100001110010000010001110001000011111100101100110100001011000110010110011110010100011100001101110011110111010110000001010110110110100000

        1101010001011000001010000011100000000000011100001001111110000011011100100010101010100110100001010111111000001100100001001110010011011100111001001100100000011111101111101001000100111010110011100010001111000111110000110100101011101001001010011101110111000100
 000000011010100010110000010100000111000000000000111000010011111100000110111001000101010101001101000010101111110000011001000010011100100110111001110010011001000000111111011111010010001001110101100111000100011110001111100001101001010111010010010100111011101110000

        0010000011100110101001110010100001000101111110011111010000111001001001101111001110000001111100111111110101100001001110010000110010011111101110001101111100001010100010110000001001110000010101101001101100111011010010011001001010110111000100110100011011010101
 000000001000000111001101010011100101000010001011111100111110100001110010010011011110011100000011111001111111101011000010011100100001100100111111011100011011111000010101000101100000010011100000101011010011011001110110100100110010010101101110001001101000110101101

        
*/
