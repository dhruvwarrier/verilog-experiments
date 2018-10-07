`timescale 1ns / 1ns // `timescale time_unit/time_precision

module hex_decoder(input c0, c1, c2, c3, output seg0, seg1, seg2, seg3, seg4, seg5, seg6);
	
	reg d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, dA, dB, dC, dD, dE, dF;
	
	always @(*)
		begin
			// each digit lights up corresponding to its control signals
			d0 = !c0 & !c1 & !c2 & !c3; // binary 0
			d1 = !c0 & !c1 & !c2 & c3; // binary 1
			d2 = !c0 & !c1 & c2 & !c3; // ..
			d3 = !c0 & !c1 & c2 & c3; // ..
			d4 = !c0 & c1 & !c2 & !c3;
			d5 = !c0 & c1 & !c2 & c3; 
			d6 = !c0 & c1 & c2 & !c3;
			d7 = !c0 & c1 & c2 & c3; // ..
			d8 = c0 & !c1 & !c2 & !c3;
			d9 = c0 & !c1 & !c2 & c3;
			dA = c0 & !c1 & c2 & !c3;
			dB = c0 & !c1 & c2 & c3;
			dC = c0 & c1 & !c2 & !c3; // ..
			dD = c0 & c1 & !c2 & c3; // ..
			dE = c0 & c1 & c2 & !c3; // binary 14
			dF = c0 & c1 & c2 & c3; // binary 15
		end
	
	
	// each segment lights up for any of the matched digits
	// eg. seg0 lights up on 0, 2, 3 etc
	// final result is inverse because of common anode
	assign seg0 = !(d0 | d2 | d3 | d5 | d6 | d7 | d8 | d9 | dA | dC | dE | dF);
	assign seg1 = !(d0 | d1 | d2 | d3 | d4 | d7 | d8 | d9 | dA | dD);
	assign seg2 = !(d0 | d1 | d3 | d4 | d5 | d6 | d7 | d8 | d9 | dA | dB | dD);
	assign seg3 = !(d0 | d2 | d3 | d5 | d6 | d8 | dB | dC | dD | dE);
	assign seg4 = !(d0 | d2 | d6 | d8 | dA | dB | dC | dD | dE | dF);
	assign seg5 = !(d0 | d4 | d5 | d6 | d8 | d9 | dA | dB | dC | dE | dF);
	assign seg6 = !(d2 | d3 | d4 | d5 | d6 | d8 | d9 | dA | dB | dD | dE | dF);
	
endmodule
