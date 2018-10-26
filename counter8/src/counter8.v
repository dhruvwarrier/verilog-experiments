`timescale 1ns/1ns

module counter8(input clock, enable, clear_b, output [7:0] out);
	
	// enable_buffer[i] is the enable calculated after the (i-1)th flipflop,
	// to be supplied to the ith flipflop
	wire [8:0] enable_buffer;
	
	assign enable_buffer[0] = enable; 

	generate
		genvar i; // iterate over the t_flipflop instances
		
		for (i=0; i<8; i=i+1) begin: gen_t_ff
		
			t_flipflop t_ff(
			
				// provide each flipflop with same clock and reset
				.clock(clock),
				.reset(clear_b),
				
				// provide the enable for the next flipflop to this flipflop
				.toggle(enable_buffer[i]),
				
				.q_out(out[i])
			
			);
			
			assign enable_buffer[i+1] = out[i] && enable_buffer[i];
		
		end
		
	endgenerate

endmodule
