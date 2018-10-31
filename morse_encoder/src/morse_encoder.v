`timescale 1ns/1ns

module morse_encoder(input [2:0] letter, input start_encode, clock, reset, output morse_code);

	// bit pattern related to specific letter
	wire [15:0] bit_pattern;
	// shifted bit pattern from shift register
	wire [15:0] shifted_bit_pattern;
	
	// pulses every 0.5s i.e 2 Hz
	wire clock_reduced_freq;
	
	// looks up bit pattern related to a specific letter
	lookup_letter lookup_table(.letter(letter),.bit_pattern(bit_pattern));
	
	// used to control when data is loaded into the shift register
	reg parallel_loadn;
	
	// load data at posedge start_encode pulse, and stop loading data at end of pulse
	always @(start_encode)
	begin
	
		if (start_encode == 1'b1)
			parallel_loadn <= 0;
		else if (start_encode == 1'b0)
			parallel_loadn <= 1;
	
	end
	
	// ---------------------------------- Rate divider definition ---------------------------------
	
	rate_divider divide_freq(
	
		.clock_in(clock),
		
		// need rate_divider to never turn off
		.clear_b(1'b1),
		.enable(1'b1),
		
		// 25 million in binary, 2 Hz = 0.5s freq
		.D(26'b01011111010111100001000000), 
		.clock_out(clock_reduced_freq)
	
	);
	
	// ---------------------------------- Shift register definition ---------------------------------
	
	shift_register16 shift_16 (
	
		.DATA_IN(bit_pattern),
		
		// data is loaded in at the start of start_encode
		.ParallelLoadn(parallel_loadn),
		
		// rotate bit pattern left
		.RotateRight(1'b0),
		.LSRight(1'b0),
		
		// 2 Hz freq = 0.5s shift register read time
		.clock(clock_reduced_freq),
		.reset(reset),
		.Q_out(shifted_bit_pattern)
	
	);
	
	// morse code is the last bit shifted out from the shift register through the left
	assign morse_code = shifted_bit_pattern[15];

endmodule


module lookup_letter(input [2:0] letter, output reg [15:0] bit_pattern);

	always @(*)
	begin
		case(letter)
		
			3'b000: bit_pattern = 16'b1010100000000000; // S
			3'b001: bit_pattern = 16'b1110000000000000; // T
			3'b010: bit_pattern = 16'b1010111000000000; // U
			3'b011: bit_pattern = 16'b1010101110000000; // V
			3'b100: bit_pattern = 16'b1011101110000000; // W
			3'b101: bit_pattern = 16'b1110101011100000; // X
			3'b110: bit_pattern = 16'b1110101110111000; // Y
			3'b111: bit_pattern = 16'b1110111010100000; // Z
			default: bit_pattern = 16'b0;
			
		endcase
	
	end

endmodule
