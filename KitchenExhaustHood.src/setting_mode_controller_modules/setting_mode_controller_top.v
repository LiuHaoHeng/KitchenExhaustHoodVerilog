`timescale 1ns/1ps
`include "../header_files/parameters.vh"

module setting_mode_controller_top (
    input clk,
    input rstn,
    input [`MODE_WIDTH-1:0] current_mode,
    input toggle_signal,
    output reg setting_mode_toggle
);

wire setting_mode_controller_normal_toggle;
setting_mode_controller_normal setting_mode_controller_normal_inst (
    .clk(clk),
    .rstn(rstn),
    .current_mode(current_mode),
    .toggle_signal(toggle_signal),
    .setting_mode_controller_normal_toggle(setting_mode_controller_normal_toggle)
);

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        setting_mode_toggle <= 1'b0;
    end else begin
        case (current_mode)
            `STAND_MODE: begin
                if (setting_mode_controller_normal_toggle) begin
                    setting_mode_toggle <= 1'b1;
                end else begin
                    setting_mode_toggle <= 1'b0;
                end
            end
        endcase
    end
end
endmodule