`timescale 1ns/1ps
`include "../header_files/parameters.vh"

module clean_mode_controller_top (
    input clk,
    input rstn,
    input [`MODE_WIDTH-1:0] current_mode,
    input menu_signal,
    input normal_signal,
    output reg clean_mode_toggle
);

wire clean_mode_controller_normal_toggle;
clean_mode_controller_normal clean_mode_controller_normal_inst (
    .clk(clk),
    .rstn(rstn),
    .current_mode(current_mode),
    .menu_signal(menu_signal),
    .normal_signal(normal_signal),
    .clean_mode_controller_normal_toggle(clean_mode_controller_normal_toggle)
);

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        clean_mode_toggle <= 1'b0;
    end else begin
        case (current_mode)
            `STAND_MODE: begin
                if (clean_mode_controller_normal_toggle) begin
                    clean_mode_toggle <= 1;
                end else begin
                    clean_mode_toggle <= 0;
                end
            end
            default: begin
                clean_mode_toggle <= 0;
            end
        endcase
    end
end
endmodule //clean_mode_controller_top