`timescale 1ns / 1ns

module shift_register8_main(LEDR, SW, KEY);

	// SW[7:0] is used as the DATA_IN bus for the shift register
	// SW[9] is the active high RESET for the shift register
	input [9:0] SW;
	
	// KEY[0] is the clock to the the shift register
	// KEY[3:1] are function inputs for the shift register:
	// KEY[1] is ParallelLoadn, KEY[2] is RotateRight, KEY[3] is LSRight (Logical shift right)
	// When ParallelLoadn = 0, the value on DATA_IN is stored on the next positive clock edge
	// When ParallelLoadn = 1, shift register shifts 8 bits to the right or left at next positive clock edge, depending
	// on RotateRight and LSRight as follows:
	// For RotateRight = 1, LSRight = 0, the 8 bits are rotated right
	// For RotateRight = 1, LSRight = 1, the 8 bits are rotated right, where each time MSB is replaced with 0 (logical shift)
	// For RotateRight = 0, the 8 bits are rotated left 
	input [3:0] KEY;
	
	// the value of the shift register is displayed on LEDR
	output [7:0] LEDR;
	
	shift_register8 shift_reg8(
		
		// data to be loaded in to register on ParallelLoadn = 0
		.DATA_IN(SW[7:0]),
		
		// function inputs for the shift register, behavior according to above table
		// inverted because DE1_SoC recognizes pushed key as 0 an unpushed key as 1
		.ParallelLoadn(!KEY[1]),
		.RotateRight(!KEY[2]),
		.LSRight(!KEY[3]),
		
		.Q_out(LEDR[7:0]),
		
		// clock generates positive edge on key up
		.clock(KEY[0]),
		
		// active high RESET, clears the shift register
		.reset(SW[9])
	
	);
	
endmodule
