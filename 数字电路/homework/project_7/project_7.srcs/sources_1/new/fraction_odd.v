`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/27 10:35:25
// Design Name: 
// Module Name: fraction_odd
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


module fraction_odd(clk_out,clk,reset);
input clk,reset;
output clk_out;
wire clk_out;


reg [2:0]cout_1;
reg clk_1;
reg [2:0]cout_2;
reg clk_2;
always @ (posedge clk or negedge reset) 
if(!reset) 
    cout_1 <= 3'd0;
else if(cout_1 == 3'd4)
    cout_1 <= 3'd0;
else 
    cout_1 <= cout_1 + 1'b1;

always @ (posedge clk or negedge reset) 
if(!reset)     
    clk_1 <= 1'b0;
else if((cout_1 == 3'd2) || (cout_1 == 3'd4))
    clk_1 <= ~ clk_1;
    

    always @ (negedge clk or negedge reset) 
    if(!reset) 
        cout_2 <= 3'd0;
    else if(cout_2 == 3'd4)
        cout_2 <= 3'd0;
    else 
        cout_2 <= cout_2 + 1'b1;
    
    always @ (negedge clk or negedge reset) 
    if(!reset)     
        clk_2 <= 1'b0;
    else if((cout_2 == 3'd2) || (cout_2 == 3'd4))
        clk_2 <= ~ clk_2;
    
 assign clk_out = clk_1|clk_2;
endmodule
