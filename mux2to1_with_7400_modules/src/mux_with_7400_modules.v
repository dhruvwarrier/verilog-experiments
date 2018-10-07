`timescale 1ns / 1ns // `timescale time_unit/time_precision

module mux_with_7400_modules(LEDR, SW);
	input [9:0] SW;
	output [9:0] LEDR;
	
	// SW[9] is the control signal s
	// SW[0] is the data signal x
	// SW[1] is the data signal y
	// LEDR[0] is the output multiplexed signal
	
	wire w_NOTtoAND;
	wire w_ANDtoOR_x;
	wire w_ANDtoOR_y;

	v7404 NOT_gate(
		.pin1(SW[9]),
		.pin2(w_NOTtoAND)
	);
	
	v7408 AND_gate(
		.pin1(w_NOTtoAND),
		.pin2(SW[0]),
		.pin3(w_ANDtoOR_x),
		.pin4(SW[1]),
		.pin5(SW[9]),
		.pin6(w_ANDtoOR_y)
	);
	
	v7432 OR_gate(
		.pin1(w_ANDtoOR_x),
		.pin2(w_ANDtoOR_y),
		.pin3(LEDR[0])
	);
	
endmodule
