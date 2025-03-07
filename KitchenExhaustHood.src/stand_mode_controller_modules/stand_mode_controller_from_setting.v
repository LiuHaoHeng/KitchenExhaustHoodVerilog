`timescale 1ns/1ps
`include "../header_files/parameters.vh"

module stand_mode_controller_from_setting (
    input clk,
    input rstn,
    input [`MODE_WIDTH-1:0] current_mode,
    input toggle_signal,
    output reg stand_mode_controller_from_setting_toggle
);

reg toggle_signal_d;
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        toggle_signal_d <= 1'b0;
        stand_mode_controller_from_setting_toggle <= 1'b0;
    end else begin
        toggle_signal_d <= toggle_signal;
        case (current_mode)
            `SET_MODE: begin
                if (!toggle_signal_d && toggle_signal) begin
                    stand_mode_controller_from_setting_toggle <= 1'b1;
                end else begin
                    stand_mode_controller_from_setting_toggle <= 1'b0;
                end
            end
            default: begin
                stand_mode_controller_from_setting_toggle <= 1'b0;
                toggle_signal_d <= 1'b0;
            end
        endcase
    end
end
endmodule