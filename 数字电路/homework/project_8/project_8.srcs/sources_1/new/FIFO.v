`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/04 10:11:15
// Design Name: 
// Module Name: FIFO
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


module FIFO (clk,reset,input_valid,input_enable,output_valid,output_enable,Data_in,
             Data_out_0,Data_out_1,Data_out_2,Data_out_3,Data_out_4,Data_out_5,Data_out_6,Data_out_7);                       //×ÖÄ¸O
input clk,reset;
input input_valid,output_enable;
input [3:0]Data_in;
output reg output_valid,input_enable;
output reg [7:0] Data_out_0,Data_out_1,Data_out_2,Data_out_3,Data_out_4,Data_out_5,Data_out_6,Data_out_7;
reg [7:0]x_0,x_1,x_2,x_3,x_4,x_5,x_6,x_7;
reg [4:0]counter;

always @ (posedge clk) begin
if(!reset)
  begin
   counter <=5'd0;
   output_valid<=1'd0; 
   input_enable<=1'd0;
   x_0<=8'b00000000; x_1<=8'b00000000; x_2<=8'b00000000; x_3<=8'b00000000; x_4<=8'b00000000; x_5<=8'b00000000; x_6<=8'b00000000; x_7<=8'b00000000;
 end 
else
begin 
case(counter)
  5'd16:
  begin 
   input_enable<=1'd0;
   output_valid<=1'd1;
   if(output_enable==1'd1)
   begin
   Data_out_0 <= x_0;  
   Data_out_1  <= x_1;
   Data_out_2 <= x_2;
   Data_out_3 <= x_3;
   Data_out_4 <= x_4;
   Data_out_5  <= x_5;
   Data_out_6  <= x_6;
   Data_out_7 <= x_7;
   counter<=5'b00000;
   end
   end
5'd0:
  begin
  Data_out_0 <= 0;
  Data_out_1 <= 0;
  Data_out_2 <= 0;
  Data_out_3 <= 0;
  Data_out_4 <= 0;
  Data_out_5 <= 0;
  Data_out_6 <= 0;
  Data_out_7 <= 0;
  input_enable <= 1'd1;
  output_valid<= 0'd0;
  if(input_enable && input_valid)
  begin
  x_0[3:0] <=Data_in;
  counter = counter + 5'd1;
  end
  end
5'd1:
   if(input_enable&& input_valid)
   begin
   x_0[7:4] <=Data_in;
   counter = counter + 5'd1;
   end
5'd2:
      if(input_enable&& input_valid)
      begin
      x_1[3:0] <=Data_in;
      counter = counter + 5'd1;
      end
5'd3:
      if(input_enable&& input_valid)
      begin
      x_1[7:4] <=Data_in;
      counter = counter + 5'd1;
      end
5'd4: 
      if(input_enable&& input_valid)
      begin
      x_2[3:0] <=Data_in;
      counter = counter + 5'd1;
      end
5'd5:     
      if(input_enable&& input_valid)
      begin
      x_2[7:4] <=Data_in;
      counter = counter + 5'd1;
      end
5'd6: 
      if(input_enable&& input_valid)
      begin
      x_3[3:0] <=Data_in;
      counter = counter + 5'd1;
      end
5'd7:
      if(input_enable&& input_valid)
      begin
      x_3[7:4] <=Data_in;
      counter = counter + 5'd1;
      end
5'd8:
      if(input_enable&& input_valid)
      begin
      x_4[3:0] <=Data_in;
      counter = counter + 5'd1;
      end
5'd9:
      if(input_enable&& input_valid)
      begin
      x_4[7:4] <=Data_in;
      counter = counter + 5'd1;
      end
5'd10:
      if(input_enable&& input_valid)
      begin
      x_5[3:0] <=Data_in;
      counter = counter + 5'd1;
      end
5'd11:
      if(input_enable&& input_valid)
      begin
      x_5[7:4] <=Data_in;
      counter = counter + 5'd1;
      end
5'd12:
      if(input_enable&& input_valid)
      begin
      x_6[3:0] <=Data_in;
      counter = counter + 5'd1;
      end
5'd13:
      if(input_enable&& input_valid)
      begin
      x_6[7:4] <=Data_in;
      counter = counter + 5'd1;
      end
5'd14:
      if(input_enable&& input_valid)
      begin
      x_7[3:0] <=Data_in;
      counter = counter + 5'd1;
      end
5'd15:
      if(input_enable&& input_valid)
      begin
      x_7[7:4] <=Data_in;
      counter = counter + 5'd1;
      end      
 endcase
 end
 end
endmodule
