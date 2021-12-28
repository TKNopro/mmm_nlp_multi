//the mod inv of n ^ -1 mod r,  r = 2 ** k
//author : Lee
module mmm_mod_inv_wrapper #(
    parameter               WIDTH   =   260
)(
    //system signals
    input                   i_clk,
    input                   i_rstn,
    //input signals
    input   [WIDTH-1:0]     i_n,
    input   [WIDTH-1:0]     i_r,
    input                   i_valid,

    output                  o_res,
    output                  o_valid
);
    //DUT
    mmm_mod_inv #(
        .WIDTH          (WIDTH)
    ) mod_inverse_inst  (
        .clk            (i_clk),
        .rst_n          (i_rstn),    
        .N              (i_n), 
        .R              (i_r), 
        .in_valid       (i_valid),

        .result         (o_res),
        .out_valid      (o_valid)
);
endmodule