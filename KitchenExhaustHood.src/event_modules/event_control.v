`timescale 1ns/1ps
`include "../header_files/parameters.vh"

module event_control (
    input wire clk,
    input wire rstn,
    input [`MODE_WIDTH-1:0] current_mode,   
    input wire tq,ta,tw,ts,te,td,tt,tg,
    input clean_by_hand,
    input check_total_time_signal,
    input menu_signal,
    input left_gesture_signal,
    input right_gesture_signal,
    output reg [31:0] numbers, //32 bits is setting for the 8-seg tubes, so not using MAX_WIDTH
    output [3:0] gesture_time,
    output play_beep
);
    //numbers means the numbers to be displayed on the 8-seg tubes

    //examplify the clean mode event module
    wire [`MAX_WIDTH-1:0] clean_current_running_time, clean_total_running_time;
    wire [`MAX_WIDTH-1:0] clean_current_running_numbers;
    assign clean_current_running_numbers = hms888(`CLEAN_MODE_COUNTER_TIME-clean_current_running_time);
    clean_mode_event_module clean_mode_event_module(
        .clk(clk),
        .rstn(rstn),
        .current_mode(current_mode),
        .current_running_time(clean_current_running_time),
        .total_running_time(clean_total_running_time)
    );

    //examplify the first mode event module
    wire [`MAX_WIDTH-1:0] first_current_running_time, first_total_running_time;
    wire [31:0] first_current_running_numbers;
    assign first_current_running_numbers = hms888(first_current_running_time);
    first_mode_event_module first_mode_event_module (
        .clk(clk),
        .rstn(rstn),
        .current_mode(current_mode),
        .current_running_time(first_current_running_time),
        .total_running_time(first_total_running_time)
    );

    //examplify the second mode event module
    wire [`MAX_WIDTH-1:0] second_current_running_time, second_total_running_time;
    wire [31:0] second_current_running_numbers;
    assign second_current_running_numbers = hms888(second_current_running_time);
    second_mode_event_module second_mode_event_module (
        .clk(clk),
        .rstn(rstn),
        .current_mode(current_mode),
        .current_running_time(second_current_running_time),
        .total_running_time(second_total_running_time)
    );

    //examplify the third mode event module
    wire [`MAX_WIDTH-1:0] third_current_running_time, third_total_running_time;
    wire [`MAX_WIDTH-1:0] third_output_time;
    wire [`MAX_WIDTH-1:0] third_output_numbers;
    assign third_output_numbers = hms888(third_output_time);
    third_mode_event_module third_mode_event_module (
        .clk(clk),
        .rstn(rstn),
        .current_mode(current_mode),
        .menu_signal(menu_signal),
        .current_running_time(third_current_running_time),
        .total_running_time(third_total_running_time),
        .third_output_time(third_output_time)
    );

    //examplify the setting mode event module
    wire [`MAX_WIDTH-1:0] clean_remind_time;
    wire [31:0] setting_mode_numbers;
    setting_mode_event_module setting_mode_event_module (
        .clk(clk),
        .rstn(rstn),
        .current_mode(current_mode),
        .tq(tq),
        .ta(ta),
        .tw(tw),
        .ts(ts),
        .te(te),
        .td(td),
        .tt(tt),
        .tg(tg),
        .numbers(setting_mode_numbers),
        .clean_remind_time(clean_remind_time),
        .gesture_time(gesture_time)
    );

    //examplify the stand mode event module
    wire [`MAX_WIDTH-1:0] stand_current_running_time;
    wire [`MAX_WIDTH-1:0] stand_output_time;
    wire [`MAX_WIDTH-1:0] stand_current_running_numbers;
    assign stand_current_running_numbers = hms888(stand_output_time);
    stand_mode_event_module stand_mode_event_module (
        .clk(clk),
        .rstn(rstn),
        .tq(tq),.ta(ta),.tw(tw),.ts(ts),
        .current_mode(current_mode),
        .first_toggle_signal(right_gesture_signal),
        .counter_time(gesture_time),
        .running_time(stand_current_running_time),
        .stand_output_time(stand_output_time)
    );
    
    wire [`MAX_WIDTH-1:0] off_output_time;
    wire [`MAX_WIDTH-1:0] off_current_running_numbers;
    assign off_current_running_numbers = hms888(off_output_time);
    off_mode_event_module off_mode_event_module (
        .clk(clk),
        .rstn(rstn),
        .current_mode(current_mode),
        .first_toggle_signal(left_gesture_signal),
        .counter_time(gesture_time),
        .off_output_time(off_output_time)
      );
    
    //convert seconds to hms, 8 bits for each, 32 bits in total
    function [31:0] hms888(input [31:0] sec_in);
        begin
            hms888[31:28] = sec_in / 3600 / 10;
            hms888[27:24] = sec_in / 3600 % 10;                  // Hours
            hms888[23:20] = 4'hc;
            hms888[19:16] = (sec_in % 3600) / 60 / 10;
            hms888[15:12] = (sec_in % 3600) / 60 % 10;           // Minutes
            hms888[11:8] = 4'hc;
            hms888[7:4] = (sec_in % 60) / 10;
            hms888[3:0] = sec_in % 60 % 10;                      // Seconds
        end
    endfunction
    
    wire [`MAX_WIDTH-1:0] total_running_time;
    wire [`MAX_WIDTH-1:0] add_running_time;
    wire [`MAX_WIDTH-1:0] total_running_numbers;
    reg [`MAX_WIDTH-1:0] cleaned_time;

    assign add_running_time = first_total_running_time + second_total_running_time + third_total_running_time;
    assign total_running_time = add_running_time - cleaned_time;
    assign total_running_numbers = hms888(total_running_time);
    //examplify the beep needing event module
    beep_needing_event_module beep_needing_event_module (
        .clk(clk),
        .rstn(rstn),
        .current_mode(current_mode),
        .clean_by_hand(clean_by_hand),
        .total_running_time(total_running_time),
        .clean_remind_time(clean_remind_time),
        .play_beep(play_beep)
    );
    
    
    
    always @(posedge clk) begin
        if(!rstn) begin
            cleaned_time <= 1'b0;
        end else begin
            case (current_mode)
                `OFF_MODE: numbers <= (off_output_time == 0)?32'hffffffff:off_current_running_numbers;
                `CLEAN_MODE : numbers <= clean_current_running_numbers;
                `FIRST_MODE : numbers <= first_current_running_numbers;
                `SECOND_MODE : numbers <= second_current_running_numbers;
                `THIRD_MODE : numbers <= third_output_numbers;
                `STAND_MODE : 
                    if(!check_total_time_signal) begin
                        numbers <= stand_current_running_numbers;
                    end else begin
                        numbers <= total_running_numbers;
                    end
                `SET_MODE : numbers <= setting_mode_numbers;
                default : numbers <= 32'hffffffff;
            endcase
            case (current_mode)
                `OFF_MODE: begin
                // do nothing
                end
                `CLEAN_MODE: begin
                    cleaned_time <= add_running_time;
                end
                default: begin
                    if(clean_by_hand)
                        cleaned_time <= add_running_time;
                    
                end
            endcase
            end
        end

endmodule //event_control