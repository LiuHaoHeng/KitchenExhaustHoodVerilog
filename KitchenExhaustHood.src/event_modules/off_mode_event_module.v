`timescale 1ns/1ps
`include "../header_files/parameters.vh"

module off_mode_event_module (
    input clk,
    input rstn,
    input [`MODE_WIDTH-1:0] current_mode,
    input first_toggle_signal,
    input [`MAX_WIDTH-1:0] counter_time,
    output [`MAX_WIDTH-1:0] off_output_time
);

    reg reset_signal;
    wire [`MAX_WIDTH-1:0] counter_reg;
    wire done;
    
    countdown_timer from_off_to_stand_timer_inst (
        .clk(clk),
        .rstn(rstn),
        .start(first_toggle_signal),
        .load_value(counter_time),
        .count_reg(counter_reg),
        .reset_signal(reset_signal),
        .done(done)
    );

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            reset_signal <= 1'b1;
        end else begin
            case (current_mode)
                `OFF_MODE: begin
                    reset_signal <= 1'b0;
                end
                default: begin
                    reset_signal <= 1'b1;
                end
            endcase
        end
    end
    assign off_output_time = done ? 0 : counter_reg;

endmodule