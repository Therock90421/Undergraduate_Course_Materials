
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/21 19:19:16
// Design Name: 
// Module Name: ALU
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

`timescale 10 ns / 1 ns

`define DATA_WIDTH 32

module alu(
	input [`DATA_WIDTH - 1:0] A,
	input [`DATA_WIDTH - 1:0] B,
	input [2:0] ALUop,
	output Overflow,
	output CarryOut,
	output Zero,
	output TEMP,
	output [`DATA_WIDTH - 1:0] Result
	
);
   wire [31:0] registerAND;
   wire [31:0]registerOR;
   wire [31:0]registerXOR;

   wire [32:0]BvertSIGNED;
   wire [32:0]BvertUNSIGNED;
   wire [32:0] calculate,calculate1;
   wire [32:0] BnumberSIGNED,BnumberUNSIGNED;
   wire [31:0]registerRIGHT;
   wire [63:0]temp;
   assign registerAND = A&B;
  
   assign registerOR = A|B;
   assign registerXOR = A^B;
   
   assign BvertSIGNED = ~{B[31],B}+33'd1;
   assign BvertUNSIGNED = ~{1'b0,B}+33'd1;
   assign BnumberSIGNED = (ALUop==3'b010)?{B[31],B}:BvertSIGNED;
   assign BnumberUNSIGNED = (ALUop==3'b010)?{1'b0,B}:BvertUNSIGNED;
   //assign result = (ALUop==3'b010)?{{A[31],A}+{B[31],B}}[31:0]:(ALUop==3'b110)?{{A[31],A}+BvertSIGNED}[31:0]:(ALUop==3'b111)?{{A[31],A}+BvertSIGNED}[31]^Overflow2:0;
   assign temp = {32'hffffffff,A}>>B;
   assign registerRIGHT = (A[31]==1)?temp[31:0]:A>>B;
   
   assign calculate = {A[31],A}+BnumberSIGNED;
   assign calculate1 = {1'b0,A}+BnumberUNSIGNED;
   assign Overflow = calculate[32]^calculate[31];
   assign CarryOut = calculate1[32];
   
  /* assign registerADD ={A[31],A}+{B[31],B} ;
   assign Overflow1 = registerADD[32]^registerADD[31];
   assign registerADD1={1'b0,A}+{1'b0,B};
   assign CarryOut1 = registerADD1[32];
   
   
   assign registerSUB = {A[31],A}+BvertSIGNED;
   assign Overflow2 = registerSUB[32]^registerSUB[31];
   assign registerSUB1 = {1'b0,A}+BvertUNSIGNED;
   assign CarryOut2 = registerSUB1[32];*/
   

   assign Result = (ALUop==3'b011)?registerXOR:(ALUop==3'b000)? registerAND:(ALUop==3'b001)? registerOR:(ALUop==3'b010)?calculate[31:0]:(ALUop==3'b110)?calculate[31:0]:(ALUop==3'b111)?calculate[31]^Overflow:(ALUop == 3'b100)?registerRIGHT:
   (ALUop==3'b101)?CarryOut:0;
  // assign carryOut = (ALUop==3'b010)?CarryOut1:(ALUop==3'b110)?CarryOut2:0;
  // assign overflow = (ALUop==3'b010)?Overflow1:(ALUop==3'b110||ALUop==3'b111)?Overflow2:0;
   assign Zero = !Result;
    

   //assign CarryOut = carryOut;
  // assign Overflow = overflow;

  
endmodule