`timescale 1ns/1ps
`include "../header_files/parameters.vh"

module stand_mode_controller_from_first (
    input clk,      //100MHz clock signal
    input rstn,     //active-low
    input toggle_signal, // debounced signal
    input [`MODE_WIDTH-1:0] current_mode, // current mode
    output reg stand_mode_controller_from_first_toggle // output toggle signal
);

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        stand_mode_controller_from_first_toggle <= 1'b0;
    end else begin
        case (current_mode)
            `FIRST_MODE: begin
                if (toggle_signal) begin
                    stand_mode_controller_from_first_toggle <= 1'b1;
                end else begin
                    stand_mode_controller_from_first_toggle <= 1'b0;
                end
            end
            default: begin
                stand_mode_controller_from_first_toggle <= 0;
            end
        endcase
    end
end

endmodule //stand_mode_controller_from_first