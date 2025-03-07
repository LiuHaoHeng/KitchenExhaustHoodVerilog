`timescale 1ns / 1ps
`include "../header_files/parameters.vh"

module setting_mode_event_module(
    input clk,
    input rstn,                             //low active reset
    input [`MODE_WIDTH-1:0] current_mode,
    input tq,ta,tw,ts,te,td,tt,tg,          //keyboard test for the corresponding letters
    output [`MAX_WIDTH-1:0] numbers,         //every 4 bits represent a number in hexa to the 8 seg tubes
    output reg [`MAX_WIDTH-1:0] clean_remind_time, //the clean reminder time in seconds
    output reg [3:0] gesture_time                 //the gesture to switch between on and off
);
    //parameters for adjusting the clean reminder time and gesture time
    parameter sec = 1;   
    parameter min = 60;  
    parameter hour = 3600; 
    
    wire [7:0] sel;                         //the current sel
    reg [7:0] sel_l;                        //the last sel

    //combine it to a one-hot code
    assign sel= {tg,tt,td,te,ts,tw,ta,tq};                  
    
    //assign the numbers to the 8-seg tubes
    assign numbers[31:28] = clean_remind_time/3600/10;          //represent the first digit of the hour
    assign numbers[27:24] = clean_remind_time/3600%10;          //represent the second digit of the hour
    assign numbers[23:20] = (clean_remind_time%3600/60)/10;     //represent the first digit of the minute
    assign numbers[19:16] = (clean_remind_time%3600/60)%10;     //represent the second digit of the minute
    assign numbers[15:12] = (clean_remind_time%60)/10;          //represent the first digit of the second
    assign numbers[11:8] = clean_remind_time%10;                //represent the second digit of the second
    assign numbers[7:4] = gesture_time/10;                      //assign numbers[7:4] = gesture_time/10;
    assign numbers[3:0] = gesture_time%10;                     //assign numbers[3:0] = gesture_time%10;
    
    //always block to adjust the clean reminder time and gesture time
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            clean_remind_time <= `DEFAULT_CLEAN_REMIND_TIME;
            gesture_time <= `DEFAULT_GESTURE_TIME;
            sel_l <= 8'b0;
        end else begin
            case (current_mode)
                `SET_MODE : begin
                    sel_l <= sel;
                    if (sel != sel_l) begin
                        case (sel)
                            8'h01: // tq: Increase clean reminder time by an hour
                                clean_remind_time <= (clean_remind_time <= `MAX_CLEAN_REMIND_TIME-hour) ? clean_remind_time + hour : `MAX_CLEAN_REMIND_TIME;
                            8'h02: // ta: Decrease clean reminder time by an hour
                                clean_remind_time <= (clean_remind_time >= `MIN_CLEAN_REMIND_TIME+hour) ? clean_remind_time - hour : `MIN_CLEAN_REMIND_TIME;
                            8'h04: // tw: Increase clean reminder time by a minute
                                clean_remind_time <= (clean_remind_time <= `MAX_CLEAN_REMIND_TIME-min) ? clean_remind_time + min : `MAX_CLEAN_REMIND_TIME;
                            8'h08: // ts: Decrease clean reminder time by a minute
                                clean_remind_time <= (clean_remind_time >= `MIN_CLEAN_REMIND_TIME+min) ? clean_remind_time - min : `MIN_CLEAN_REMIND_TIME;
                            8'h10: // te: Increase clean reminder time by a second
                                clean_remind_time <= (clean_remind_time <= `MAX_CLEAN_REMIND_TIME-sec) ? clean_remind_time + sec : `MAX_CLEAN_REMIND_TIME;
                            8'h20: // td: Decrease clean reminder time by a second
                                clean_remind_time <= (clean_remind_time >= `MIN_CLEAN_REMIND_TIME+sec) ? clean_remind_time - sec : `MIN_CLEAN_REMIND_TIME;
                            8'h40: // tt: Increase gesture time by a second
                                gesture_time <= (gesture_time + sec <= `MAX_GESTURE_TIME) ? gesture_time + sec : `MAX_GESTURE_TIME;
                            8'h80: // tg: Decrease gesture time by a second
                                gesture_time <= (gesture_time - sec >= `MIN_GESTURE_TIME) ? gesture_time - sec : `MIN_GESTURE_TIME;
                            default: begin
                                // No operation for undefined signals
                                // This case ensures that if none of the specified cases match, 
                                // the values of clean_remind_time and gesture_time remain unchanged.
                            end
                        endcase
                    end
                end
                default: begin
                    // Reset clean_remind_time and gesture_time to default values when not in SET_MODE
                    sel_l <= 8'b0;
                end
                endcase
        end
    end

endmodule


