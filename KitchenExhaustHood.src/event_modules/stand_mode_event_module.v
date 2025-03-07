`timescale 1ns/1ps
`include "../header_files/parameters.vh"

module stand_mode_event_module (
    input clk,
    input rstn,
    input tq,ta,tw,ts,
    input [`MODE_WIDTH-1:0] current_mode,
    input first_toggle_signal,
    input [`MAX_WIDTH-1:0] counter_time,
    output reg [`MAX_WIDTH-1:0] running_time,
    output [`MAX_WIDTH-1:0] stand_output_time
);

    parameter maximun=216000; //60h
    parameter minimun=0;
    
    parameter min=60;
    parameter hour=3600;
    
    // Counter to keep track of time in stand mode
    reg [`MAX_WIDTH-1:0] counter;
    wire [3:0] sel;
    reg [3:0] sel_l;
    assign sel={ts,tw,ta,tq};
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            running_time <= 0;
            counter <= 0;
        end else begin
            case (current_mode)
                `OFF_MODE: begin
                    running_time <= 0;
                    counter <= 0;
                end
                default : begin
                    // Increment counter every clock cycle
                    counter <= counter + 1;
                    if(current_mode==`STAND_MODE) begin
                        if(sel_l==sel)begin 
                        end else 
                        case(sel)
                            4'h1: running_time <= (running_time+hour<=maximun) ? running_time +hour: maximun;
                            4'h2: running_time <= (running_time-hour>=minimun) ? running_time -hour: minimun;
                            4'h4: running_time <= (running_time+min<=maximun) ? running_time +min: maximun;
                            4'h8: running_time <= (running_time-min>=minimun) ? running_time -min: minimun;
                        endcase
                        sel_l<=sel;
                    end
                    if (counter == `COUNTER_1SEC) begin
                        // Increment running_time every second
                        running_time <= running_time + 1;
                        counter <= 0;
                    end else ;
                    if (running_time>maximun) begin
                        running_time<=0;
                    end else;
                end
            endcase
        end
    end
    
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
                `STAND_MODE: begin
                    reset_signal <= 1'b0;
                end
                default: begin
                    reset_signal <= 1'b1;
                end
            endcase
        end
    end
    assign stand_output_time = done ? running_time : counter_reg;
endmodule //stand_mode_event_modules