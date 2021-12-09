//the mmm mult with the NLP form for moduler ** M^E(mod N)
//author : Lee
module mmm_nlp_montred #(
    parameter       ODW         =       256,
    parameter       IDW         =       256,
    parameter       OAW         =       24,
    parameter       OBW         =       16
)(
    input                       i_clk,
    input                       i_rstn,
    input   [IDW-1:0]           i_m,
    input   [IDW-1:0]           i_e,
    input   [IDW-1:0]           i_n,

    output  [ODW-1:0]           o_m
);

    //defination of reg and wire
    reg     [ODW+2:0]           buff_n;
    reg     [ODW-1:0]           buff_m;
    reg     [ODW-1:0]           buff_e;
    reg     [ODW-1:0]           buff_c;
    reg     [ODW-1:0]           buff_o_m;

    //control input
    always@(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn) begin
            buff_n      <=  {(ODW+3){1'b0}};
            buff_e      <=  {(ODW){1'b0}};
            buff_m      <=  {(ODW){1'b0}};
        end
        else begin
            buff_n      <=  i_n;
            buff_e      <=  i_e;
            buff_m      <=  i_m;
        end
    end

    //calculate the mod
    integer i;
    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn) begin
            buff_c      <=  {{(ODW-1){1'b0}},1'b1};
        end
        else begin
            for(i=0;i<ODW+3;i=i+1) begin
                if(buff_e[i] && (i==0)) begin
                    buff_c  <=  buff_m * buff_c % buff_n;
                end
                else if(buff_e[i]) begin
                    buff_c  <=  buff_o_m * buff_c % buff_n;
                end
            end
        end
    end

    integer j;
    always @(posedge i_clk or negedge i_rstn) begin
        if(!i_rstn) begin
            buff_o_m    <=  {(ODW){1'b0}};  
        end
        else begin
            for(i=0;i<ODW+3;i=i+1) begin
                if(i == 0) begin
                    buff_o_m    <=  buff_m * buff_m % buff_n;
                end
                else begin
                    buff_o_m    <=  buff_o_m * buff_o_m % buff_n;
                end
            end
        end
    end

    assign  o_m     =   buff_c;

endmodule