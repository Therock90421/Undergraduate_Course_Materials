`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/09 15:12:04
// Design Name: 
// Module Name: DMA
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


module DMA
	( 	
		input direction, clk, rst_n, 
		input mem_to_dma_valid, mem_to_dma_enable, 
		input cpu_to_dma_valid, cpu_to_dma_enable,
		input		[3:0] 	mem_data_out,
		input 		[7:0]	cpu_data_out,
		output	reg	[3:0]	mem_data_in,
		output	reg	[7:0]	cpu_data_in 
	);
	
	reg	[63:0]	BUF1, BUF2; 
	reg [4:0]	count_buf1, count_buf2; 		//计数两个缓冲区传递数据的次数，并以此来判断是否为空或满
	reg 		dma_to_mem_valid, dma_to_mem_enable;
	reg			dma_to_cpu_valid, dma_to_cpu_enable;
	reg			state; 							//当state等于1时，表示BUF1读入数据，反之则为BUF2读入数据
	reg [4:0]	max_data_transfer_buf1, max_data_transfer_buf2;
												//由于交换BUF1和BUF2后，传输次数发生变化，故新设这两个变量

	parameter Number_of_Data_Transfer_MEM = 16;
	parameter Number_of_Data_Transfer_CPU = 8;
	parameter MEM_TO_CPU = 1;					//当direction等于1时，表示从内存向CPU传输数据
	parameter CPU_TO_MEM = 0;					//当direction等于0时，表示从CPU向内存传输数据
	parameter INPUT_BUF1_AND_OUTPUT_BUF2 = 1;
	parameter INPUT_BUF2_AND_OUTPUT_BUF1 = 0;
	
	always@(posedge clk)						//进行初始化，以及计数
	begin
		if(!rst_n)
		begin
			BUF1 <= 64'b0;
			BUF2 <= 64'b0;
			state <= INPUT_BUF1_AND_OUTPUT_BUF2;
			count_buf1 <= 5'b0;
			count_buf2 <= 5'b0;
			dma_to_mem_enable <= 0;
			dma_to_mem_valid <= 0;
			dma_to_cpu_enable <= 0;
			dma_to_cpu_valid <= 0;
		end
		else
		begin
			if(count_buf1 < max_data_transfer_buf1 && count_buf2 == max_data_transfer_buf2)
			begin
				count_buf1 <= count_buf1 + 5'b1;	
				dma_to_cpu_valid <= 0;
				dma_to_cpu_enable <= 0;				
			end
			else if(count_buf1 == max_data_transfer_buf1 && count_buf2 < max_data_transfer_buf2)
			begin
				count_buf2 <= count_buf2 + 5'b1;
				dma_to_cpu_valid <= 0;
				dma_to_cpu_enable <= 0;
			end
			else if(count_buf1 < max_data_transfer_buf1 && count_buf2 < max_data_transfer_buf2)
			begin
				count_buf1 <= count_buf1 + 5'b1;				
				count_buf2 <= count_buf2 + 5'b1;
				dma_to_cpu_valid <= 0;
				dma_to_cpu_enable <= 0;
			end
			else								//控制的部分放在了下一个always块里面
			begin
				dma_to_cpu_valid <= 1;
				dma_to_cpu_enable <= 1;
				count_buf1 <= 5'b0;
				count_buf2 <= 5'b0;
				state <= ~state;				
			end
		end
	end
	
	always@(posedge clk)						//对读入的数据进行控制，以及对两个BUF的输入输出关系进行调整
	begin
		if(!rst_n)
		begin

		end
		else
		begin
			if(direction == MEM_TO_CPU)			//从内存向CPU
			begin
				max_data_transfer_buf1 <= (state) ? Number_of_Data_Transfer_MEM 
												  : Number_of_Data_Transfer_CPU;
				max_data_transfer_buf2 <= (state) ? Number_of_Data_Transfer_CPU 
												  : Number_of_Data_Transfer_MEM;												  
			end
			else if(direction == CPU_TO_MEM)	//从CPU向内存
			begin
				max_data_transfer_buf1 <= (state) ? Number_of_Data_Transfer_CPU 
												  : Number_of_Data_Transfer_MEM;
				max_data_transfer_buf2 <= (state) ? Number_of_Data_Transfer_MEM 
												  : Number_of_Data_Transfer_CPU;												  
			end
		end
	end
	
	always@(posedge clk)						//读入并输出数据
	begin
		if(!rst_n)
		begin

		end
		else
		begin
			if(direction == MEM_TO_CPU)
			begin
				if(mem_to_dma_valid && mem_to_dma_enable)
				begin
					if(state == INPUT_BUF1_AND_OUTPUT_BUF2)
					begin
						BUF1 <= {BUF1[59:0], 4'b0};
						BUF1[3:0] <= mem_data_out;
						
						cpu_data_in <= BUF2[63:56];
						BUF2 <= {BUF2[55:0], 8'b0};												
					end
					else if(state == INPUT_BUF2_AND_OUTPUT_BUF1)
					begin
						BUF2 <= {BUF2[59:0], 4'b0};
						BUF2[3:0] <= mem_data_out;
						
						cpu_data_in <= BUF1[63:56];
						BUF1 <= {BUF1[55:0], 8'b0};						
					end
				end
			end
			else if(direction == CPU_TO_MEM)
			begin
				if(cpu_to_dma_valid && cpu_to_dma_enable)
				begin
					if(state == INPUT_BUF1_AND_OUTPUT_BUF2)
					begin
						BUF1 <= {BUF1[55:0], 8'b0};
						BUF1[7:0] <= cpu_data_out;
						
						mem_data_in <= BUF2[63:60];
						BUF2 <= {BUF2[59:0], 4'b0};						
					end
					else if(state == INPUT_BUF2_AND_OUTPUT_BUF1)
					begin
						BUF2 <= {BUF2[55:0], 8'b0};
						BUF2[7:0] <= cpu_data_out;
						
						mem_data_in <= BUF1[63:60];
						BUF1 <= {BUF1[59:0], 4'b0};						
					end
				end
			end
		end
	end		
		
endmodule
