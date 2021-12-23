module mmm_mod_add_tb;
    parameter           WIDTH = 260;
    
    reg                 clk;
    reg                 rst_n;
    reg                 en_addsub;
    reg [WIDTH-1:0]     a;
    reg [WIDTH-1:0]     b;
    reg                 mode;
    reg [WIDTH-1:0]     p;

    wire[WIDTH-1:0]     res;
    wire                flag;

    wire[WIDTH-1:0]     result;

    mmm_mod_add #(
        .WIDTH          (260)
    ) u_mmm_mod_add     (
        .i_clk          (clk),
        .i_rstn         (rst_n),
        .i_en_addsub    (en_addsub),
        .i_a            (a),
        .i_b            (b),
        .i_mode         (mode),
        .i_p            (p),

        .o_c            (res),
        .o_flag         (flag)
    );

    always #5 begin 
        clk = ~clk;
    end

    initial begin 
        clk = 0;
        rst_n = 1;
        #30;
        rst_n = 0;
        #18;
        rst_n = 1;
    end

    initial begin
        a = 0; //unsigned
        b = 0; //unsigned
        p = 0;
        en_addsub = 0;
        mode = 0;

        @(posedge clk) begin
            a <= 256'h29c1685372e6fdccaee2c6161d828bbb9f768f903743d3ce2981d290fb3c9d9e;
            b <= 256'hd2024aec878e7b574728e44ec83e2ec94fb5dac01879c806fc33a8744458caec;
            p <= {1'b1,259'b0};
            en_addsub <= 1;
            mode <= 0;
        end

        repeat(1000)begin 
            @(posedge clk);
        end
    end

    assign  result  =   (a + b) % p;

endmodule