`timescale 1ns/1ns

module translate_control_signals(input [1:0] control, output reg [25:0] division_rate);

	always @(*)
	begin
	
		case(control)
		
			2'b00: division_rate = 26'b1;
			2'b01: division_rate = 26'b00101111101011110000100000; // this is 12.5 million in binary (50 MHz / 4)
			2'b10: division_rate = 26'b01011111010111100001000000; // this is 25 million in binary (50 MHz / 2)
			2'b11: division_rate = 26'b10111110101111000010000000; // this is 50 million in binary
				
		endcase
		
	end

endmodule
