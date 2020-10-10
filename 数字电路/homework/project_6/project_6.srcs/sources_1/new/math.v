`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/22 11:38:41
// Design Name: 
// Module Name: math
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


module math(a,b,choose,d);
input [7:0]a;
input [7:0]b;
input [2:0]choose;
output reg [8:0]d;
always@(choose)
begin
 case(choose)
 
  3'b000: d<=a+b;
  3'b001: d<=a-b;
  3'b010: d<=a&b;
  3'b011: d<=a|b;
  3'b100: d<=~a;
  3'b101: d<=(b+a)/2;
  default: d<=0;
  endcase
  end
  
  

    
endmodule
