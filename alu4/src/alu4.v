`timescale 1ns / 1ns

module alu4(input [2:0] f_select, input [3:0] A, B, output reg [7:0] alu_out);

	wire [3:0] four_bit_zero;
	wire [2:0] three_bit_zero;
	wire [7:0] condition_failed;
	
	assign four_bit_zero[3:0] = 4'b0000;
	assign three_bit_zero[2:0] = 3'b000;
	assign condition_failed[7:0] = 8'b00000000;
	
	// used for the 4 bit adder and subtractor results
	wire [3:0] ripple_adder_result, ripple_subtractor_result;
	wire adder_overflow;
	
	reg a_condition, b_condition; // conditions for case 100
	
	// adder and subtractor for case 0 and case 7
	ripple_adder4 adder(
	
		.A(A),
		.B(B),
		.Cin(1'b0),
		.Cout(adder_overflow),
		.S(ripple_adder_result)
		
	);
	
	ripple_subtractor4 subtractor(
	
		.A(A),
		.B(B),
		.S(ripple_subtractor_result)
		
	);

	always @(*)
	begin
	
		case(f_select)
			3'b000: alu_out = {three_bit_zero, adder_overflow, ripple_adder_result};
			3'b001: alu_out = {four_bit_zero, A + B};
			3'b010: alu_out = {~(A | B), ~(A & B)};
			3'b011: 
				begin
				
					if(|A || |B) begin
						alu_out = 8'b11000000;
					end else begin
						alu_out = condition_failed;
					end
					
				end
			3'b100:
				begin
					
					// exactly 3 bits of B are 1
					case(B)
						4'b1110, 4'b1101, 4'b0111, 4'b1011: b_condition = 1'b1;
						default: b_condition = 1'b0;
					endcase
					
					// exactly 2 bits of A are 1
					if (~^A && |A && ~&A) begin
						a_condition = 1'b1;
					end else begin
						a_condition = 1'b0;
					end
					
					// both conditions are true
					if (a_condition == 1'b1 && b_condition == 1'b1) begin
						alu_out = 8'b00111111;
					end else begin
						alu_out = condition_failed;
					end
					
				end
			3'b101: alu_out = {B, ~A};
			3'b110: alu_out = {A ^ B, ~(A ^ B)};
			3'b111:  alu_out = {four_bit_zero, ripple_subtractor_result};
			default: alu_out = condition_failed;
		endcase
		
	end

endmodule
