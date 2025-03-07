`timescale 1ns/1ps
`include "../header_files/parameters.vh"

module setting_mode_controller_normal (
    input clk,
    input rstn,
    input [`MODE_WIDTH-1:0] current_mode,
    input toggle_signal,
    output reg setting_mode_controller_normal_toggle
);

reg toggle_signal_d;
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        toggle_signal_d <= 1'b0;
        setting_mode_controller_normal_toggle <= 1'b0;
    end else begin
        toggle_signal_d <= toggle_signal;
        case (current_mode)
            `STAND_MODE: begin
                if (!toggle_signal_d && toggle_signal) begin
                    setting_mode_controller_normal_toggle <= 1'b1;
                end else begin
                    setting_mode_controller_normal_toggle <= 1'b0;
                end
            end
            default: begin
                setting_mode_controller_normal_toggle <= 1'b0;
                toggle_signal_d <= 1'b0;
            end
        endcase
    end
end
endmodule