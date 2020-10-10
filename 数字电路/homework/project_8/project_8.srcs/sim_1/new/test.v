`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/04 11:30:54
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


module test ();
reg clk,reset;
reg input_valid,output_enable;
reg [3:0]Data_in;
wire output_valid,input_enable;
wire [7:0] Data_out_0,Data_out_1,Data_out_2,Data_out_3,Data_out_4,Data_out_5,Data_out_6,Data_out_7;
initial begin
clk = 0;
reset = 0;
input_valid= 0;
output_enable= 0;
Data_in=0;
#20 reset = 1;
end
always #10 
begin 
clk=~clk;
input_valid=1;
output_enable=1;
Data_in={$random}%16;
end
FIFO A(.clk(clk),
        .reset(reset),
        .input_valid(input_valid),
        .input_enable(input_enable),
        .output_valid(output_valid),
        .output_enable(output_enable),
        .Data_in(Data_in),
        .Data_out_0(Data_out_0),
        .Data_out_1(Data_out_1),
        .Data_out_2(Data_out_2),
        .Data_out_3(Data_out_3),
        .Data_out_4(Data_out_4),
        .Data_out_5(Data_out_5),
        .Data_out_6(Data_out_6),
        .Data_out_7(Data_out_7)
        );

endmodule
