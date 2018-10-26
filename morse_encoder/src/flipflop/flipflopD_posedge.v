`timescale 1ns / 1ns

module flipflop(input data_in, clock, reset, output reg q_out);

	always @(posedge clock)
	begin
	
		if (reset == 1'b1) begin
		
			// active-high, synchronous reset
			q_out <= 0;
		end else begin
			
			// data passes through to q
			q_out <= data_in;
		end
	
	end

endmodule
