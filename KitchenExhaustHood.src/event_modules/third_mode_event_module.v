`timescale 1ns/1ps
`include "../header_files/parameters.vh"

module third_mode_event_module (
    input clk,
    input rstn,
    input [`MODE_WIDTH-1:0] current_mode,
    input menu_signal,
    output reg [`MAX_WIDTH-1:0] current_running_time,
    output reg [`MAX_WIDTH-1:0] total_running_time,
    output [`MAX_WIDTH-1:0] third_output_time
);
reg [`MAX_WIDTH-1:0] need_add_time;
reg menu_signal_d;
reg [`MAX_WIDTH-1:0] counter;
assign third_output_time = `THIRD_MODE_COUNTER_TIME - current_running_time + need_add_time;
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        current_running_time <= 0;
        total_running_time <= 0;
        counter <= 0;
        menu_signal_d <= 0;
        need_add_time <= 0;
    end else begin
        menu_signal_d <= menu_signal;
        case (current_mode)
            `THIRD_MODE : begin
                counter <= counter + 1;
                if (counter == `COUNTER_1SEC) begin
                    current_running_time <= current_running_time + 1;
                    total_running_time <= total_running_time + 1;
                    counter <= 0;
                end
                if (!menu_signal_d && menu_signal) begin
                    need_add_time <= current_running_time;
                end
            end
            default : begin
                current_running_time <= 0;
                counter <= 0;
                menu_signal_d <= 0;
                need_add_time <= 0;
            end
        endcase
    end
end
endmodule //third_mode_event_module