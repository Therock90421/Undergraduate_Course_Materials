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
	reg [4:0]	count_buf1, count_buf2; 		//���������������������ݵĴ��������Դ����ж��Ƿ�Ϊ�ջ���
	reg 		dma_to_mem_valid, dma_to_mem_enable;
	reg			dma_to_cpu_valid, dma_to_cpu_enable;
	reg			state; 							//��state����1ʱ����ʾBUF1�������ݣ���֮��ΪBUF2��������
	reg [4:0]	max_data_transfer_buf1, max_data_transfer_buf2;
												//���ڽ���BUF1��BUF2�󣬴�����������仯������������������

	parameter Number_of_Data_Transfer_MEM = 16;
	parameter Number_of_Data_Transfer_CPU = 8;
	parameter MEM_TO_CPU = 1;					//��direction����1ʱ����ʾ���ڴ���CPU��������
	parameter CPU_TO_MEM = 0;					//��direction����0ʱ����ʾ��CPU���ڴ洫������
	parameter INPUT_BUF1_AND_OUTPUT_BUF2 = 1;
	parameter INPUT_BUF2_AND_OUTPUT_BUF1 = 0;
	
	always@(posedge clk)						//���г�ʼ�����Լ�����
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
			else								//���ƵĲ��ַ�������һ��always������
			begin
				dma_to_cpu_valid <= 1;
				dma_to_cpu_enable <= 1;
				count_buf1 <= 5'b0;
				count_buf2 <= 5'b0;
				state <= ~state;				
			end
		end
	end
	
	always@(posedge clk)						//�Զ�������ݽ��п��ƣ��Լ�������BUF�����������ϵ���е���
	begin
		if(!rst_n)
		begin

		end
		else
		begin
			if(direction == MEM_TO_CPU)			//���ڴ���CPU
			begin
				max_data_transfer_buf1 <= (state) ? Number_of_Data_Transfer_MEM 
												  : Number_of_Data_Transfer_CPU;
				max_data_transfer_buf2 <= (state) ? Number_of_Data_Transfer_CPU 
												  : Number_of_Data_Transfer_MEM;												  
			end
			else if(direction == CPU_TO_MEM)	//��CPU���ڴ�
			begin
				max_data_transfer_buf1 <= (state) ? Number_of_Data_Transfer_CPU 
												  : Number_of_Data_Transfer_MEM;
				max_data_transfer_buf2 <= (state) ? Number_of_Data_Transfer_MEM 
												  : Number_of_Data_Transfer_CPU;												  
			end
		end
	end
	
	always@(posedge clk)						//���벢�������
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
