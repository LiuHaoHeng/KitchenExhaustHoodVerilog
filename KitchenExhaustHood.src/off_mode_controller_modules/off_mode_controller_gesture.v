`timescale 1ns/1ps
`include "../header_files/parameters.vh"

module off_mode_controller_gesture(
    input clk,
    input rstn,
    input first_toggle_signal,
    input second_toggle_signal,
    input [`MODE_WIDTH-1:0] current_mode,
    input [`MAX_WIDTH-1:0] counter_time,
    output reg off_mode_controller_gesture_toggle
);

    reg reset_signal;
    wire [`MAX_WIDTH-1:0] counter_reg;
    wire done;

    countdown_timer gesture_counter_timer(
        .clk(clk),
        .rstn(rstn),
        .start(first_toggle_signal),
        .load_value(counter_time),
        .count_reg(counter_reg),
        .reset_signal(reset_signal),
        .done(done)
    );

    reg second_toggle_signal_d;
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            off_mode_controller_gesture_toggle <= 1'b0;
            reset_signal <= 1'b1;
        end else begin
            second_toggle_signal_d <= second_toggle_signal;
            case (current_mode)
                `OFF_MODE: begin
                    off_mode_controller_gesture_toggle <= 1'b0;
                    reset_signal = 1'b1;
                end
                default: begin
                    reset_signal = 1'b0;
                    if (done) begin
                        // do nothing
                    end else begin
                        if (!second_toggle_signal_d && second_toggle_signal) begin
                            off_mode_controller_gesture_toggle <= 1'b1;
                        end else begin
                            off_mode_controller_gesture_toggle <= 1'b0;
                        end
                    end
                end
            endcase
        end
    end
endmodule