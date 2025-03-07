`timescale 1ns / 1ps


module player(
    input clk,
    input rstn,
    input play,
    output reg beep,
    output loud
    );
    parameter M_6=16'd37936; // A in music
    reg [15:0] beat=0;
    assign loud=1'b1;
    always @(posedge clk or negedge rstn)
    begin
        if (!rstn)
        begin
            beat <= 32'b0;
            beep <= 1'b0;
        end
        else if (play)
        begin
            beat<=beat+1'b1;
            if(beat==M_6) 
            begin
                beat<=32'b0;
                beep<=~beep;
            end
        end
        else
        begin
            beep <= 1'b0;
        end
    end
endmodule
