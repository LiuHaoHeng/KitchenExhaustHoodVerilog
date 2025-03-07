`timescale 1ns/1ps
`include "../header_files/parameters.vh"

module second_mode_controller_from_third (
    input clk,      //100MHz clock signal
    input rstn,     //active-low
    input [`MODE_WIDTH-1:0] current_mode, // current mode
    input menu_signal, // menu signal
    output reg second_mode_controller_from_third_toggle // output toggle signal
);

reg turn_on_toggle_signal;
reg reset_timer_signal;
reg menu_timer_on;
wire [`MAX_WIDTH-1:0] count_reg;
wire done;

countdown_timer from_third_to_second_timer_inst (
    .clk(clk),
    .rstn(rstn),
    .start(turn_on_toggle_signal),
    .load_value(`THIRD_MODE_COUNTER_TIME),
    .reset_signal(reset_timer_signal),
    .count_reg(count_reg),
    .done(done)
);
reg started;
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        second_mode_controller_from_third_toggle <= 1'b0;
        turn_on_toggle_signal <= 1'b0;
        reset_timer_signal <= 1'b1;
        menu_timer_on <= 1'b0;
        started <= 1'b0;
    end
    else begin
        case (current_mode)
            `THIRD_MODE: begin
                if (!done) begin
                    started <= 1'b1;
                end else if (done && !turn_on_toggle_signal) begin
                    turn_on_toggle_signal <= 1'b1;
                end else if (done && !menu_timer_on && started) begin
                    second_mode_controller_from_third_toggle <= 1'b1;
                end
                if (menu_signal) begin
                    menu_timer_on <= 1'b1;
                end
            end
            default: begin
                second_mode_controller_from_third_toggle <= 1'b0;
                turn_on_toggle_signal <= 1'b0;
                menu_timer_on <= 1'b0;
                started <= 1'b0;
            end
        endcase
    end
end
endmodule //second_mode_controller_from_third