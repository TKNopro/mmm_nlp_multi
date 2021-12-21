module mmm_mod_inv_tb;

parameter WIDTH = 260;

    reg clk;
    reg rst_n;    
    reg [WIDTH-1:0] N; //unsigned
    reg [WIDTH-1:0] R; //unsigned
    reg in_valid;

    wire [WIDTH-1:0] result;
    wire out_valid;

    wire [WIDTH-1:0] result_check;

    assign result_check = (result * N) % R;


mmm_mod_inv mod_inverse_inst(
    .clk(clk),
    .rst_n(rst_n),    
    .N(N), 
    .R(R), 
    .in_valid(in_valid),

    .result(result),
    .out_valid(out_valid)
);

always #5 begin 
    clk = ~clk;
end

initial begin 
    clk = 0;
    rst_n = 0;
    #30;
    rst_n = 1;
end

initial begin 
    N = 0; //unsigned
    R = 0; //unsigned
    in_valid = 0;

    #60;
    @(posedge clk);
    //N <= {{7{4'hF}}, 4'hE, {32{4'hF}}, {8{4'h0}}, {16{4'hF}} }; 
        N <= 256'hFFFFFFFE_FFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF_00000000_FFFFFFFF_FFFFFFFF;
    //R <= 259'd2;
        R <= {1'b1,259'd0};
    //N <= 256'd3;
    //R <= {{7{4'hF}}, 4'hE, {32{4'hF}}, {8{4'h0}}, {16{4'hF}} }; 
        in_valid <= 1;
    
    @(posedge clk);
        in_valid <= 0; 
   
    repeat(1000)begin 
        @(posedge clk);
    end
    $display("\n input N = %H \n", N);
    $display("\n input R = %H \n", R);
    $display("\n output result = %H \n", R - result);
    $finish;
end

reg         vld_r1;
reg         vld_r2;

wire        pos;
reg [63:0]  cnt;


always @(posedge clk or negedge rst_n) begin
    if(!rst_n) 
        cnt     <=  0;
    else
        cnt     <=  cnt + 1;
end


endmodule