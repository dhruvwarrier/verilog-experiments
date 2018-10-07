`timescale 1ns / 1ns

module ripple_adder4_main(LEDR, SW);

	input [8:0] SW;
	output [9:0] LEDR;
	
	ripple_adder4 ripple_adder(
		
		// input binary numbers A and B, and Cin
		.A(SW[7:4]),
		.B(SW[3:0]),
		.Cin(SW[8]),
		
		// output sum S of A and B, and Cout
		.S(LEDR[3:0]),
		.Cout(LEDR[9])
	
	);

endmodule
