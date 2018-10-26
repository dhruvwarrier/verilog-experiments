`timescale 1ns/1ns

module morse_encoder_main(SW, KEY, LEDR, CLOCK_50);
	
	// SW[2:0] is a 3 bit number representing the letter to be encoded
	// 000 --> S
	// 001 --> T
	// ...
	// 111 --> Z
	input [2:0] SW;
	
	// KEY[1] starts encoding
	// KEY[0] resets the encoder
	input [1:0] KEY;
	
	// output morse code displays on LEDR[0]
	output [1:0] LEDR;
	
	// 50 MHz clock provided by DE1_SoC
	input CLOCK_50;
	
	morse_encoder encoder(
	
		// letter decoded as shown in above table
		.letter(SW[2:0]),
		
		// starts encoded display on LEDR[0]
		.start_encode(~KEY[1]),
		
		.clock(CLOCK_50),
		
		// asynchronous active high reset
		.reset(~KEY[0]),
		
		.morse_code(LEDR[0])
	
	);

endmodule
