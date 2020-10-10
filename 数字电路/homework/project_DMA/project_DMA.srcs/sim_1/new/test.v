`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/09 17:14:07
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
	reg direction, clk, rst_n; 
	reg mem_to_dma_valid, mem_to_dma_enable;
	reg cpu_to_dma_valid, cpu_to_dma_enable;
	reg		[3:0] 	mem_data_out;
	reg 	[7:0]	cpu_data_out;
	wire	[3:0]	mem_data_in;
	wire	[7:0]	cpu_data_in;

	initial
	begin
		clk = 0;
		rst_n = 0;
		direction = 1;
		#50 rst_n = 1;
	end

	always #1 clk = ~clk;
	
	always@(posedge clk)
	begin
		mem_to_dma_valid = {$random} % 2;
		mem_to_dma_enable = {$random} % 2;
		cpu_to_dma_valid = {$random} % 2;
		cpu_to_dma_enable = {$random} % 2;
		
		mem_data_out  = {$random} % 16;
		cpu_data_out = {$random} % 256;
	end

	DMA ourDMA
	( 	
		.direction(direction), 
		.clk(clk), 
		.rst_n(rst_n), 
		.mem_to_dma_valid(mem_to_dma_valid), 
		.mem_to_dma_enable(mem_to_dma_enable), 
		.cpu_to_dma_valid(cpu_to_dma_valid), 
		.cpu_to_dma_enable(cpu_to_dma_enable),
		.mem_data_out(mem_data_out),
		.cpu_data_out(cpu_data_out),
		.mem_data_in(mem_data_in),
		.cpu_data_in(cpu_data_in)	
	);

endmodule
