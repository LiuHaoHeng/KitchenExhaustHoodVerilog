`timescale 1ns/1ps
`include "../header_files/parameters.vh"

module stand_mode_controller_top (
    input clk, //100MHz clock signal
    input rstn, //active-low
    input [`MODE_WIDTH-1:0] current_mode, // current mode
    input normal_signal, // debounced signal
    input left_gesture_signal,
    input right_gesture_signal,
    input [`MAX_WIDTH-1:0] gesture_counter_time,
    input menu_signal,
    output reg stand_mode_toggle // output toggle signal
);

wire stand_mode_controller_normal_toggle;
stand_mode_controller_normal stand_mode_controller_normal_inst (
    .clk(clk),
    .rstn(rstn),
    .toggle_signal(normal_signal),
    .current_mode(current_mode),
    .stand_mode_controller_normal_toggle(stand_mode_controller_normal_toggle)
);

wire stand_mode_controller_gesture_toggle;
stand_mode_controller_gesture stand_mode_controller_gesture_inst (
    .clk(clk),
    .rstn(rstn),
    .first_toggle_signal(left_gesture_signal),
    .second_toggle_signal(right_gesture_signal),
    .counter_time(gesture_counter_time),
    .current_mode(current_mode),
    .stand_mode_controller_gesture_toggle(stand_mode_controller_gesture_toggle)
);

wire stand_mode_controller_from_first_toggle;
stand_mode_controller_from_first stand_mode_controller_from_first_inst (
    .clk(clk),
    .rstn(rstn),
    .toggle_signal(menu_signal),
    .current_mode(current_mode),
    .stand_mode_controller_from_first_toggle(stand_mode_controller_from_first_toggle)
);

wire stand_mode_controller_from_second_toggle;
stand_mode_controller_from_second stand_mode_controller_from_second_inst (
    .clk(clk),
    .rstn(rstn),
    .toggle_signal(menu_signal),
    .current_mode(current_mode),
    .stand_mode_controller_from_second_toggle(stand_mode_controller_from_second_toggle)
);

wire stand_mode_controller_from_third_toggle;
stand_mode_controller_from_third stand_mode_controller_from_third_inst (
    .clk(clk),
    .rstn(rstn),
    .toggle_signal(menu_signal),
    .current_mode(current_mode),
    .stand_mode_controller_from_third_toggle(stand_mode_controller_from_third_toggle)
);

wire stand_mode_controller_from_clean_toggle;
stand_mode_controller_from_clean stand_mode_controller_from_clean_inst (
    .clk(clk),
    .rstn(rstn),
    .current_mode(current_mode),
    .stand_mode_controller_from_clean_toggle(stand_mode_controller_from_clean_toggle)
);

wire stand_mode_controller_from_setting_toggle;
stand_mode_controller_from_setting stand_mode_controller_from_setting_inst(
    .clk(clk),
    .rstn(rstn),
    .current_mode(current_mode),
    .toggle_signal(menu_signal),
    .stand_mode_controller_from_setting_toggle(stand_mode_controller_from_setting_toggle)
);

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        stand_mode_toggle <= 1'b0;
    end else begin
        case (current_mode)
            `OFF_MODE: begin
                if (stand_mode_controller_normal_toggle) begin
                    stand_mode_toggle <= 1;
                end else if (stand_mode_controller_gesture_toggle) begin
                    stand_mode_toggle <= 1;
                end else begin
                    stand_mode_toggle <= 0;
                end
            end
            
            `FIRST_MODE: begin
                if (stand_mode_controller_from_first_toggle) begin
                    stand_mode_toggle <= 1;
                end else begin
                    stand_mode_toggle <= 0;
                end
            end
            
            `SECOND_MODE: begin
                if (stand_mode_controller_from_second_toggle) begin
                    stand_mode_toggle <= 1;
                end else begin
                    stand_mode_toggle <= 0;
                end
            end
            
            `THIRD_MODE: begin
                if (stand_mode_controller_from_third_toggle) begin
                    stand_mode_toggle <= 1;
                end else begin
                    stand_mode_toggle <= 0;
                end
            end
            
            `CLEAN_MODE: begin
                if (stand_mode_controller_from_clean_toggle) begin
                    stand_mode_toggle <= 1;
                end else begin
                    stand_mode_toggle <= 0;
                end
            end
            
            `SET_MODE: begin
                if (stand_mode_controller_from_setting_toggle) begin
                    stand_mode_toggle <= 1;
                end else begin
                    stand_mode_toggle <= 0;
                end
            end
            default: begin
                stand_mode_toggle <= 0;
            end
        endcase
    end
end

endmodule //stand_mode_top