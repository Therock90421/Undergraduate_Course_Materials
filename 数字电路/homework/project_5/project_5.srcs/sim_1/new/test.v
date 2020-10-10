`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/22 10:25:06
// Design Name: 
// Module Name: test
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

module counter_6_tb();
    reg RST;
    reg CLK;
    wire [2:0] CNT;
   
    initial
    begin
        CLK=1'b0;
        RST=1'b1;
        #4 RST=1'b0;
    end
    always #10 CLK<=~CLK;
     counter_6 counter(
    .CLK(CLK),
    .RST(RST),
    .CNT(CNT));
endmodule

