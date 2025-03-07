`timescale 1ns/1ps
`include "../header_files/parameters.vh"

module second_mode_controller_top (
    input clk,
    input rstn,
    input [`MODE_WIDTH-1:0] current_mode,
    input menu_signal,
    input normal_signal,
    input first_signal,
    output reg second_mode_toggle
);

wire second_mode_controller_normal_toggle;
second_mode_controller_normal second_mode_controller_normal_inst (
    .clk(clk),
    .rstn(rstn),
    .current_mode(current_mode),
    .menu_signal(menu_signal),
    .normal_signal(normal_signal),
    .second_mode_controller_normal_toggle(second_mode_controller_normal_toggle)
);

wire second_mode_controller_from_first_toggle;
second_mode_controller_from_first second_mode_controller_from_first_inst (
    .clk(clk),
    .rstn(rstn),
    .current_mode(current_mode),
    .toggle_signal(normal_signal),
    .second_mode_controller_from_first_toggle(second_mode_controller_from_first_toggle)
);

wire second_mode_controller_from_third_toggle;
second_mode_controller_from_third second_mode_controller_from_third_inst (
    .clk(clk),
    .rstn(rstn),
    .current_mode(current_mode),
    .menu_signal(menu_signal),
    .second_mode_controller_from_third_toggle(second_mode_controller_from_third_toggle)
);

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        second_mode_toggle <= 1'b0;
    end else begin
        case (current_mode)
            `STAND_MODE: begin
                if (second_mode_controller_normal_toggle) begin
                    second_mode_toggle <= 1;
                end else begin
                    second_mode_toggle <= 0;
                end
            end
            `FIRST_MODE: begin
                if (second_mode_controller_from_first_toggle) begin
                    second_mode_toggle <= 1;
                end else begin
                    second_mode_toggle <= 0;
                end
            end
            `THIRD_MODE: begin
                if (second_mode_controller_from_third_toggle) begin
                    second_mode_toggle <= 1;
                end else begin
                    second_mode_toggle <= 0;
                end
            end
            default: begin
                second_mode_toggle <= 0;
            end
        endcase
    end
end

endmodule //second_mode_controller_top