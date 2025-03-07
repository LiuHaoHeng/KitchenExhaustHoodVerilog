`timescale 1ns/1ps
`include "../header_files/parameters.vh"

module second_mode_controller_from_first (
    input clk,
    input rstn,
    input [`MODE_WIDTH-1:0] current_mode,
    input toggle_signal,
    output reg second_mode_controller_from_first_toggle
);

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        second_mode_controller_from_first_toggle <= 1'b0;
    end else begin
        case (current_mode)
            `FIRST_MODE: begin
                if (toggle_signal) begin
                    second_mode_controller_from_first_toggle <= 1'b1;
                end else begin
                    second_mode_controller_from_first_toggle <= 1'b0;
                end
            end
            default: begin
                second_mode_controller_from_first_toggle <= 1'b0;
            end
        endcase
    end
end
endmodule //second_mode_controller_from_first