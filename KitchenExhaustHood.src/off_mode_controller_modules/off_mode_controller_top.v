`timescale 1ns/1ps
`include "../header_files/parameters.vh"

module off_mode_controller_top(
    input clk,
    input rstn,
    input [`MODE_WIDTH-1:0] current_mode,
    input normal_signal,
    input left_gesture_signal,
    input right_gesture_signal,
    input [`MAX_WIDTH-1:0] gesture_counter_time,
    output reg off_mode_toggle
);

wire off_mode_controller_normal_toggle;
wire off_mode_controller_gesture_toggle;

off_mode_controller_normal off_mode_controller_normal_inst (
    .clk(clk),
    .rstn(rstn),
    .toggle_signal(normal_signal),
    .current_mode(current_mode),
    .off_mode_controller_normal_toggle(off_mode_controller_normal_toggle)
);

off_mode_controller_gesture off_mode_controller_gesture_inst (
    .clk(clk),
    .rstn(rstn),
    .first_toggle_signal(right_gesture_signal),
    .second_toggle_signal(left_gesture_signal),
    .counter_time(gesture_counter_time),
    .current_mode(current_mode),
    .off_mode_controller_gesture_toggle(off_mode_controller_gesture_toggle)
);


always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        off_mode_toggle <= 1'b0;
    end else begin
        case (current_mode)
            `OFF_MODE: begin
                off_mode_toggle <= 0;
            end
            default: begin
                if (off_mode_controller_normal_toggle) begin
                    off_mode_toggle <= 1;
                end else if (off_mode_controller_gesture_toggle) begin
                    off_mode_toggle <= 1;
                end else begin
                    off_mode_toggle <= 0;
                end
            end
        endcase
    end
end
endmodule