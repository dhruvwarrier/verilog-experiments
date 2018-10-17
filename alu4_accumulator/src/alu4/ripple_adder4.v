`timescale 1ns / 1ns

module ripple_adder4(input [3:0] A, B, input Cin, output [3:0] S, output Cout);
	
	wire a0_a1, a1_a2, a2_a3;
	
	full_adder a0(
		
		.a(A[0]),
		.b(B[0]),
		.c_in(Cin),
		.s(S[0]),
		.c_out(a0_a1)
		
	);
	
	full_adder a1(
		
		.a(A[1]),
		.b(B[1]),
		.c_in(a0_a1),
		.s(S[1]),
		.c_out(a1_a2)
		
	);
	
	full_adder a2(
		
		.a(A[2]),
		.b(B[2]),
		.c_in(a1_a2),
		.s(S[2]),
		.c_out(a2_a3)
		
	);
	
	full_adder a3(
		
		.a(A[3]),
		.b(B[3]),
		.c_in(a2_a3),
		.s(S[3]),
		.c_out(Cout)
		
	);

endmodule
