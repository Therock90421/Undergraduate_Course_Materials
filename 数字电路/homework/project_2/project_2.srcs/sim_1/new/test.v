`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/09/25 10:39:00
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
reg clk;
reg rst;

reg[3:0] a;
reg[3:0] b;
wire [3:0] out;
wire cout;
reg cin;

initial begin 
   a=10;
   b=10;
   cin=0;
   clk=0;
end

always #10 clk=~clk;

addform add(
  .a(a),
  .b(b),
  .cin(cin),
  .cout(cout),
  .out(out)
    );
endmodule
