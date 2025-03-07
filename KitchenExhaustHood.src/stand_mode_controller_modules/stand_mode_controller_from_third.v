`timescale 1ns/1ps
`include "../header_files/parameters.vh"

module stand_mode_controller_from_third (
    input clk, //100MHz clock signal
    input rstn, //active-low
    input toggle_signal, // debounced signal
    input [`MODE_WIDTH-1:0] current_mode, // current mode
    output reg stand_mode_controller_from_third_toggle // output toggle signal
);

wire turn_on_signal;
reg reset_timer_signal;
wire [`MAX_WIDTH-1:0] count_reg;
wire done;

assign turn_on_signal = toggle_signal && (current_mode == `THIRD_MODE);

countdown_timer from_third_to_stand_timer_inst (
    .clk(clk),
    .rstn(rstn),
    .start(turn_on_signal),
    .load_value(`THIRD_MODE_COUNTER_TIME),
    .reset_signal(reset_timer_signal),
    .count_reg(count_reg),
    .done(done)
);

reg has_started;
reg has_reseted;
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        stand_mode_controller_from_third_toggle <= 1'b0;
        reset_timer_signal <= 1'b1;
        has_started <= 1'b0;
        has_reseted <= 1'b0;
    end
    else begin
        case (current_mode)
            `THIRD_MODE: begin
                reset_timer_signal <= 1'b0;
                has_reseted <= 1'b1;
                if (!done && has_reseted) begin
                    has_started <= 1'b1;
                end else if (done && has_started) begin
                    stand_mode_controller_from_third_toggle <= 1'b1;
                end
            end
            default: begin
                stand_mode_controller_from_third_toggle <= 1'b0;
                has_started <= 1'b0;
                reset_timer_signal <= 1'b1;
                has_reseted <= 1'b0;
            end
        endcase
    end
end
endmodule //stand_mode_controller_from_third