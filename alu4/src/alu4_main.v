`timescale 1ns / 1ns

module alu4_main(LEDR, SW, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

	// SW[7:4] is A, SW[3:0] is B
	input [7:0] SW;
	// KEY[2:0] are the function inputs for the ALU
	// 000 --> returns A + B using ripple_adder4
	// 001 --> returns A + B using verilog + operator
	// 010 --> returns A NAND B in lower 4 bits of ALUout and A NOR B in upper 4 bits of ALUout
	// 011 --> returns 8’b11000000 if at least 1 of the 8 bits in the two inputs is 1
	// 100 --> returns 8’b00111111 if exactly 2 bits of A are 1, and exactly 3 bits of the B are 1
	// 101 --> returns B in the upper 4 bits and the complement of A in the lower 4 bits of ALUout
	// 110 --> returns A XNOR B in the lower 4 bits and A XOR B in the upper 4 bits of ALUout
	// 111 --> returns A - B using ripple_subtractor4
	// default --> returns 8'b00000000
	input [2:0] KEY;
	
	// LEDR[7:0] displays ALUout
	output [7:0] LEDR;
	// HEX0 displays B and HEX2 displays A
	// HEX4 and HEX5 display the digits in ALUout
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	wire [3:0] four_bit_zero;
	assign four_bit_zero[3:0] = 4'b0000;
	
	// ---------------------------- ALU definition --------------------------------------
	alu4 alu(
		
		// function selected according to above table
		// inverted since DE1_SOC recognizes pushed as 0 and unpushed as 1
		.f_select(~KEY[2:0]),

		.A(SW[7:4]),
		.B(SW[3:0]),

		.alu_out(LEDR[7:0])
		
	);
	
	// ---------------------------- 7 segment display output --------------------------------
	
	// sets hex1 and hex3 to 0
	hex_decoder hex1(.select(four_bit_zero),.seg_out(HEX1[6:0]));
	hex_decoder hex3(.select(four_bit_zero),.seg_out(HEX3[6:0]));
	
	// sets hex0 to B
	hex_decoder hex0(
		.select(SW[3:0]),
		.seg_out(HEX0[6:0])
	);
	
	// sets hex2 to A
	hex_decoder hex2(
		.select(SW[7:4]),
		.seg_out(HEX2[6:0])
	);
	
	// sets hex4 to lower 4 bits of ALUout
	hex_decoder hex4(
		.select(LEDR[3:0]),
		.seg_out(HEX4[6:0])
	);
	
	// sets hex5 to upper 4 bits of ALUout
	hex_decoder hex5(
		.select(LEDR[7:4]),
		.seg_out(HEX5[6:0])
	);
	
endmodule
