`timescale 1ns/1ps
`include "../header_files/parameters.vh"

module third_mode_controller_normal (
    input clk,
    input rstn,
    input [`MODE_WIDTH-1:0] current_mode,
    input menu_signal,
    input normal_signal,
    output reg third_mode_controller_normal_toggle
);

reg is_waiting_for_normal;
reg menu_signal_d;
reg has_opened;
always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        is_waiting_for_normal <= 1'b0;
        third_mode_controller_normal_toggle <= 1'b0;
        menu_signal_d <= 1'b0;
        has_opened <= 1'b0;
    end else begin
        menu_signal_d <= menu_signal;
        case (current_mode)
            `OFF_MODE: begin
                is_waiting_for_normal <= 1'b0;
                third_mode_controller_normal_toggle <= 1'b0;
                has_opened <= 1'b0;
            end
            
            `THIRD_MODE: begin
                is_waiting_for_normal <= 1'b0;
                third_mode_controller_normal_toggle <= 1'b0;
            end
            
            `STAND_MODE: begin
                if (!menu_signal_d && menu_signal) begin
                    is_waiting_for_normal <= 1'b1;
                end else if (!has_opened && is_waiting_for_normal && normal_signal && !menu_signal) begin
                    is_waiting_for_normal <= 1'b0;
                    third_mode_controller_normal_toggle <= 1'b1;
                    has_opened <= 1'b1;
                end
            end
            default: begin
                is_waiting_for_normal <= 1'b0;
                third_mode_controller_normal_toggle <= 1'b0;
            end
        endcase
    end
end
endmodule //third_mode_controller_normal