`timescale 1ns / 1ns

module shift_register16(input [15:0] DATA_IN, input ParallelLoadn, RotateRight, LSRight, clock, reset, output [15:0] Q_out);
	
	// Q_out_buffer contains Q_out sandwiched between MSB and LSB
	// Q_out_buffer[17] is MSB's left, Q_out_buffer[0] is LSB's right 
	wire [17:0] Q_out_buffer;
	
	generate
		genvar i; // used to iterate over the flipflop instances
		
		// iterating from 1 to 16 to leave space for LSB flipflop's right port
		for (i=1; i<17; i=i+1) begin: gen_ff
		
			shift_flipflop shift_ff(
				
				// provide identical inputs to each flipflop
				// load_left receives RotateRight since rotating right loads the bit to the left at each ff
				.parallel_loadn(ParallelLoadn),
				.load_left(RotateRight),
				
				// wire each bit of the input and output to the data input/outputs
				.D(DATA_IN[i-1]),
				.q_out(Q_out_buffer[i]),
				
				// left is wired to data out of next adjacent shift_flipflop
				// right is wired to data out of previous adjacent shift_flipflop
				.left(Q_out_buffer[i+1]),
				.right(Q_out_buffer[i-1]),
				
				// provide each flipflop with same clock and reset
				.clock(clock),
				.reset(reset)
			
			);
			
			// assign each Q_out to the correct output wire (since iterating from 1 to 16 instead of 0 to 15)
			assign Q_out[i-1] = Q_out_buffer[i];
		
		end
	
	endgenerate
	
	// Q_out_buffer[0] is LSB flipflop's right port
	// assign the right port of LSB flipflop to MSB, used to shift left
	assign Q_out_buffer[0] = Q_out[15];
	
	mux2to1 enable_ls_right(
	
		// if LSRight = 0, perform regular shift right
		.x(Q_out[0]),
		
		// if LSRight = 1, load 0 into MSB
		.y(1'b0),
		.select(LSRight),
		
		// Q_out_buffer[17] is MSB flipflop's left port
		// assign the left port of MSB flipflop to LSB, used to shift right
		.out(Q_out_buffer[17])
	
	);

endmodule
