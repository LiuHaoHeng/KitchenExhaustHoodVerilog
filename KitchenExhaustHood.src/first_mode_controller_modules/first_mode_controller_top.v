`timescale 1ns/1ps
`include "../header_files/parameters.vh"

module first_mode_controller_top (
    input clk,
    input rstn,
    input [`MODE_WIDTH-1:0] current_mode,
    input menu_signal,
    input normal_signal,
    input second_signal,
    output reg first_mode_toggle
);

wire first_mode_controller_normal_toggle;
first_mode_controller_normal first_mode_controller_normal_inst (
    .clk(clk),
    .rstn(rstn),
    .current_mode(current_mode),
    .menu_signal(menu_signal),
    .normal_signal(normal_signal),
    .first_mode_controller_normal_toggle(first_mode_controller_normal_toggle)
);

wire first_mode_controller_from_second_toggle;
first_mode_controller_from_second first_mode_controller_from_second_inst (
    .clk(clk),
    .rstn(rstn),
    .current_mode(current_mode),
    .toggle_signal(normal_signal),
    .first_mode_controller_from_second_toggle(first_mode_controller_from_second_toggle)
);

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        first_mode_toggle <= 1'b0;
    end else begin
        case (current_mode)
            `STAND_MODE: begin
                if (first_mode_controller_normal_toggle) begin
                    first_mode_toggle <= 1;
                end else begin
                    first_mode_toggle <= 0;
                end
            end
            `SECOND_MODE: begin
                if (first_mode_controller_from_second_toggle) begin
                    first_mode_toggle <= 1;
                end else begin
                    first_mode_toggle <= 0;
                end
            end
            default: begin
                first_mode_toggle <= 0;
            end
        endcase
    end
end

endmodule //first_mode_controller_top