`timescale 1ns / 1ps

module testbench ( );

	parameter CLOCK_PERIOD = 20;

	reg [8:0] Instruction;
	reg Run;
	wire Done;
	wire [8:0] BusWires;

	reg CLOCK_50;
	initial begin
		CLOCK_50 <= 1'b0;
	end // initial
	always @ (*)
	begin : Clock_Generator
		#((CLOCK_PERIOD) / 2) CLOCK_50 <= ~CLOCK_50;
	end
	
	reg Resetn;
	initial begin
		Resetn <= 1'b0;
		#20 Resetn <= 1'b1;
	end // initial

	initial begin
				Run	<= 1'b0;	Instruction	<= 9'b000000000;	//move from register 0 to register 0
		#20	Run	<= 1'b1; Instruction	<= 9'b001000000;	//mvi value 23 to register 0
		#20	Run	<= 1'b0; Instruction	<= 9'b000010111;	
		#20	Run	<= 1'b1; Instruction	<= 9'b001001000;	// mvi 
		#20	Run	<= 1'b0; Instruction	<= 9'b000000100; // value of 4 to register 1
		#20	Run	<= 1'b1; Instruction	<= 9'b010000001;  //value in register 0 = 27
		#20	Run	<= 1'b0;
		#60	Run	<= 1'b1; Instruction	<= 9'b010000001;  // value in register 0 = 31
		#20	Run	<= 1'b0;
		#60	Run 	<=1'b1; Instruction <= 9'b010000001;  //value in register 0 = 35
		#20	Run 	<=1'b0;
		#60	Run 	<= 1'b1; Instruction <= 9'b001001000;   //mvi
		#20	Run	<=1'b0; Instruction <= 9'b000000101;  // value of 5 to register 1
		#20	Run	<=1'b1; Instruction <= 9'b011000001; //value in register 0 = 30
		#20	Run	<=1'b0;
	end // initial

	processor9 U1 (CLOCK_50, Resetn, Run, Instruction, Done, BusWires);

endmodule
