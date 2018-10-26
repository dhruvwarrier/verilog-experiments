`timescale 1ns/1ns

module rate_divider(input clock_in, clear_b, enable, input [25:0] D, output clock_out);

	// counter out from rate divider
	reg [25:0] Q_out;
	
	always @(posedge clock_in)
	begin
		// counts clock pulses and sends output pulse when loaded value reaches 0
		
		if(clear_b == 1'b0) // active-low, synchronous clear
			Q_out <= 0;
		else if (Q_out == 26'b0) // reset to highest value when reached 0
			Q_out <= D - 26'b1;
		else if (enable == 1'b1) // if not clear, decrement on enable
			Q_out <= Q_out - 1;
	
	end
	
	// enable clock_out when count has reached cycles to count
	assign clock_out = (Q_out == 26'b0) ? 1 : 0;

endmodule
