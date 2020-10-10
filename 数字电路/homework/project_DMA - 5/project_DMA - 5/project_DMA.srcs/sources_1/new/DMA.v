`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UCAS-Digital Circuits-02
// Engineer: Xu Yibin, Li Haochen, Yan Yue
// 
// Create Date: 2018/12/09 15:12:04
// Design Name: 
// Module Name: DMA
// Project Name: DMA
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
	
	//dma_to_mem_enable：控制内存到DMA的输入过程的内置信号（方向为内存-CPU），dma_to_cpu_valid：控制DMA到CPU的输出过程的内置信号（方向为内存-CPU）
	//dma_to_cpu_enable：控制CPU到DMA的输入过程的内置信号（方向为CPU-内存），dma_to_mem_valid：控制DMA到内存的输出过程的内置信号（方向为CPU-内存）
	
	always@(posedge clk)						//进行初始化
	begin
		if(!rst_n)
		begin
			BUF1 <= 64'b0;
			BUF2 <= 64'b0;
			state <= INPUT_BUF1_AND_OUTPUT_BUF2;		
			
			dma_to_mem_enable <= (direction) ? 1 : 0;	//根据direction的取值，直接关闭另外一个方向的传输
			dma_to_cpu_enable <= (direction) ? 0 : 1;
			
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
					if(count_buf1 < max_data_transfer_buf1 && count_buf2 < max_data_transfer_buf2)			//当BUF1未满且BUF2未空时，两个开关都打开，继续输入与输出
					begin
						dma_to_mem_enable <= 1;		
						dma_to_cpu_valid <= 1;
					end
					else if(count_buf1 < max_data_transfer_buf1 && count_buf2 == max_data_transfer_buf2)	//当BUF2已空时，输出开关关闭，停止输出
					begin
						dma_to_mem_enable <= 1;		
						dma_to_cpu_valid <= 0;						
					end
					else if(count_buf1 == max_data_transfer_buf1 && count_buf2 < max_data_transfer_buf2)	//当BUF1已满时，输入开关关闭，停止输入
					begin
						dma_to_mem_enable <= 0;		
						dma_to_cpu_valid <= 1;					
					end
					else if(count_buf1 == max_data_transfer_buf1 && count_buf2 == max_data_transfer_buf2)	//当BUF1已满且BUF2已空时，交换两者的状态，并将两个开关都打开，继续输入与输出				
					begin
						dma_to_mem_enable <= 1;		
						dma_to_cpu_valid <= 1;
						count_buf1 <= 5'b0;
						count_buf2 <= 5'b0;
						state <= ~state;							
					end
				end
				else if(state == INPUT_BUF2_AND_OUTPUT_BUF1)
				begin
					if(count_buf1 < max_data_transfer_buf1 && count_buf2 < max_data_transfer_buf2)			//当BUF1未空且BUF2未满时，两个开关都打开，继续输入与输出
					begin
						dma_to_mem_enable <= 1;		
						dma_to_cpu_valid <= 1;
					end
					else if(count_buf1 < max_data_transfer_buf1 && count_buf2 == max_data_transfer_buf2)	//当BUF2已满时，输入开关关闭，停止输入
					begin
						dma_to_mem_enable <= 0;		
						dma_to_cpu_valid <= 1;						
					end
					else if(count_buf1 == max_data_transfer_buf1 && count_buf2 < max_data_transfer_buf2)	//当BUF1已空时，输出开关关闭，停止输出
					begin
						dma_to_mem_enable <= 1;		
						dma_to_cpu_valid <= 0;					
					end
					else if(count_buf1 == max_data_transfer_buf1 && count_buf2 == max_data_transfer_buf2)	//当BUF1已空且BUF2已满时，交换两者的状态，并将两个开关都打开，继续输入与输出				
					begin
						dma_to_mem_enable <= 1;		
						dma_to_cpu_valid <= 1;
						count_buf1 <= 5'b0;
						count_buf2 <= 5'b0;
						state <= ~state;							
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
					if(count_buf1 < max_data_transfer_buf1 && count_buf2 < max_data_transfer_buf2)			//当BUF1未满且BUF2未空时，两个开关都打开，继续输入与输出
					begin
						dma_to_cpu_enable <= 1;		
						dma_to_mem_valid <= 1;
					end
					else if(count_buf1 < max_data_transfer_buf1 && count_buf2 == max_data_transfer_buf2)	//当BUF2已空时，输出开关关闭，停止输出
					begin
						dma_to_cpu_enable <= 1;		
						dma_to_mem_valid <= 0;					
					end
					else if(count_buf1 == max_data_transfer_buf1 && count_buf2 < max_data_transfer_buf2)	//当BUF1已满时，输入开关关闭，停止输入
					begin
						dma_to_cpu_enable <= 0;		
						dma_to_mem_valid <= 1;				
					end
					else if(count_buf1 == max_data_transfer_buf1 && count_buf2 == max_data_transfer_buf2)	//当BUF1已满且BUF2已空时，交换两者的状态，并将两个开关都打开，继续输入与输出				
					begin
						dma_to_cpu_enable <= 1;		
						dma_to_mem_valid <= 1;
						count_buf1 <= 5'b0;
						count_buf2 <= 5'b0;
						state <= ~state;							
					end
				end
				else if(state == INPUT_BUF2_AND_OUTPUT_BUF1)
				begin
					if(count_buf1 < max_data_transfer_buf1 && count_buf2 < max_data_transfer_buf2)			//当BUF1未空且BUF2未满时，两个开关都打开，继续输入与输出
					begin
						dma_to_cpu_enable <= 1;		
						dma_to_mem_valid <= 1;
					end
					else if(count_buf1 < max_data_transfer_buf1 && count_buf2 == max_data_transfer_buf2)	//当BUF2已满时，输入开关关闭，停止输入
					begin
						dma_to_cpu_enable <= 0;		
						dma_to_mem_valid <= 1;					
					end
					else if(count_buf1 == max_data_transfer_buf1 && count_buf2 < max_data_transfer_buf2)	//当BUF1已空时，输出开关关闭，停止输出
					begin
						dma_to_cpu_enable <= 1;		
						dma_to_mem_valid <= 0;					
					end
					else if(count_buf1 == max_data_transfer_buf1 && count_buf2 == max_data_transfer_buf2)	//当BUF1已空且BUF2已满时，交换两者的状态，并将两个开关都打开，继续输入与输出				
					begin
						dma_to_cpu_enable <= 1;		
						dma_to_mem_valid <= 1;
						count_buf1 <= 5'b0;
						count_buf2 <= 5'b0;
						state <= ~state;							
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
				if(mem_to_dma_valid && dma_to_mem_enable)
				begin
					if(state == INPUT_BUF1_AND_OUTPUT_BUF2)	//count_buf1为输入端，且count_buf1未满时，允许读入
					begin
						$display("When it's OK to input data from memory to dma(buf1), the data is %x", mem_data_out);					
						BUF1 <= {BUF1[59:0], 4'b0};
						BUF1[3:0] <= mem_data_out;	
						count_buf1 <= count_buf1 + 5'b1;
						$display("Now the content of BUF1 is %x, the content of BUF2 is %x, ", BUF1[63:0], BUF2[63:0]);
						$display("and BUF1 to input, BUF2 to output, direction from memory to cpu\n");
					end
					else if(state == INPUT_BUF2_AND_OUTPUT_BUF1)
					begin
						$display("When it's OK to input data from memory to dma(buf2), the data is %x", mem_data_out);					
						BUF2 <= {BUF2[59:0], 4'b0};
						BUF2[3:0] <= mem_data_out;	
						count_buf2 <= count_buf2 + 5'b1;	
						$display("Now the content of BUF1 is %x, the content of BUF2 is %x, ", BUF1[63:0], BUF2[63:0]);
						$display("and BUF2 to input, BUF1 to output, direction from memory to cpu\n");						
					end
				end
			end
			else if(direction == CPU_TO_MEM)
			begin
				if(cpu_to_dma_valid && dma_to_cpu_enable)
				begin
					if(state == INPUT_BUF1_AND_OUTPUT_BUF2)
					begin
						$display("When it's OK to input data from cpu to dma(buf1), the data is %x", cpu_data_out);					
						BUF1 <= {BUF1[55:0], 8'b0};
						BUF1[7:0] <= cpu_data_out;		
						count_buf1 <= count_buf1 + 5'b1;	
						$display("Now the content of BUF1 is %x, the content of BUF2 is %x, ", BUF1[63:0], BUF2[63:0]);
						$display("and BUF1 to input, BUF2 to output, direction from cpu to memory\n");						
					end
					else if(state == INPUT_BUF2_AND_OUTPUT_BUF1)
					begin
						$display("When it's OK to input data from cpu to dma(buf2), the data is %x", cpu_data_out);					
						BUF2 <= {BUF2[55:0], 8'b0};
						BUF2[7:0] <= cpu_data_out;	
						count_buf2 <= count_buf2 + 5'b1;	
						$display("Now the content of BUF1 is %x, the content of BUF2 is %x, ", BUF1[63:0], BUF2[63:0]);
						$display("and BUF2 to input, BUF1 to output, direction from cpu to memory\n");						
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
				if(dma_to_cpu_valid && cpu_to_dma_enable)
				begin
					if(state == INPUT_BUF1_AND_OUTPUT_BUF2)	//count_buf2为输出端，且count_buf2未空时，允许输出
					begin																			
						$display("When it's OK to output data from dma(buf2) to cpu, the data is %x", BUF2[63:56]);
						cpu_data_in <= BUF2[63:56];
						BUF2 <= {BUF2[55:0], 8'b0};
						count_buf2 <= count_buf2 + 5'b1;
						$display("Now the content of BUF1 is %x, the content of BUF2 is %x, ", BUF1[63:0], BUF2[63:0]);
						$display("and BUF1 to input, BUF2 to output, direction from memory to cpu\n");						
					end
					else if(state == INPUT_BUF2_AND_OUTPUT_BUF1)
					begin
						$display("When it's OK to output data from dma(buf1) to cpu, the data is %x", BUF1[63:56]);					
						cpu_data_in <= BUF1[63:56];
						BUF1 <= {BUF1[55:0], 8'b0};
						count_buf1 <= count_buf1 + 5'b1;
						$display("Now the content of BUF1 is %x, the content of BUF2 is %x, ", BUF1[63:0], BUF2[63:0]);
						$display("and BUF2 to input, BUF1 to output, direction from memory to cpu\n");	
					end
				end
			end
			else if(direction == CPU_TO_MEM)
			begin
				if(dma_to_mem_valid && mem_to_dma_enable)
				begin
					if(state == INPUT_BUF1_AND_OUTPUT_BUF2)
					begin
						$display("When it's OK to output data from dma(buf2) to memory, the data is %x", BUF2[63:56]);
						mem_data_in <= BUF2[63:60];
						BUF2 <= {BUF2[59:0], 4'b0};
						count_buf2 <= count_buf2 + 5'b1;	
						$display("Now the content of BUF1 is %x, the content of BUF2 is %x, ", BUF1[63:0], BUF2[63:0]);
						$display("and BUF1 to input, BUF2 to output, direction from cpu to memory\n");							
					end
					else if(state == INPUT_BUF2_AND_OUTPUT_BUF1)
					begin
						$display("When it's OK to output data from dma(buf1) to memory, the data is %x", BUF1[63:56]);					
						mem_data_in <= BUF1[63:60];
						BUF1 <= {BUF1[59:0], 4'b0};
						count_buf1 <= count_buf1 + 5'b1;
						$display("Now the content of BUF1 is %x, the content of BUF2 is %x, ", BUF1[63:0], BUF2[63:0]);
						$display("and BUF2 to input, BUF1 to output, direction from cpu to memory\n");	
					end
				end
			end
		end
	end		
endmodule
