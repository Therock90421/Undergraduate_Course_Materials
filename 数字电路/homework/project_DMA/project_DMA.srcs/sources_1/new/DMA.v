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
	reg			state; 							//该变量表示两个缓冲区的输入输出关系：当state等于1时，表示BUF1读入数据，反之则为BUF2读入数据
	reg [4:0]	max_data_transfer_buf1, max_data_transfer_buf2;
												//由于交换BUF1和BUF2后，传输次数发生变化，故新设这两个变量

	parameter Number_of_Data_Transfer_MEM = 16;
	parameter Number_of_Data_Transfer_CPU = 8;
	parameter MEM_TO_CPU = 1;					//当direction等于1时，表示从内存向CPU传输数据
	parameter CPU_TO_MEM = 0;					//当direction等于0时，表示从CPU向内存传输数据
	parameter INPUT_BUF1_AND_OUTPUT_BUF2 = 1;
	parameter INPUT_BUF2_AND_OUTPUT_BUF1 = 0;
	
	always@(posedge clk)						//进行初始化
	begin
		if(!rst_n)
		begin
			BUF1 <= 64'b0;
			BUF2 <= 64'b0;
			state <= INPUT_BUF1_AND_OUTPUT_BUF2;		
			
			count_buf1 <= 5'b0;
			count_buf2 <= (direction) ? Number_of_Data_Transfer_CPU 
									  : Number_of_Data_Transfer_MEM;
			//这样可以防止一开始两个buf都为空的时候count-buf2开始计数，同时也可以直接在控制DMA出口的always块里面初始化两个DMA开关
		end
		else
		begin
			
		end
	end
	
	always@(posedge clk)						//对DMA的两个开关进行控制，以及对两个BUF的输入输出关系进行调整
	begin
		if(!rst_n)
		begin

		end
		else
		begin
			if(direction == MEM_TO_CPU)			//从内存向CPU
			begin
				max_data_transfer_buf1 <= (state) ? Number_of_Data_Transfer_MEM 	//由于两个缓冲区转换状态之后，存储的数据位宽也发生变化，因此需要这样来调整最大的输出次数
												  : Number_of_Data_Transfer_CPU;
				max_data_transfer_buf2 <= (state) ? Number_of_Data_Transfer_CPU 
												  : Number_of_Data_Transfer_MEM;	
				if(state == INPUT_BUF1_AND_OUTPUT_BUF2)
				begin
					if(count_buf2 < max_data_transfer_buf2)			//当BUF2未空时，开关打开，继续输出
					begin
						dma_to_cpu_valid <= 1;
						dma_to_cpu_enable <= 1;
					end
					else											//当BUF2已空时，开关关闭，停止输出
					begin
						dma_to_cpu_valid <= 0;
						dma_to_cpu_enable <= 0;
						if(count_buf1 == max_data_transfer_buf1)	//如果此时BUF1已满，将会交换输入输出的关系，同时打开开关以便输出
						begin
							dma_to_cpu_valid <= 1;
							dma_to_cpu_enable <= 1;
							count_buf1 <= 5'b0;
							count_buf2 <= 5'b0;
							state <= ~state;							
						end
					end
				end
				else if(state == INPUT_BUF2_AND_OUTPUT_BUF1)
				begin
					if(count_buf1 < max_data_transfer_buf1)
					begin
						dma_to_cpu_valid <= 1;
						dma_to_cpu_enable <= 1;
					end
					else
					begin
						dma_to_cpu_valid <= 0;
						dma_to_cpu_enable <= 0;
						if(count_buf2 == max_data_transfer_buf2)
						begin
							dma_to_cpu_valid <= 1;
							dma_to_cpu_enable <= 1;
							count_buf1 <= 5'b0;
							count_buf2 <= 5'b0;
							state <= ~state;							
						end
					end
				end	
			end	
			else if(direction == CPU_TO_MEM)	//从CPU向内存
			begin
				max_data_transfer_buf1 <= (state) ? Number_of_Data_Transfer_CPU 
												  : Number_of_Data_Transfer_MEM;
				max_data_transfer_buf2 <= (state) ? Number_of_Data_Transfer_MEM 
												  : Number_of_Data_Transfer_CPU;
				if(state == INPUT_BUF1_AND_OUTPUT_BUF2)
				begin
					if(count_buf2 < max_data_transfer_buf2)
					begin
						dma_to_mem_valid <= 1;
						dma_to_mem_enable <= 1;
					end
					else
					begin
						dma_to_mem_valid <= 0;
						dma_to_mem_enable <= 0;
						if(count_buf1 == max_data_transfer_buf1)
						begin
							dma_to_mem_valid <= 1;
							dma_to_mem_enable <= 1;
							count_buf1 <= 5'b0;
							count_buf2 <= 5'b0;
							state <= ~state;
						end						
					end
				end
				else if(state == INPUT_BUF2_AND_OUTPUT_BUF1)
				begin
					if(count_buf1 < max_data_transfer_buf1)
					begin
						dma_to_mem_valid <= 1;
						dma_to_mem_enable <= 1;
					end
					else
					begin
						dma_to_mem_valid <= 0;
						dma_to_mem_enable <= 0;
						if(count_buf2 == max_data_transfer_buf2)
						begin
							dma_to_mem_valid <= 1;
							dma_to_mem_enable <= 1;
							count_buf1 <= 5'b0;
							count_buf2 <= 5'b0;
							state <= ~state;
						end						
					end
				end
			end
		end
	end
	
	always@(posedge clk)						//读入数据并计数
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
					if(state == INPUT_BUF1_AND_OUTPUT_BUF2 && count_buf1 < max_data_transfer_buf1)	//count_buf1为输入端，且count_buf1未满时，允许读入
					begin
						BUF1 <= {BUF1[59:0], 4'b0};
						BUF1[3:0] <= mem_data_out;	
						count_buf1 <= count_buf1 + 5'b1;
					end
					else if(state == INPUT_BUF2_AND_OUTPUT_BUF1 && count_buf2 < max_data_transfer_buf2)
					begin
						BUF2 <= {BUF2[59:0], 4'b0};
						BUF2[3:0] <= mem_data_out;	
						count_buf2 <= count_buf2 + 5'b1;						
					end
				end
			end
			else if(direction == CPU_TO_MEM)
			begin
				if(cpu_to_dma_valid && cpu_to_dma_enable)
				begin
					if(state == INPUT_BUF1_AND_OUTPUT_BUF2 && count_buf1 < max_data_transfer_buf1)
					begin
						BUF1 <= {BUF1[55:0], 8'b0};
						BUF1[7:0] <= cpu_data_out;		
						count_buf1 <= count_buf1 + 5'b1;						
					end
					else if(state == INPUT_BUF2_AND_OUTPUT_BUF1 && count_buf2 < max_data_transfer_buf2)
					begin
						BUF2 <= {BUF2[55:0], 8'b0};
						BUF2[7:0] <= cpu_data_out;	
						count_buf2 <= count_buf2 + 5'b1;						
					end
				end
			end
		end
	end		
		
	always@(posedge clk)				//输出数据并计数
	begin
		if(!rst_n)
		begin

		end
		else
		begin
			if(direction == MEM_TO_CPU)
			begin
				if(dma_to_cpu_valid && dma_to_cpu_enable)
				begin
					if(state == INPUT_BUF1_AND_OUTPUT_BUF2 && count_buf2 < max_data_transfer_buf2)	//count_buf2为输出端，且count_buf2未空时，允许输出
					begin																			//但感觉可能与前面的开关的关系有所重复，但为了对称性与美观...（强迫症）
						cpu_data_in <= BUF2[63:56];
						BUF2 <= {BUF2[55:0], 8'b0};
						count_buf2 <= count_buf2 + 5'b1;						
					end
					else if(state == INPUT_BUF2_AND_OUTPUT_BUF1 && count_buf1 < max_data_transfer_buf1)
					begin
						cpu_data_in <= BUF1[63:56];
						BUF1 <= {BUF1[55:0], 8'b0};
						count_buf1 <= count_buf1 + 5'b1;
					end
				end
			end
			else if(direction == CPU_TO_MEM)
			begin
				if(dma_to_mem_valid && dma_to_mem_enable)
				begin
					if(state == INPUT_BUF1_AND_OUTPUT_BUF2  && count_buf2 < max_data_transfer_buf2)
					begin
						mem_data_in <= BUF2[63:60];
						BUF2 <= {BUF2[59:0], 4'b0};
						count_buf2 <= count_buf2 + 5'b1;						
					end
					else if(state == INPUT_BUF2_AND_OUTPUT_BUF1 && count_buf1 < max_data_transfer_buf1)
					begin
						mem_data_in <= BUF1[63:60];
						BUF1 <= {BUF1[59:0], 4'b0};
						count_buf1 <= count_buf1 + 5'b1;
					end
				end
			end
		end
	end		
endmodule
