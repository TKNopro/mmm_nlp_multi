//the mod inv of n ^ -1 mod r,  r = 2 ** k
//author : Lee
module mmm_mod_inv_s_wrapper #(
    parameter               WIDTH   =   260
)(
    //system signals
    input                   i_clk,
    input                   i_rstn,
    //input signals
    input   [WIDTH-1:0]     i_p,
    input   [WIDTH-1:0]     i_a,
    input                   i_en,

    output                  o_res,
    output                  o_ready,
    output                  o_valid
);
    //DUT
    ReverseMod_test #(
        .WIDTH          (WIDTH)
    ) mod_inverse_inst  (
        .clk            (i_clk),
        .rst_n          (i_rstn),    
        .p              (i_p), 
        .a              (i_a), 
        .en             (i_en),

        .Ramodp         (o_res),
        .valid          (o_valid),
        .ready          (o_ready)
);
endmodule