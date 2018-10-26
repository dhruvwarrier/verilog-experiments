`timescale 1ns / 1ns

module mux2to1(input x, y, select, output out);

	assign out = (!select & x) | (select & y);

endmodule
