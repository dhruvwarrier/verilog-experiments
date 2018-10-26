`timescale 1ns/1ns

module counter8_main(SW, KEY, HEX0, HEX1);

	// SW[1] used as counter enable
	// SW[0] used as counter clear
	input [1:0] SW;
	
	// KEY[0] is used as counter clock
	input [1:0] KEY;
	
	// display 8-bit counter output, 4 bits each
	// HEX0 displays the lower 4 bits
	// HEX1 displays the upper 4 bits
	output [6:0] HEX0, HEX1;
	
	wire [7:0] counter_out;
	
	counter8 counter(
	
		.clock(KEY[0]),
		
		// enable enables/disables the counter
		.enable(SW[1]),
		
		// clear_b is active low asynchronous clear
		.clear_b(SW[0]),
		
		.out(counter_out)
	);
	
	// set hex0 and hex1 to lower and upper 4 bits of counter_out respectively
	hex_decoder hex0(.select(counter_out[3:0]),.seg_out(HEX0));
	hex_decoder hex1(.select(counter_out[7:4]),.seg_out(HEX1));

endmodule
