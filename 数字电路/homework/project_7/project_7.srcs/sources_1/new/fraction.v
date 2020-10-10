`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/27 10:10:29
// Design Name: 
// Module Name: fraction
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


module fraction(clk_out, clk,reset);
input clk,reset;
output clk_out;
reg clk_out;
reg [1:0]cout;
always@(posedge clk or negedge reset)
if(!reset)
begin 
 cout<=2'b00;
 clk_out<=1'b0;
 end
else if(cout==2'b11)
begin
 cout<=2'b00;
 clk_out<=~clk_out;
 end
else cout<=cout+1'b1;

endmodule
