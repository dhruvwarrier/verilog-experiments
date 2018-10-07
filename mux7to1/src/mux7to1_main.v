`timescale 1ns / 1ns // time_unit / time_precision

module mux7to1_main(LEDR, SW);
	
	input [9:0] SW;
	output [1:0] LEDR;
	
	// SW[6] to SW[0] are data inputs
	// SW[9] to SW[7] are select signals
	// LEDR[0] is the output multiplexed signal
	
	mux7to1 mux(
	
		.data_bus(SW[6:0]),
		.select_bus(SW[9:7]),
		.out(LEDR[0])
		
	);
	
endmodule
