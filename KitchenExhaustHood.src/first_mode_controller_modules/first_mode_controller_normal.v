`timescale 1ns/1ps
`include "../header_files/parameters.vh"

module first_mode_controller_normal (
    input clk,
    input rstn,
    input [`MODE_WIDTH-1:0] current_mode,
    input menu_signal,
    input normal_signal,
    output reg first_mode_controller_normal_toggle
);

reg is_waiting_for_normal;
reg menu_signal_d;
always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        is_waiting_for_normal <= 1'b0;
        first_mode_controller_normal_toggle <= 1'b0;
        menu_signal_d <= 1'b0;
    end else begin
        menu_signal_d <= menu_signal;
        case (current_mode)
            `FIRST_MODE: begin
                is_waiting_for_normal <= 1'b0;
                first_mode_controller_normal_toggle <= 1'b0;
            end
            
            `STAND_MODE: begin
                if (!menu_signal_d && menu_signal) begin
                    is_waiting_for_normal <= 1'b1;
                end else if (is_waiting_for_normal && normal_signal && !menu_signal) begin
                    is_waiting_for_normal <= 1'b0;
                    first_mode_controller_normal_toggle <= 1'b1;
                end
            end
            default: begin
                is_waiting_for_normal <= 1'b0;
                first_mode_controller_normal_toggle <= 1'b0;
            end
        endcase
    end
end
endmodule //first_mode_controller_normal