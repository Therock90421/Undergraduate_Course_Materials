`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/09 01:46:27
// Design Name: 
// Module Name: add8
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



module adder(
    input [7:0] operand0,
    input [7:0] operand1,
    output [7:0] result
    );

	/*TODO: Add your logic code here*/
    assign result =operand0 + operand1;

endmodule

