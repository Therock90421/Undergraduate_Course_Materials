
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/10 17:57:43
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


`timescale 1ns / 1ns

module counter_test
();

	reg				clk;
    reg	[7:0]		state;
    reg	[31:0]		interval;
    reg [39:0]          state_info;

    wire [31:0]     counter;

	initial begin
		clk = 1'b1;
		interval = 32'd1;
		state = 0;
		forever begin
		  repeat(5)
		  begin
            #100
            state = {$random} % 3;
          end
          interval = {$random} % 5;
        end
	end

	always begin
		# 5 clk = ~clk;
	end

	always @ (state) begin
		case(state)
		  0: state_info = "RESET";
		  1: state_info = "RUN";
		  2: state_info = "HALT";
		endcase
	end
	
    counter    u_counter (
        .clk		(clk),
        .interval   (interval),
        .state		(state),

        .counter	(counter)
    );

endmodule