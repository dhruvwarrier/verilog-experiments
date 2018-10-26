`timescale 1ns/1ns

module frequency_divider_main(SW, HEX0, CLOCK_50);

	input CLOCK_50; // 50 MHz clock provided by DE1_SoC

	// SW[1] and SW[0] are control signals for the 4-bit counter
	// SW[1] = 0, SW[0] = 0 --> Full speed i.e. 50 MHz
	// SW[1] = 0, SW[0] = 1 --> 4 Hz
	// SW[1] = 1, SW[0] = 0 --> 2 Hz
	// SW[1] = 1, SW[0] = 1 --> 1 Hz
	// SW[9] is used to clear the counter at the beginning, active-low
	input [9:0] SW;
	
	// HEX0 is used to display a 4-bit counter counting from 0 to F
	output [6:0] HEX0;
	
	// 1, 2, or 4 Hz clock signal depending on control signals
	wire freq_divided_clock;
	
	//division_rate is the clock frequency division rate
	wire [25:0] division_rate;
	
	// counter out to 7-segment display
	wire [3:0] counter_out;
	
	// ----------------------------- Control signal translation -----------------------------------
	
	translate_control_signals translator(
	
		// control signals as input
		.control(SW[1:0]),
		
		// control signals translated to produce division_rate
		.division_rate(division_rate)
	
	);
	
	// ------------------------------- Rate divider definition -----------------------------------
	
	rate_divider divide_clock_freq(
		
		.clock_in(CLOCK_50),
		
		// never reset rate_divider
		.clear_b(1'b1),
		 // rate divider is always enabled
		.enable(1'b1),
		
		// division of frequency decided by control signals
		.D(division_rate),
		
		.clock_out(freq_divided_clock)
	
	);
	
	// ------------------------------- Display counter definition -----------------------------------
	
	counter4_parload counter(
		
		// 50 MHz clock
		.clock(CLOCK_50),
		// active-low, synchronous clear
		.clear_b(SW[9]),
		
		// enable counter at divided frequency
		.enable(freq_divided_clock),
		
		.q_out(counter_out)
	);
	
	// decode counter_out into hex for 7 segment display
	hex_decoder hex0(.select(counter_out),.seg_out(HEX0));

endmodule
