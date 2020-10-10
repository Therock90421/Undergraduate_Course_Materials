`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/13 11:05:50
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
reg A;
reg B;
reg reset;
wire Y;
wire W;
reg [3:0]C;

initial begin
   A=0;
   B=1;
   C=0;
   clk=0;
   reset=1;
   end
 always #10  
 begin
 clk=~clk;
 if(C==9)
 begin
 reset=1;
 C=1;
 end
 else 
 begin
 C=C+1;
 reset=0;
 end
 if({A,B}==0) begin A=0;B=1;end
 if({A,B}==1) begin A=1;B=0; end
 if({A,B}==2) begin A=1;B=1; end
 if({A,B}==3) begin A=0;B=0; end
 
 end
state_machine H(
              .A(A),
              .B(B),
              .clk(clk),
              .reset(reset),
              .Y(Y),
              .W(W)
              );
    
endmodule
