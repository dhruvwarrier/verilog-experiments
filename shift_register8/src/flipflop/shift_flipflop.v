`timescale 1ns / 1ns

module shift_flipflop(input right, left, load_left, D, parallel_loadn, clock, reset, output q_out);

	// right and left are the bits to the right and left of this flipflop
	// when parallel_loadn = 0, data bit D is loaded into flipflop at next positive clock edge
	// when parallel_loadn = 1, value of flipflop depends on load_left, left and right as follows:
	// when load_left = 1, left bit is loaded into flipflop at next positive clock edge
	// when load_left = 0, right bit is loaded into flipflop at next positive clock edge
	
	wire adjacent_bit, data_to_flipflop;
	
	// selects between the two adjacent bits in the shift register
	mux2to1 load_left_right_bit(
	
		.x(right),
		.y(left),
		.select(load_left),
		.out(adjacent_bit)
	
	);
	
	// selects between data to be loaded, and the adjacent bit for rotation
	mux2to1 load_data_parallel(
	
		.x(D),
		.y(adjacent_bit),
		.select(parallel_loadn),
		.out(data_to_flipflop)
	
	);
	
	flipflop ff (
		
		// data to be stored, whether adjacent bit or loaded data
		.data_in(data_to_flipflop),
		
		// stored bit in this shift_flipflop
		.q_out(q_out),
		
		// on positive edge of clock, rotation is performed
		.clock(clock),
		.reset(reset)
	
	);
	

endmodule
