`timescale 1ns / 1ns

module full_adder(input a, b, c_in, output s, c_out);

	wire mux_select;
	
	assign mux_select = a ^ b;
	
	mux2to1 mux(
	
		.x(b),
		.y(c_in),
		.select(mux_select),
		.out(c_out)
	
	);
	
	assign s = mux_select ^ c_in;

endmodule

module mux2to1(input x, y, select, output out);

	assign out = (!select & x) | (select & y);

endmodule
