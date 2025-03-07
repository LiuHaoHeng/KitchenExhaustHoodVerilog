`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/23 01:17:18
// Design Name: 
// Module Name: keyboard
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module keyboard (
    input clk,
    input rstn,   
    input ps2_clk, 
    input ps2_data, 
    output t1,t2,t3,tc,tm,
    output tq,ta,tw,ts,te,td,tt,tg
);
    reg [7:0] key_code;
    reg can_display;
    reg [2:0] ps2_clk_determine;
    reg [3:0] situation;
    reg [7:0] temp_data;
    wire ps2_clk_neg;
    assign ps2_clk_neg = ps2_clk_determine[1] & (~ps2_clk_determine[0]); 
    assign t1= (key_code==8'h16);
    assign t2= (key_code==8'h1e);
    assign t3= (key_code==8'h26);
    assign tc= (key_code==8'h21);
    assign tm= (key_code==8'h3a);
    assign tq= (key_code==8'h15);
    assign ta= (key_code==8'h1c);
    assign tw= (key_code==8'h1d);
    assign ts= (key_code==8'h1b);
    assign te= (key_code==8'h24);
    assign td= (key_code==8'h23);
    assign tt= (key_code==8'h2c);
    assign tg= (key_code==8'h34);
    
    
    always @(posedge clk or negedge rstn) begin
        if(~rstn) begin
//            ps2_clk_determine <= 3'b0;
        end
        else begin
            ps2_clk_determine[2] <= ps2_clk_determine[1];
            ps2_clk_determine[1] <= ps2_clk_determine[0];
            ps2_clk_determine[0] <= ps2_clk;
        end
    end
    
    always @(posedge clk or negedge rstn) begin    
        if(~rstn) begin
            situation <= 4'd0;
            temp_data <= 8'd0;
        end
        else if(ps2_clk_neg) begin  
            case(situation) 
                4'd0: begin
                    situation <= situation + 1;
                end
                4'd1: begin
                    situation <= situation + 1;
                    temp_data[0] <= ps2_data;
                end
                4'd2: begin
                    situation <= situation + 1;
                    temp_data[1] <= ps2_data;
                end
                4'd3: begin
                    situation <= situation + 1;
                    temp_data[2] <= ps2_data;
                end
                4'd4: begin
                    situation <= situation + 1;
                    temp_data[3] <= ps2_data;
                end
                4'd5: begin
                    situation <= situation + 1;
                    temp_data[4] <= ps2_data;
                end
                4'd6: begin
                   situation <= situation + 1;
                    temp_data[5] <= ps2_data;
                end
                4'd7: begin
                    situation <= situation + 1;
                    temp_data[6] <= ps2_data;
                end
                4'd8: begin
                    situation <= situation + 1;
                    temp_data[7] <= ps2_data;
                end
                4'd9: begin
                    situation <= situation + 1;
                end
                4'd10: begin
                    situation <= 4'd0;
                end
                default:
                    situation <= 4'd0;
            endcase
        end
    end
    
    reg cool_down = 0;
    reg [32:0] count = 0;
    always @(posedge clk or negedge rstn) begin
        if(~rstn) begin
            key_code <= 8'd0;
            can_display <= 1;
        end
        else begin  
            if(situation == 4'd10) begin  
                if(temp_data == 8'hf0) begin
                    can_display <= 0;
                    key_code <= 0;
                end
                else begin
                    if(can_display) key_code<=temp_data;
                    if(cool_down) can_display <= 1;
                end
            end
            if(can_display == 0) begin
                count <= count + 1;
                if(count > 10000000) begin
                    can_display <= 1;
                    count <= 0;
                end
            end
        end
    end
endmodule

 
 
 
 
 
 
 
 
