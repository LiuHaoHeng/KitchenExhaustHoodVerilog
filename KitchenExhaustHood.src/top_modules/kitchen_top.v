`timescale 1ns/1ps
`include "../header_files/parameters.vh"

module kitchen_top(
    input clk,
    input rstn,
    input power_switch_normal_input,
    input power_switch_left_gesture_input,
    input power_switch_right_gesture_input,
    input setting_input,
    input zero_input,
    input ps2_clk,
    input ps2_data,
    input islight_input,
    input check_total_time_input,
    output [`OUTPUT_WIDTH-1:0]shining,
    output reg [`MODE_WIDTH-1:0] current_mode,
    output loud,
    output beep,
    output [`MODE_WIDTH-1:0] seg_en,
    output [`MODE_WIDTH-1:0] seg_out_left,
    output [`MODE_WIDTH-1:0] seg_out_right
);

wire t1,t2,t3,tc,tm,tq,ta,tw,ts,te,td,tt,tg;
keyboard keyboard_inst(
    .clk(clk),
    .rstn(rstn),
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .t1(t1),.t2(t2),.t3(t3),.tc(tc),.tm(tm),
    .tq(tq),.ta(ta),.tw(tw),.ts(ts),.te(te),
    .td(td),.tt(tt),.tg(tg)
);


wire power_switch_normal_signal;
debouncer debouncer_normal_inst (
    .clk(clk),
    .rstn(rstn),
    .button_in(power_switch_normal_input),
    .debounced_out(power_switch_normal_signal)
);

wire power_switch_left_gesture_signal;
debouncer debouncer_left_gesture_inst (
    .clk(clk),
    .rstn(rstn),
    .button_in(power_switch_left_gesture_input),
    .debounced_out(power_switch_left_gesture_signal)
);

wire power_switch_right_gesture_signal;
debouncer debouncer_right_gesture_inst (
    .clk(clk),
    .rstn(rstn),
    .button_in(power_switch_right_gesture_input),
    .debounced_out(power_switch_right_gesture_signal)
);

wire menu_signal;
debouncer debouncer_menu_inst (
    .clk(clk),
    .rstn(rstn),
    .button_in(tm),
    .debounced_out(menu_signal)
);

wire first_signal;
debouncer debouncer_first_inst (
    .clk(clk),
    .rstn(rstn),
    .button_in(t1),
    .debounced_out(first_signal)
);

wire second_signal;
debouncer debouncer_second_inst (
    .clk(clk),
    .rstn(rstn),
    .button_in(t2),
    .debounced_out(second_signal)
);

wire third_signal;
debouncer debouncer_third_inst (
    .clk(clk),
    .rstn(rstn),
    .button_in(t3),
    .debounced_out(third_signal)
);

wire clean_signal;
debouncer debouncer_clean_inst (
    .clk(clk),
    .rstn(rstn),
    .button_in(tc),
    .debounced_out(clean_signal)
);

wire setting_signal;
debouncer debouncer_setting_inst (
    .clk(clk),
    .rstn(rstn),
    .button_in(setting_input),
    .debounced_out(setting_signal)
);

wire zero_signal;
debouncer debouncer_zero_inst (
    .clk(clk),
    .rstn(rstn),
    .button_in(zero_input),
    .debounced_out(zero_signal)
);

wire islight_signal;
debouncer debouncer_islight (
    .clk(clk),
    .rstn(rstn),
    .button_in(islight_input),
    .debounced_out(islight_signal)
);

wire check_total_time_signal;
debouncer debouncer_check_total_time (
    .clk(clk),
    .rstn(rstn),
    .button_in(check_total_time_input),
    .debounced_out(check_total_time_signal)
);

wire [`MAX_WIDTH-1:0] gesture_counter_time;

wire off_mode_toggle;
wire stand_mode_toggle;
wire clean_mode_toggle;
wire first_mode_toggle;
wire second_mode_toggle;
wire third_mode_toggle;
wire setting_mode_toggle;

off_mode_controller_top off_mode_controller_top_inst (
    .clk(clk),
    .rstn(rstn),
    .current_mode(current_mode),
    .normal_signal(power_switch_normal_signal),
    .left_gesture_signal(power_switch_left_gesture_signal),
    .right_gesture_signal(power_switch_right_gesture_signal),
    .gesture_counter_time(gesture_counter_time),
    .off_mode_toggle(off_mode_toggle)
); // check mode

stand_mode_controller_top stand_mode_controller_top_inst (
    .clk(clk),
    .rstn(rstn),
    .current_mode(current_mode),
    .normal_signal(power_switch_normal_signal),
    .left_gesture_signal(power_switch_left_gesture_signal),
    .right_gesture_signal(power_switch_right_gesture_signal),
    .gesture_counter_time(gesture_counter_time),
    .menu_signal(menu_signal),
    .stand_mode_toggle(stand_mode_toggle)
);

first_mode_controller_top first_mode_controller_top_inst (
    .clk(clk),
    .rstn(rstn),
    .current_mode(current_mode),
    .menu_signal(menu_signal),
    .normal_signal(first_signal),
    .second_signal(second_signal),
    .first_mode_toggle(first_mode_toggle)
);

second_mode_controller_top second_mode_controller_top_inst (
    .clk(clk),
    .rstn(rstn),
    .current_mode(current_mode),
    .menu_signal(menu_signal),
    .normal_signal(second_signal),
    .first_signal(first_signal),
    .second_mode_toggle(second_mode_toggle)
);

third_mode_controller_top third_mode_controller_top_inst (
    .clk(clk),
    .rstn(rstn),
    .current_mode(current_mode),
    .menu_signal(menu_signal),
    .normal_signal(third_signal),
    .third_mode_toggle(third_mode_toggle)
);

clean_mode_controller_top clean_mode_controller_top_inst (
    .clk(clk),
    .rstn(rstn),
    .current_mode(current_mode),
    .menu_signal(menu_signal),
    .normal_signal(clean_signal),
    .clean_mode_toggle(clean_mode_toggle)
);

setting_mode_controller_top setting_mode_controller_top_inst(
    .clk(clk),
    .rstn(rstn),
    .current_mode(current_mode),
    .toggle_signal(setting_signal),
    .setting_mode_toggle(setting_mode_toggle)
);

wire [31:0] numbers;
wire play_beep;
event_control event_control (
    .clk(clk),
    .rstn(rstn),
    .current_mode(current_mode), 
    .check_total_time_signal(check_total_time_signal), 
    .menu_signal(menu_signal), 
    .left_gesture_signal(power_switch_left_gesture_signal),
    .right_gesture_signal(power_switch_right_gesture_signal),
    .tq(tq),.ta(ta),.tw(tw),.ts(ts),.te(te),.td(td),.tt(tt),.tg(tg),
    .clean_by_hand(zero_signal),
    .numbers(numbers), //32 bits is setting for the 8-seg tubes, so not using MAX_WIDTH
    .play_beep(play_beep),
    .gesture_time(gesture_counter_time)
);

scan_seg scan_seg(
    .clk(clk),
    .rstn(rstn),
    .show(numbers),
    .seg_en(seg_en),
    .seg_out_left(seg_out_left),
    .seg_out_right(seg_out_right)
    );

player player(
    .clk(clk),
    .rstn(rstn),
    .play(play_beep),
    .beep(beep),
    .loud(loud)
);

shining_mode shining_mode(
    .clk(clk),
    .rstn(rstn),
    .islight_signal(islight_signal),
    .current_mode(current_mode),
    .shining(shining)
    );

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        current_mode <= `OFF_MODE;
    end else begin
        case (current_mode)

            `OFF_MODE: begin
                if (stand_mode_toggle)
                    current_mode <= `STAND_MODE;
            end
            
            `STAND_MODE: begin
                if (off_mode_toggle)
                    current_mode <= `OFF_MODE;
                else if (first_mode_toggle)
                    current_mode <= `FIRST_MODE;
                else if (second_mode_toggle)
                    current_mode <= `SECOND_MODE;
                else if (third_mode_toggle)
                    current_mode <= `THIRD_MODE;
                else if (clean_mode_toggle)
                    current_mode <= `CLEAN_MODE;
                else if (setting_mode_toggle)
                    current_mode <= `SET_MODE;
            end
            
            `FIRST_MODE: begin
                if (off_mode_toggle)
                    current_mode <= `OFF_MODE;
                else if (stand_mode_toggle)
                    current_mode <= `STAND_MODE;
                else if (second_mode_toggle)
                    current_mode <= `SECOND_MODE;
            end
            
            `SECOND_MODE: begin
                if (off_mode_toggle)
                    current_mode <= `OFF_MODE;
                else if (stand_mode_toggle)
                    current_mode <= `STAND_MODE;
                else if (first_mode_toggle)
                    current_mode <= `FIRST_MODE;
            end
            
            `THIRD_MODE: begin
                if (off_mode_toggle)
                    current_mode <= `OFF_MODE;
                else if (stand_mode_toggle)
                    current_mode <= `STAND_MODE;
                else if (second_mode_toggle)
                    current_mode <= `SECOND_MODE;
            end
            
            `CLEAN_MODE: begin
                if (off_mode_toggle)
                    current_mode <= `OFF_MODE;
                else if (stand_mode_toggle)
                    current_mode <= `STAND_MODE;
            end
            
            `SET_MODE: begin
                if (off_mode_toggle)
                    current_mode <= `OFF_MODE;
                else if (stand_mode_toggle)
                    current_mode <= `STAND_MODE;
            end
        endcase
    end
end

endmodule