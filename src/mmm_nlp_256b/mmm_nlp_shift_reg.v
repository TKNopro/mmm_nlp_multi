//The shift reg for the design which is used to delay
//author : Lee
module mmm_nlp_shift_reg#(
    parameter LATENCY           = 4   ,
    parameter WD                = 256
)(
    input                       i_clk,
    input                       i_rstn,

    input   [WD-1:0]            i_a,
    output  [WD-1:0]            o_b         
);
//-------------------------------------------------------------------------------

//-------------------------------------------------------------------------------
generate
    if (LATENCY==0) begin
        assign o_b=i_a;
    end else if(LATENCY==1)begin
        reg [WD-1:0]lc;

        always@(posedge i_clk or negedge i_rstn)begin
            if (!i_rstn) begin
                lc <= 'd0;
            end 
            else begin
                lc <= i_a;
            end
        end

        assign o_b=lc;
    end else begin
        reg [WD-1:0]lc[0:LATENCY-1];
        integer j;
        always@(posedge i_clk or negedge i_rstn)begin
            if (!i_rstn) begin
                for ( j = 0;j< LATENCY;j=j+1 ) begin
                    lc[j] <= 'd0;
                end
            end 
            else begin
                for ( j = 0;j< LATENCY-1;j=j+1 ) begin
                    lc[0]   <= i_a;
                    lc[j+1] <= lc[j];
                end
            end
        end
        assign o_b=lc[LATENCY-1];        
    end
endgenerate

endmodule