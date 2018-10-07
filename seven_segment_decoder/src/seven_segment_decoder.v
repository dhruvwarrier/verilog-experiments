`timescale 1ns / 1ns // `timescale time_unit/time_precision

module seven_segment_decoder(SW, HEX0);
	input [3:0] SW;
	output [6:0] HEX0;
	
	// SW[0] is control signal c0
	// SW[1] is control signal c1
	// SW[2] is control signal c2
	// SW[3] is control signal c3
	
	hex_decoder decoder (
	
		//input ports --> control signals
		.c0(SW[0]),
		.c1(SW[1]),
		.c2(SW[2]),
		.c3(SW[3]),
		
		// output ports --> segments
		.seg0(HEX0[0]),
		.seg1(HEX0[1]),
		.seg2(HEX0[2]),
		.seg3(HEX0[3]),
		.seg4(HEX0[4]),
		.seg5(HEX0[5]),
		.seg6(HEX0[6])
		
	);
	
endmodule
