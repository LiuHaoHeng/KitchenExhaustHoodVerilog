`timescale 1ns / 1ps


module scan_seg(
    input rstn,
    input clk,
    input [31:0] show,
    output reg [7:0] seg_en,
    output [7:0] seg_out_left,
    output [7:0] seg_out_right
    );
    reg clkout;
    reg [31:0] cnt;
    reg [2:0] scan_cnt;
    reg [3:0] show_single;
    
    parameter period = 20000;
    
    always @(posedge clk, negedge rstn)
    begin
        if(!rstn)
        begin
            cnt<=0;
            clkout <=0;
        end
        else 
        begin
            if(cnt==(period>>1-1))
            begin
                cnt<=0;
                clkout<=~clkout;
            end
            else
            begin
                cnt <= cnt+1;
            end
        end
    end
    
    always @(posedge clkout, negedge rstn)
    begin
        if(!rstn)
        begin
            scan_cnt<=0;
        end
        else
        begin
            if(scan_cnt==3'd7)
            begin
                scan_cnt<=0;
            end
            else
            begin
                scan_cnt<=scan_cnt+1;
            end    
        end
    end
    
    always @(scan_cnt)
    begin
        case(scan_cnt)
            3'd0:begin seg_en=8'h01;show_single=show[3:0]; end
            3'd1:begin seg_en=8'h02;show_single=show[7:4]; end
            3'd2:begin seg_en=8'h04;show_single=show[11:8]; end
            3'd3:begin seg_en=8'h08;show_single=show[15:12]; end
            3'd4:begin seg_en=8'h10;show_single=show[19:16]; end
            3'd5:begin seg_en=8'h20;show_single=show[23:20]; end
            3'd6:begin seg_en=8'h40;show_single=show[27:24]; end
            3'd7:begin seg_en=8'h80;show_single=show[31:28]; end
            default: begin seg_en=8'h00;show_single=4'b0000; end
        endcase
    end
    
    light_7seg_ego1 ul(.sw(show_single),.seg_out(seg_out_left));
    light_7seg_ego1 ur(.sw(show_single),.seg_out(seg_out_right));
    
endmodule
