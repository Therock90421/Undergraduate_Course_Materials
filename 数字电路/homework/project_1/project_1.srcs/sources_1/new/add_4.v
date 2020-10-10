`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/25 10:10:36
// Design Name: 
// Module Name: add_4
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
module add_1(A,B,CI,Sum,CO);
input A,B,CI;
output Sum,CO;
wire s_1,s_2,s_3,s_4   ;
xor 
XOR1(s_1,A,B),
XOR2(Sum,CI,s_1);
and
AND1(s_2,A,B),
AND2(s_3,B,CI),
AND3(s_4,A,CI);
or
OR(CO,s_2,s_3,s_4);
endmodule


module add_4(A,B,CI,S,CO);
input[3:0]A,B;
output[3:0]S;
input CI;
output CO;
wire [0:2]Ci;
add_1
add1(A[0],B[0],CI,S[0],Ci[0]),
add2(A[1],B[1],Ci[0],S[1],Ci[1]),
add3(A[2],B[2],Ci[1],S[2],Ci[2]),
add4(A[3],B[3],Ci[2],S[3],CO);
    
endmodule

module add_16(A,B,CI,S,CO);
input[15:0]A,B;
output[15:0]S;
input CI;
output CO;
wire [0:2]Ci;
add_4
Add1(A[3:0],B[3:0],CI,S[3:0],Ci[0]),
Add2(A[7:4],B[7:4],Ci[0],S[7:4],Ci[1]),
Add3(A[11:8],B[11:8],Ci[1],S[11:8],Ci[2]),
Add4(A[15:12],B[15:12],Ci[2],S[15:12],CO);
endmodule