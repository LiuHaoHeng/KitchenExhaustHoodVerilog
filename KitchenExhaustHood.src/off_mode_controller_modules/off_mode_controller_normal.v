`timescale 1ns/1ps
`include "../header_files/parameters.vh"

module off_mode_controller_normal(
    input clk,
    input rstn,
    input toggle_signal, // 已经去抖的信号
    input [`MODE_WIDTH-1:0] current_mode,
    output reg off_mode_controller_normal_toggle
);
    reg [`MAX_WIDTH-1:0] counter_reg;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            counter_reg = 32'b0;
            off_mode_controller_normal_toggle <= 1'b0;
        end else begin
            case (current_mode)
                `OFF_MODE: begin
                    counter_reg <= 32'b0;
                    off_mode_controller_normal_toggle <= 1'b0;
                end
                default: begin
                    if (toggle_signal) begin
                        counter_reg <= counter_reg + 1;
                    end else begin
                        counter_reg <= 32'b0;
                    end
                    if (counter_reg >= `OFF_MODE_NORMAL_COUNT_TIME) begin
                        off_mode_controller_normal_toggle <= 1'b1;
                    end else begin
                        // off_mode_controller_normal_toggle <= 1'b0;
                    end
                end
            endcase
        end
    end
endmodule