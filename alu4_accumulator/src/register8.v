`timescale 1ns / 1ns

module register8(input [7:0] data_in, input clock, reset, value_hold, output reg [7:0] q_out);
	
	always @(posedge clock)
	begin
	
		if (reset == 1'b0) begin
			// active-low, synchronous reset
			q_out <= 0;
			
		end else begin
		
			if (value_hold == 1'b0)
				q_out <= data_in;
				// data passes through to q, else is held
		end
	
	end

endmodule
