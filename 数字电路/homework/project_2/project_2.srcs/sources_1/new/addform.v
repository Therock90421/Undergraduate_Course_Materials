`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/09/25 10:25:14
// Design Name: 
// Module Name: addform
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


module addform(a,b,cin,out,cout);
  input[3:0]a;
  input[3:0]b;
  input cin;
  output [3:0] out;
  output cout;
  
  assign{cout,out}=a+b+cin;
  


endmodule
