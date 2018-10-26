`timescale 1ns/1ns

module t_flipflop(input toggle, clock, reset, output reg q_out);

	always @ (posedge clock, negedge reset)
	begin
	
		if (reset == 1'b0) begin
			//active low, asynchronous reset
			q_out <= 0;
			
		end else if (toggle == 1'b1) begin
			
			// toggle stored value
			q_out <= ~q_out;
		end
	
	end

endmodule
