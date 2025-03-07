`timescale 1ns/1ps
`include "../header_files/parameters.vh"

module clean_mode_event_module (
    input clk,
    input rstn,
    input [`MODE_WIDTH-1:0] current_mode,
    output reg [`MAX_WIDTH-1:0] current_running_time,
    output reg [`MAX_WIDTH-1:0] total_running_time
);
    // Counter to keep track of time in clean mode
    reg [`MAX_WIDTH-1:0] counter;
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            current_running_time <= 0;
            total_running_time <= 0;
            counter <= 0;
        end else begin
            case (current_mode)
                `CLEAN_MODE : begin
                    counter <= counter + 1;
                    if (counter == `COUNTER_1SEC) begin
                        current_running_time <= current_running_time + 1;
                        total_running_time <= total_running_time + 1;
                        counter <= 0;
                    end
                end
                default : begin
                    // Reset current_running_time to 0 when not in CLEAN_MODE
                    current_running_time <= 0;
                    counter <= 0;
                end
            endcase
        end
    end

endmodule //clean_mode_event_module