`timescale 1ns / 1ns // `timescale time_unit/time_precision

module hex_decoder(input [3:0] select, output [6:0] seg_out);
	
	reg d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, dA, dB, dC, dD, dE, dF;
	
	always @(*)
		begin
			// each digit lights up corresponding to its control signals
			d0 = !select[3] & !select[2] & !select[1] & !select[0]; // binary 0
			d1 = !select[3] & !select[2] & !select[1] & select[0]; // binary 1
			d2 = !select[3] & !select[2] & select[1] & !select[0]; // ..
			d3 = !select[3] & !select[2] & select[1] & select[0]; // ..
			d4 = !select[3] & select[2] & !select[1] & !select[0];
			d5 = !select[3] & select[2] & !select[1] & select[0]; 
			d6 = !select[3] & select[2] & select[1] & !select[0];
			d7 = !select[3] & select[2] & select[1] & select[0]; // ..
			d8 = select[3] & !select[2] & !select[1] & !select[0];
			d9 = select[3] & !select[2] & !select[1] & select[0];
			dA = select[3] & !select[2] & select[1] & !select[0];
			dB = select[3] & !select[2] & select[1] & select[0];
			dC = select[3] & select[2] & !select[1] & !select[0]; // ..
			dD = select[3] & select[2] & !select[1] & select[0]; // ..
			dE = select[3] & select[2] & select[1] & !select[0]; // binary 14
			dF = select[3] & select[2] & select[1] & select[0]; // binary 15
		end
	
	
	// each segment lights up for any of the matched digits
	// eg. seg_out[0] lights up on 0, 2, 3 etc
	// final result is inverse because of common anode
	assign seg_out[0] = !(d0 | d2 | d3 | d5 | d6 | d7 | d8 | d9 | dA | dC | dE | dF);
	assign seg_out[1] = !(d0 | d1 | d2 | d3 | d4 | d7 | d8 | d9 | dA | dD);
	assign seg_out[2] = !(d0 | d1 | d3 | d4 | d5 | d6 | d7 | d8 | d9 | dA | dB | dD);
	assign seg_out[3] = !(d0 | d2 | d3 | d5 | d6 | d8 | dB | dC | dD | dE);
	assign seg_out[4] = !(d0 | d2 | d6 | d8 | dA | dB | dC | dD | dE | dF);
	assign seg_out[5] = !(d0 | d4 | d5 | d6 | d8 | d9 | dA | dB | dC | dE | dF);
	assign seg_out[6] = !(d2 | d3 | d4 | d5 | d6 | d8 | d9 | dA | dB | dD | dE | dF);
	
endmodule
