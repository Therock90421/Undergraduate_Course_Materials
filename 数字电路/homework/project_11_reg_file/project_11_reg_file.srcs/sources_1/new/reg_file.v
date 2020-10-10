
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/15 14:33:39
// Design Name: 
// Module Name: reg_file
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
`define ADDR_WIDTH 5

module reg_file(
	input clk,
	input rst,
	input [`ADDR_WIDTH - 1:0] waddr,      //写在几号寄存器
	input [`ADDR_WIDTH - 1:0] raddr1,     //读几号寄存器
	input [`ADDR_WIDTH - 1:0] raddr2,
	input wen,
	input [`DATA_WIDTH - 1:0] wdata,     //写入的数据是什么
	output [`DATA_WIDTH - 1:0] rdata1,   //读的数据是什么
	output [`DATA_WIDTH - 1:0] rdata2
);
    reg [31:0] r[31:0];
    
    always@(posedge clk)begin
    if(rst==0)
    r[0]<=0;
    if(wen == 1)begin
    r[waddr]<= wdata;
    r[0]<=32'b0;
    end
    end
    assign rdata1 = r[raddr1];
    assign rdata2 = r[raddr2];
	

endmodule