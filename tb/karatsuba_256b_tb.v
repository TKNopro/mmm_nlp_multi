module karastuba_256b_tb;
    parameter           IDW = 256;
    parameter           ODW = 512;
    parameter           CYC = 10;

    reg                 clk;
    reg                 rstn;
    reg [IDW-1:0]       a;
    reg [IDW-1:0]       b;

    wire[ODW-1:0]       res;
    wire[ODW-1:0]       result;
    wire[ODW-1:0]       ab;

    //DUT
    karastuba_256b #(
        .IDW                (256),
        .ODW                (512)
    ) u_karastuba_256b_1    (
        .i_clk              (clk),
        .i_rstn             (rstn),
        .i_a                (a),
        .i_b                (b),

        .o_res              (res)
    );

    //generate the clock
    initial begin
        clk     =   0;
        forever begin
            #(CYC/2) clk    =   ~clk;
        end
    end

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            a <= 256'h0;
            b <= 256'h0;
        end
        else begin
            a <= {{$random},{$random},{$random},{$random},{$random},{$random},{$random},{$random}};
            b <= {{$random},{$random},{$random},{$random},{$random},{$random},{$random},{$random}};
        end
    end

    initial begin
        $display("######\tStart to simulate\t\t######");
        $display("######\tStart to reset tne DUT\t\t######");
        //generate the reset signal
        rstn    =   1;
        #15;
        rstn    =   0;
        #13;
        rstn    =   1;
        $display("######\tFinish to reset tne DUT\t\t######");

        #200;
        $finish;
    end

    reg [31:0]      cnt;
    assign  result  =   a * b;

    mmm_nlp_shift_reg #(
        .LATENCY        (9),
        .WD             (512)
    ) shift_reg (
        .i_clk          (clk),
        .i_rstn         (rstn),
        .i_a            (result),
        .o_b            (ab)   
    );

    always @(posedge clk or negedge rstn) begin
        if(!rstn)
            cnt     <=  0;
        else
            cnt     <=  cnt + 1;
    end

    always @(posedge clk) begin
        if(ab == res) begin
            $display("successfully!");
            $display("@%d cycle:    res = %h",cnt,res);
        end
        else begin
            $display("error!");
            $display("@%d cycle:    res = %h",cnt,res);
        end    
    end

endmodule