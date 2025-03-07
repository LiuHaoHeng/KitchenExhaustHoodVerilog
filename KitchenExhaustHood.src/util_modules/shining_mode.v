`timescale 1ns / 1ps
`include "../header_files/parameters.vh"

module shining_mode(
    input clk,
    input rstn,
    input islight_signal,
    input [`MODE_WIDTH-1:0] current_mode,
    output reg [`OUTPUT_WIDTH-1:0] shining
    );
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            shining<=8'b0;
        end
        else begin
            if(islight_signal) begin
                case(current_mode)
                    `OFF_MODE:
                        shining<=8'b0;
                    default: shining<=8'b11111111;
                endcase
            end
            else begin
                shining<=8'b0;
            end
        end
    end
endmodule
