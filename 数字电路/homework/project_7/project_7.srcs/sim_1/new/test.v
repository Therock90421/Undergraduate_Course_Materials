`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/27 10:17:53
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


module test();
reg clk,reset;
wire clk_out;
initial begin
clk = 0;
reset = 1;
#10 reset = 0;
#10 reset = 1;
end
always #10 clk=~clk;
fraction_odd B(
          .clk_out(clk_out),
          .clk(clk),
          .reset(reset));
endmodule
