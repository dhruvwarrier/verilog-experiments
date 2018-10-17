`timescale 1ns / 1ns

module alu4_main(LEDR, SW, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

	// SW[3:0] is the Data input i.e. A, and B is a bus of the 4 least signficant bits of the accumulator
	// SW[9] is the RESET for the accumulator
	input [9:0] SW;
	// KEY[3:1] are the function inputs for the ALU
	// 000 --> returns A + B using ripple_adder4
	// 001 --> returns A + B using verilog + operator
	// 010 --> returns A NAND B in lower 4 bits of ALUout and A NOR B in upper 4 bits of ALUout
	// 011 --> returns 8’b11000000 if at least 1 of the 8 bits in the two inputs is 1
	// 100 --> returns 8’b00111111 if exactly 2 bits of A are 1, and exactly 3 bits of the B are 1
	// 101 --> returns B in the upper 4 bits and the complement of A in the lower 4 bits of ALUout
	// 110 --> returns A XNOR B in the lower 4 bits and A XOR B in the upper 4 bits of ALUout
	// 111 --> holds the current value of the accumulator i.e. register value does not change
	// default --> returns 8'b00000000
	// KEY[0] is the clock input for the accumulator
	input [3:0] KEY;
	
	// ALUout is stored in the accumulator, and also displayed on LEDR[7:0]
	output [7:0] LEDR;
	// HEX0 displays A (the data input)
	// HEX4 and HEX5 display the digits in the accumulator (ALUout)
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	wire [3:0] four_bit_zero;
	assign four_bit_zero[3:0] = 4'b0000;
	
	// alu_out is stored in the accumulator
	wire [7:0] alu_to_accumulator;
	
	// used to hold the value of the accumulator for function 7
	wire value_hold;
	
	// ---------------------------- ALU definition --------------------------------------
	alu4 alu(
		
		// function selected according to above table
		// inverted since DE1_SOC recognizes pushed as 0 and unpushed as 1
		.f_select(~KEY[3:1]),
		
		// data input provided by user
		.A(SW[3:0]),
		
		// least significant 4 bits from accumulator
		.B(LEDR[3:0]),

		.alu_out(alu_to_accumulator),
		
		// ALU can hold accumulator value through accumulator_value_hold
		.accumulator_value_hold(value_hold)
		
	);

	// ------------------- Accumulator register definition ------------------------------

	register8 accumulator(
	
		.data_in(alu_to_accumulator),
		
		// on key up produces a positive edge, so accumulator 
		// is updated only when KEY[0] is pressed and then unpressed
		.clock(KEY[0]),
		
		// reset is active low
		.reset(SW[9]),
		
		// used to completely prevent changes to the register i.e. to keep its value stored
		.value_hold(value_hold),
		
		// outputs directly to LEDR, from where least significant 
		// 4 bits are piped back as B
		.q_out(LEDR[7:0])
	
	);
	
	// ---------------------------- 7 segment display output --------------------------------
	
	// sets hex1, hex2, and hex3 to 0
	hex_decoder hex1(.select(four_bit_zero),.seg_out(HEX1[6:0]));
	hex_decoder hex2(.select(four_bit_zero),.seg_out(HEX2[6:0]));
	hex_decoder hex3(.select(four_bit_zero),.seg_out(HEX3[6:0]));
	
	// sets hex0 to A (data input)
	hex_decoder hex0(
		.select(SW[3:0]),
		.seg_out(HEX0[6:0])
	);
	
	// sets hex4 to lower 4 bits of accumulator register
	hex_decoder hex4(
		.select(LEDR[3:0]),
		.seg_out(HEX4[6:0])
	);
	
	// sets hex5 to upper 4 bits of accumulator register
	hex_decoder hex5(
		.select(LEDR[7:4]),
		.seg_out(HEX5[6:0])
	);
	
endmodule
