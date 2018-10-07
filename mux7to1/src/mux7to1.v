`timescale 1ns / 1ns // time_unit / time_precision

module mux7to1(data_bus, select_bus, out);
	
	input [6:0] data_bus;
	input [2:0] select_bus;
	output reg out;
	
	always @(*)
	begin
	
		case (select_bus)
			3'b000: out = data_bus[0];
			3'b001: out = data_bus[1];
			3'b010: out = data_bus[2];
			3'b011: out = data_bus[3];
			3'b100: out = data_bus[4];
			3'b101: out = data_bus[5];
			3'b110: out = data_bus[6];
			default: out = 1'b0;
		endcase
		
	end
	
endmodule
