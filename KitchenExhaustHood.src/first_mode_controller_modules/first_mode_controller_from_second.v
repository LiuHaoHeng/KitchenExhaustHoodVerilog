`timescale 1ns/1ps
`include "../header_files/parameters.vh"

module first_mode_controller_from_second (
    input clk,
    input rstn,
    input [`MODE_WIDTH-1:0] current_mode,
    input toggle_signal,
    output reg first_mode_controller_from_second_toggle
);

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        first_mode_controller_from_second_toggle <= 1'b0;
    end else begin
        case (current_mode)
            `SECOND_MODE: begin
                if (toggle_signal) begin
                    first_mode_controller_from_second_toggle <= 1'b1;
                end else begin
                    first_mode_controller_from_second_toggle <= 1'b0;
                end
            end
            default: begin
                first_mode_controller_from_second_toggle <= 1'b0;
            end
        endcase
    end
end
endmodule //first_mode_controller_from_second