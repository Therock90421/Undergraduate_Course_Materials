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
	reg			state; 							//�ñ�����ʾ���������������������ϵ����state����1ʱ����ʾBUF1�������ݣ���֮��ΪBUF2��������
	reg [4:0]	max_data_transfer_buf1, max_data_transfer_buf2;
												//���ڽ���BUF1��BUF2�󣬴�����������仯������������������

	parameter Number_of_Data_Transfer_MEM = 16;
	parameter Number_of_Data_Transfer_CPU = 8;
	parameter MEM_TO_CPU = 1;					//��direction����1ʱ����ʾ���ڴ���CPU��������
	parameter CPU_TO_MEM = 0;					//��direction����0ʱ����ʾ��CPU���ڴ洫������
	parameter INPUT_BUF1_AND_OUTPUT_BUF2 = 1;
	parameter INPUT_BUF2_AND_OUTPUT_BUF1 = 0;
	
	always@(posedge clk)						//���г�ʼ��
	begin
		if(!rst_n)
		begin
			BUF1 <= 64'b0;
			BUF2 <= 64'b0;
			state <= INPUT_BUF1_AND_OUTPUT_BUF2;		
			
			count_buf1 <= 5'b0;
			count_buf2 <= (direction) ? Number_of_Data_Transfer_CPU 
									  : Number_of_Data_Transfer_MEM;
			//�������Է�ֹһ��ʼ����buf��Ϊ�յ�ʱ��count-buf2��ʼ������ͬʱҲ����ֱ���ڿ���DMA���ڵ�always�������ʼ������DMA����
		end
		else
		begin
			
		end
	end
	
	always@(posedge clk)						//��DMA���������ؽ��п��ƣ��Լ�������BUF�����������ϵ���е���
	begin
		if(!rst_n)
		begin

		end
		else
		begin
			if(direction == MEM_TO_CPU)			//���ڴ���CPU
			begin
				max_data_transfer_buf1 <= (state) ? Number_of_Data_Transfer_MEM 	//��������������ת��״̬֮�󣬴洢������λ��Ҳ�����仯�������Ҫ���������������������
												  : Number_of_Data_Transfer_CPU;
				max_data_transfer_buf2 <= (state) ? Number_of_Data_Transfer_CPU 
												  : Number_of_Data_Transfer_MEM;	
				if(state == INPUT_BUF1_AND_OUTPUT_BUF2)
				begin
					if(count_buf2 < max_data_transfer_buf2)			//��BUF2δ��ʱ�����ش򿪣��������
					begin
						dma_to_cpu_valid <= 1;
						dma_to_cpu_enable <= 1;
					end
					else											//��BUF2�ѿ�ʱ�����عرգ�ֹͣ���
					begin
						dma_to_cpu_valid <= 0;
						dma_to_cpu_enable <= 0;
						if(count_buf1 == max_data_transfer_buf1)	//�����ʱBUF1���������ύ����������Ĺ�ϵ��ͬʱ�򿪿����Ա����
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
			else if(direction == CPU_TO_MEM)	//��CPU���ڴ�
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
	
	always@(posedge clk)						//�������ݲ�����
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
					if(state == INPUT_BUF1_AND_OUTPUT_BUF2 && count_buf1 < max_data_transfer_buf1)	//count_buf1Ϊ����ˣ���count_buf1δ��ʱ���������
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
		
	always@(posedge clk)				//������ݲ�����
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
					if(state == INPUT_BUF1_AND_OUTPUT_BUF2 && count_buf2 < max_data_transfer_buf2)	//count_buf2Ϊ����ˣ���count_buf2δ��ʱ���������
					begin																			//���о�������ǰ��Ŀ��صĹ�ϵ�����ظ�����Ϊ�˶Գ���������...��ǿ��֢��
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
