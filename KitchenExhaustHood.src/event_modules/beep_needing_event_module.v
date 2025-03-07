`timescale 1ns/1ps
`include "../header_files/parameters.vh"

module beep_needing_event_module(
    input clk,
    input rstn,
    input [`MODE_WIDTH-1:0] current_mode,
    input [`MAX_WIDTH-1:0] total_running_time,
    input [`MAX_WIDTH-1:0] clean_remind_time,
    input clean_by_hand,
    output reg play_beep
);
    reg [`MAX_WIDTH-1:0] current_mode_l;//last cycle's current mode
    reg [`MAX_WIDTH-1:0] time_cleared;   

    wire is_larger_time;
    assign is_larger_time = total_running_time >= clean_remind_time;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            
        end else begin
            current_mode_l <= current_mode;
            if(is_larger_time) begin
                play_beep <=1;
            end
            else begin
                play_beep <=0;
            end

            if(clean_by_hand & is_larger_time) begin
                time_cleared <= time_cleared + 1;
            end
            else begin
                // do nothing
            end

            if((current_mode_l != current_mode)&(current_mode==`CLEAN_MODE)) begin
                time_cleared <= time_cleared + 1;
            end
            else begin
                // do nothing
            end
        end
    end



endmodule //beep_needing_event_module