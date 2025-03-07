`timescale 1ns / 1ps
`include "../header_files/parameters.vh"

module countdown_timer(
    input clk,      //100MHz clock signal
    input rstn,     //active-low
    input start,    //egedge start
    input [`MAX_WIDTH-1:0] load_value,      //the seconds need to count
    input reset_signal, //reset the timer
    output reg [`MAX_WIDTH-1:0] count_reg,  //the left seconds
    output reg done                 //high represent done
);
    reg start_d;
    reg [`MAX_WIDTH-1:0] sec_counter; 
    reg started;
    reg reset_signal_d;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            reset_signal_d <= 1'b1;
            start_d <= 0;
            count_reg <= 0;
            done <= 1;
            started <= 0;
            sec_counter <= 0;
        end else begin
            reset_signal_d <= reset_signal;
            start_d <= start;
            if (reset_signal_d && ~reset_signal) begin
                count_reg <= 0;
                done <= 1;
                started <= 0;
                sec_counter <= 0;
            end else if (start && ~start_d) begin
                count_reg <= load_value;
                done <= 0;
                started <= 1;
                sec_counter <= 0;
            end else if (started) begin
                if (count_reg > 0) begin
                    if (sec_counter == `COUNTER_1SEC - 1) begin
                        sec_counter <= 0;
                        count_reg <= count_reg - 1;
                        if (count_reg == 1) begin
                            done <= 1;
                            started <= 0;
                        end
                    end else begin
                        sec_counter <= sec_counter + 1;
                    end
                end else begin
                    started <= 0;
                end
            end
        end
    end
endmodule