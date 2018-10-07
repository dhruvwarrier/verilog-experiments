`timescale 1ns / 1ns

module ripple_subtractor4(input [3:0] A, B, output reg [3:0] S, output Cout);

	wire [3:0] sum_result, sum_result_comp;
	wire is_positive;
	
	// adds A and 2s's complement of B
	ripple_adder4 adder(
		
		.A(A),
		// performs 2s complement of B and adds to A
		.B(~B),
		.Cin(1'b1),
		
		.S(sum_result),
		// Cout indicates if output value is positive
		.Cout(is_positive)
	);
	
	// calculates 2s complement of result if number is negative
	twos_complement4 comp(
		.nibble(sum_result),
		.comp_nibble(sum_result_comp)
	);
	
	always @(*)
	begin
	
		if (is_positive) begin
			// result is +ve, display as-is
			S = sum_result;
			
		end else begin
			// result is -ve, display 2's comp of number
			S = sum_result_comp; 
			
		end
		
	end
	
	assign Cout = is_positive;

endmodule

module twos_complement4(input [3:0] nibble, output [3:0] comp_nibble);

	ripple_adder4 add1(
		
		// perform 1's complement
		.A(~nibble),
		// add 1
		.B(4'b0001),
		.Cin(1'b0),
		// output 2's complement nibble
		.S(comp_nibble)
		
	);

endmodule
