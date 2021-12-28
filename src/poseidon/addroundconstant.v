//the module of the poseidon hash addroundconstant(256b)
//author : Lee
module addroundconstant #(
    parameter               IDW         =       256,
    parameter               ODW         =       256,
    parameter               MDW         =       260
)(
    //system signals
    input                   i_clk,
    input                   i_rstn,
    //input signals
    input                   i_en_addsub,
    input   [IDW-1:0]       i_pre_key,
    input   [IDW-1:0]       i_x,
    input   [IDW-1:0]       i_pos_key,
    input   [IDW-1:0]       i_p,
    
    output  [ODW-1:0]       o_arc,
    output                  o_flag
);
    //defiantion of the localparam
    localparam              A           =       256'b1;

    //reg and wire
    reg     [MDW-1:0]       pek_a_x;
    reg     [MDW-1:0]       pok;
    reg     [MDW-1:0]       p;
    reg                     en_addsub;

    //////////////////////////////////
    //the instance of the mmm
    //////////////////////////////////
    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn) begin
            pek_a_x         <=  {(MDW){1'b0}};
            pok             <=  {(MDW){1'b0}};
            p               <=  {(MDW){1'b0}};
            en_addsub       <=  1'b0;
        end
        else begin
            pek_a_x         <=  i_pre_key + i_x;
            pok             <=  i_pos_key;
            p               <=  i_p;
            en_addsub       <=  i_en_addsub;
        end
    end
    
    //the istance of the prekey
    mmm_mod_add #(
        .WIDTH          (MDW)
    ) u_mmm_mod_add (
        .i_clk          (i_clk),
        .i_rstn         (i_rstn),

        .i_en_addsub    (en_addsub),
        .i_a            (pek_a_x),
        .i_b            (pok),
        .i_mode         (1'b1),
        .i_p            (p),

        .o_c            (o_arc),
        .o_flag         (o_flag)
    );

endmodule