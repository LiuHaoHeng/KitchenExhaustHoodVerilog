module frequency_divider #(
    parameter DIVISOR = 100000000 //分频到1s
)(
    input clk,
    input rstn,
    output reg clk_out
);

reg [$clog2(DIVISOR/2)-1:0] counter; 

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        counter <= 0;
        clk_out <= 0;
    end else begin
        if (counter == DIVISOR/2 - 1) begin
            counter <= 0;
            clk_out <= ~clk_out;
        end else begin
            counter <= counter + 1;
        end
    end
end

endmodule
