module debouncer #(
    parameter DEBOUNCE_TIME = 20
)(
    input clk,
    input rstn,
    input button_in,
    output reg debounced_out
);

reg [DEBOUNCE_TIME-1:0] shift_reg;
reg stable_state;

initial begin
    shift_reg = {DEBOUNCE_TIME{1'b0}};
    debounced_out = 0;
    stable_state = 0;
end

// 逻辑实现
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        shift_reg <= {DEBOUNCE_TIME{1'b0}};
        debounced_out <= 0;
        stable_state <= 0;
        
    end else begin

        shift_reg <= {shift_reg[DEBOUNCE_TIME-2:0], button_in};
        if (shift_reg == {DEBOUNCE_TIME{1'b1}}) begin
            stable_state <= 1;
        end else if (shift_reg == {DEBOUNCE_TIME{1'b0}}) begin
            stable_state <= 0;
        end

        debounced_out <= stable_state;
    end
end

endmodule
