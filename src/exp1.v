module exp1 #(
    parameter                   WIDTH   =   256,
    parameter                   N       =   5
)(
    input                       i_clk,
    input                       i_rstn,
    input   [WIDTH-1:0]         i_a,

    output  [N*WIDTH-1:0]       o_b    
);
    reg     [WIDTH-1:0]         a;
    wire    [N*WIDTH-1:0]       r;
    reg     [N*WIDTH-1:0]       res;

    always @(posedge i_clk or negedge i_rstn) begin
        if(i_rstn)
            a   <=  {(WIDTH){1'b0}};
        else
            a   <=  i_a;
    end

    assign  r   =   a ** N;

    always @(posedge i_clk or negedge i_rstn) begin
        if(i_rstn)
            res <=  {(N*WIDTH){1'b0}};
        else
            res <=  r;
    end

    assign  o_b =   res;
endmodule