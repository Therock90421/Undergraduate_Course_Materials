`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/15 10:38:31
// Design Name: 
// Module Name: machine
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





module three_eight(A,clk,Y0,Y1,Y2,Y3,Y4,Y5,Y6,Y7);
input [2:0]A;
input clk;
output Y0,Y1,Y2,Y3,Y4,Y5,Y6,Y7;
reg y0,y1,y2,y3,y4,y5,y6,y7;
assign Y0=y0;
assign Y1=y1;
assign Y2=y2;
assign Y3=y3;
assign Y4=y4;
assign Y5=y5;
assign Y6=y6;
assign Y7=y7;
always@(posedge clk)begin
if(A==2'b000)     begin y0=1;y1=0;y2=0;y3=0;y4=0;y5=0;y6=0;y7=0;end
else if(A==2'b001)     begin y0=0;y1=1;y2=0;y3=0;y4=0;y5=0;y6=0;y7=0;end
else if(A==2'b010)     begin y0=0;y1=0;y2=1;y3=0;y4=0;y5=0;y6=0;y7=0;end
else if(A==2'b011)     begin y0=0;y1=0;y2=0;y3=1;y4=0;y5=0;y6=0;y7=0;end
else if(A==2'b100)     begin y0=0;y1=0;y2=0;y3=0;y4=1;y5=0;y6=0;y7=0;end
else if(A==2'b101)     begin y0=0;y1=0;y2=0;y3=0;y4=0;y5=1;y6=0;y7=0;end
else if(A==2'b110)     begin y0=0;y1=0;y2=0;y3=0;y4=0;y5=0;y6=1;y7=0;end
else if(A==2'b111)     begin y0=0;y1=0;y2=0;y3=0;y4=0;y5=0;y6=0;y7=1;end
end

endmodule

