`timescale 1ns/1ns

module counter4_parload(input clock, clear_b, enable, output reg [3:0] q_out);

	// allows count up till F, since we can check when overflow occurs
	reg [4:0] q_out_buffer;

	always @(posedge clock)
	begin
	
		if(clear_b == 1'b0) // active-low, synchronous clear
			q_out_buffer <= 0;
		else if (q_out_buffer == 5'b10000) // reset when reached max value
			q_out_buffer <= 0;
		else if (enable == 1'b1) // if not clear, increment on enable
			q_out_buffer <= q_out_buffer + 1;
			
		q_out = q_out_buffer[3:0];
	
	end

endmodule
