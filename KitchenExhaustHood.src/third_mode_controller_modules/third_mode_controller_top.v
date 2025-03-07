`timescale 1ns/1ps
`include "../header_files/parameters.vh"

module third_mode_controller_top (
    input clk,
    input rstn,
    input [`MODE_WIDTH-1:0] current_mode,
    input menu_signal,
    input normal_signal,
    output reg third_mode_toggle
);

wire third_mode_controller_normal_toggle;
third_mode_controller_normal third_mode_controller_normal_inst (
    .clk(clk),
    .rstn(rstn),
    .current_mode(current_mode),
    .menu_signal(menu_signal),
    .normal_signal(normal_signal),
    .third_mode_controller_normal_toggle(third_mode_controller_normal_toggle)
);

reg has_opened;
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        third_mode_toggle <= 1'b0;
        has_opened <= 1'b0;
    end else begin
        case (current_mode)
            `OFF_MODE: begin
                third_mode_toggle <= 1'b0;
                has_opened <= 1'b0;
            end
            
            `STAND_MODE: begin
                if (third_mode_controller_normal_toggle && !has_opened) begin
                    third_mode_toggle <= 1'b1;
                    has_opened <= 1'b1;
                end else begin
                    third_mode_toggle <= 1'b0;
                end
            end
            default: begin
                third_mode_toggle <= 1'b0;
            end
        endcase
    end
end
endmodule //third_mode_controller_top