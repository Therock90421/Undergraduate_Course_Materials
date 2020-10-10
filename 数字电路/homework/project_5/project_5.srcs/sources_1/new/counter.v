`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/22 10:12:34
// Design Name: 
// Module Name: counter
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
module counter_6(
        input CLK,
        input RST,
        output reg [2:0] CNT
        );
        parameter MAX=3'b101;
        always @(posedge RST,posedge CLK)
        begin
            if(RST)
            begin
                CNT<=3'b000;
            end
            else
            begin
                if(CNT==MAX)
                begin
                    CNT<=3'b000;
                end
                else
                begin
                    CNT<=CNT+3'b001;
                end
            end
        end

endmodule
