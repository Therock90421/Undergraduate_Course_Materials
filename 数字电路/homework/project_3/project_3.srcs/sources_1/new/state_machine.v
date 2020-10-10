`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/13 10:20:27
// Design Name: 
// Module Name: state_machine
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


module state_machine(
input A,B,clk,reset,
output wire Y,W);
reg [2:0]state;
wire [1:0]in;
reg [1:0]out;
assign in={A,B};
assign W=out[1];
assign Y=out[0];

parameter S0=2'b000,S1=2'b001,S2=2'b010,
            S3=2'b011,S4=2'b100,S5=2'b101;
parameter false=2'b000,true=2'b001,wrong=2'b010;
parameter read_00=2'b00,read_01=2'b01,read_10=2'b10,read_11=2'b11;


always@(posedge clk or posedge reset)begin
  if(reset)
  state<=S0;
  
  else if(state==S0)
  begin
  if(in==read_00)          begin state<=S5; out=true; end
  else if(in==read_11)     begin state<=S1; out=false; end
  else                     begin state<=S0; out=wrong; end
  end
  
  else if(state==S1)
  begin
  if(in==read_01)          begin state<=S3; out=false; end
  else if(in==read_10)     begin state<=S4; out=true; end       
  else                     begin state<=S1; out=wrong; end
  end
  
  else if(state==S2)
  begin 
  if(in==read_10)          begin state<=S5; out=false; end
  else if(in==read_00)     begin state<=S1; out=true; end
  else                     begin state<=S2; out=wrong; end
  end
 
  else if(state==S3)
  begin
  if(in==read_00)          begin state<=S2; out=false; end
  else if(in==read_10)     begin state<=S4; out=true; end
  else                     begin state<=S3; out=wrong; end
  end
  
  else if(state==S4)
  begin 
  if(in==read_01)          begin state<=S5; out=true; end
  else if(in==read_10)     begin state<=S3; out=false; end
  else                     begin state<=S4; out=wrong; end
  end
  
  else if(state==S5)
  begin
  if(in==read_00)          begin state<=S5; out=false; end
  else if(read_10)         begin state<=S0; out=true; end
  else                     begin state<=S5; out=true; end
  end
       end
       
endmodule
