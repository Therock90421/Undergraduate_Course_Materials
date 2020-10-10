`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/22 11:45:16
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
reg [2:0]choose;
reg [7:0]a,b;
wire [8:0]d;
math c(.a(a),
       .b(b),
       .choose(choose),
       .d(d));
 initial begin
   a<=8'b00000111;
   b<=8'b00000001;
   choose<=3'b000;
   #10 choose<=3'b001;
   #10 choose<=3'b010;
   #10 choose<=3'b011;
   #10 choose<=3'b100;
   #10 choose<=3'b101;
   end 
endmodule
