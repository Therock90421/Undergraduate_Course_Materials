`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/25 10:32:22
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


module test( );
reg clk;
reg rst;
reg [15:0] a;
reg [15:0] b;
wire [15:0] out;
wire cout;
reg cin;



 initial begin
   a=0;
   b=0;
   cin = 0;
   clk = 0;
   
end
always #10
begin
clk=~clk;
  if (clk<1000)
   begin
   a={$random}%10000;
   b={$random}%10000;
   end
   else
   begin
   a={$random}%10000+10000;
   b={$random}%10000+10000;
   end
   end
add_16 add(
      .A(a),
      .B(b),
      .CI(cin),
      .S(out),
      .CO(cout)
      );
      
 
endmodule
