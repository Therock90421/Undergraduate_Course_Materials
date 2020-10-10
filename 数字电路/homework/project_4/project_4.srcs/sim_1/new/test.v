`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/15 10:56:12
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
wire Y0,Y1,Y2,Y3,Y4,Y5,Y6,Y7;
reg [2:0]A;
initial begin
A=2'b000;
clk=0;
end
always #10
begin
clk=~clk;
A={$random}% 8;
end
three_eight AHA(
             .A(A),
             .clk(clk),
             .Y0(Y0),
             .Y1(Y1),
             .Y2(Y2),
             .Y3(Y3),
             .Y4(Y4),
             .Y5(Y5),
             .Y6(Y6),
             .Y7(Y7)
             );

   
endmodule
