`timescale 1ns/1ns

module processor9 
	(
		input clock,				// 50MHz clock on the DE1_SoC
		input resetn, 				// active low reset
		input run, 					// tells the processor to run instruction in DIN
		input [8:0] DIN, 			// opcode + immediate data
		output done, 				// high when the processor is done with this op
		output [8:0] system_bus // system bus
	);
	
	// There are 4 instructions, as follows:
	// opcode 00: mv Rx, Ry ==> performs: Rx <= Ry
	// opcode 01: mvi Rx, #D ==> performs: Rx <= #D (#D is immediate value)
	// opcode 10: add Rx, Ry ==> performs: Rx <= Rx + Ry
	// opcode 11: sub Rx, Ry ==> performs: Rx <= Rx - Ry
	
	// Instruction is in the following format:
	// IIIXXXYYY
	// III is the opcode
	// XXX and YYY are register codes, 0 to 7 address R0 to R7
	// YYY can also be immediate 3 bit data

	// ------------------------- instruction register ----------------------------------
	
	// Instruction reg stores entire current instruction
	reg [8:0] instr_reg;
	// controlled by FSM, loads the instruction on DIN
	wire IRin;
	
	always @(posedge clock)
	begin
		if (!resetn)
			instr_reg <= 0;
		else if (IRin) begin
			instr_reg <= DIN;
		end
	end
	
	// ------------------------- Control to datapath -----------------------------------
	
	// selects what goes out on the system bus, protocol: {DINout, Gout, Rout}
	// DINout puts DIN on the system bus
	// Gout puts the stored ALU output on the system bus
	// Rout[7:0] selects which register goes out on the system bus
	wire [9:0] select_sys_bus_out;
	
	// selects which register gets loaded from the system bus, protocol: {Ain, Rin}
	// Ain loads the accumulator with the system bus
	// Rin[7:0] selects which register to load with the system bus
	wire [8:0] select_sys_bus_in;
	
	// stores ALU output into output register
	wire store_ALU_output;
	
	// tells the ALU whether to add or subtract (add:0, sub:1)
	wire select_add_subtract;
	
	// ------------------------ Control and datapath modules ---------------------------
	
	control FSM (
	
		.clock(clock),
		.resetn(resetn),
		
		// current instruction to be executed
		.instr(instr_reg),
		// execute instruction
		.execute(run),
		
		.select_sys_bus_in(select_sys_bus_in),
		.select_sys_bus_out(select_sys_bus_out),
		.store_ALU_output(store_ALU_output),
		.select_add_subtract(select_add_subtract),
		
		// ------------------------ higher level module ---------------------------------
		
		// loads the next instruction on DIN
		.load_instruction(IRin),
		// indicates that this op is complete
		.done(done)
	
	);
	
	datapath proc (
	
		.clock(clock),
		.resetn(resetn),
		
		.select_sys_bus_in(select_sys_bus_in),
		.select_sys_bus_out(select_sys_bus_out),
		.store_ALU_output(store_ALU_output),
		.select_add_subtract(select_add_subtract),
		
		.data_in(DIN),
		.system_bus(system_bus)
	
	);

endmodule

module control (input clock, resetn, input [8:0] instr, input execute,
					 output reg [8:0] select_sys_bus_in, output reg [9:0] select_sys_bus_out, 
					 output reg store_ALU_output, select_add_subtract, load_instruction, done);
			
	// define 4 machine states to perform all instructions on this processor
	
	localparam T0 = 2'b00,
				  T1 = 2'b01,
				  T2 = 2'b10,
				  T3 = 2'b11;
	
	// store the current and next machine state
	reg [1:0] current_state, next_state;
	
	// opcode to machine code translation
	localparam mv = 3'b000,
				  mvi = 3'b001,
				  add = 3'b010,
				  sub = 3'b011;
	
	// ---------------------------- decode instruction ---------------------------------
	
	// stores only the top 3 bits from the instruction i.e. the opcode
	wire [2:0] opcode;
	assign opcode = instr[8:6];
	
	// XXX and YYY register codes translated into one hot register code
	wire [7:0] X_decoded, Y_decoded;
	
	decoder_3to8 decode_X (instr[5:3], 1'b1, X_decoded);
	decoder_3to8 decode_Y (instr[2:0], 1'b1, Y_decoded);

	// processor is done when in state 1 of mv and mvi, and state 3 of add and sub
	//assign done = {1'b0, T1} && (mv || mvi) || {1'b0, T3} && (add || sub);
	
	// ------------------------------- state table -------------------------------------
	
	always @(*)
	begin: state_table
		case(current_state)
			T0:
			begin
				if (execute) next_state = T1;
				else next_state = T0;
			end
			T1: 
			begin
				if (done) next_state = T0;
				else next_state = T2;
			end
			T2: next_state = T3;
			T3: next_state = T0;
			default: next_state = T0;
		endcase
	end // state_table
	
	// used to build select_sys_bus_out, see bus protocol above
	reg [7:0] Rout;
	reg DINout, Gout;
	
	// used to build select_sys_bus_in, see bus protocol above
	reg [7:0] Rin;
	reg Ain;
	
	// -------------------------- control bus logic -----------------------------------
	
	always @(*)
	begin: control_signals
	
		// default values for control signals, prevent latching
		store_ALU_output = 1'b0;
		select_add_subtract = 1'b0;
		load_instruction = 1'b0;
		done = 1'b0;
	
		// zero out the control signals used to build select_sys_bus_in
		// and select_sys_bus_out
		Rin = 8'b00000000;
		Rout = 8'b00000000;
		Ain = 1'b0;
		DINout = 1'b0;
		Gout = 1'b0;	
		
		case(current_state)
		
			T0: load_instruction = 1'b1;
			T1:
			begin
				case (opcode)
					mv: 
					begin
						Rout = Y_decoded; 	// put Y on the system bus
						Rin = X_decoded;  	// put system bus into X
						done = 1'b1;
					end
					mvi:
					begin
						DINout = 1'b1;			// put immediate data on the system bus
						Rin = X_decoded;		// put system bus into X
						done = 1'b1;
					end
					add, sub:
					begin
						Rout = X_decoded;		// put X out on system bus
						Ain = 1'b1;				// put system bus into accumulator
					end
					default: ;
				endcase
			end
			T2:
			begin
				case (opcode)
					add:
					begin
						Rout = Y_decoded;					// put Y out on system bus
						store_ALU_output = 1'b1;		// store into output register (G)
					end
					sub:
					begin
						Rout = Y_decoded;					// put Y out on system bus
						select_add_subtract = 1'b1;	// select subtraction
						store_ALU_output = 1'b1;		// store into output register (G)
					end
					default: ;
				endcase
			end
			T3:
			begin
				case (opcode)
					add:
					begin
						Gout = 1'b1;			// put output onto system bus
						Rin = X_decoded;		// put system bus into X
						done = 1'b1;
					end
					sub:
					begin
						Gout = 1'b1;			// put output onto system bus
						Rin = X_decoded;		// put system bus into X
						done = 1'b1;
					end
					default: ;
				endcase
			end
		
		endcase
	end // control_signals

	// construct control buses
	always @(*)
	begin
		select_sys_bus_in <= {Ain, Rin};
		select_sys_bus_out <= {DINout, Gout, Rout};
	end
	
	// move to next machine state 
	always @(posedge clock)
	begin
		if (!resetn)
			current_state <= T0;
		else
			current_state <= next_state; // move to next computed state at each clock cycle
	end
	
		
endmodule

module datapath (input clock, resetn, input [8:0] select_sys_bus_in, data_in,
					  input [9:0] select_sys_bus_out, input store_ALU_output, 
					  select_add_subtract, output reg [8:0] system_bus);
					  
	wire [7:0] Rin; // registers load
	assign Rin = select_sys_bus_in[7:0];
	wire Ain; // accumulator load
	assign Ain = select_sys_bus_in[8];
	
	// result from the ALU
	reg [8:0] ALU_result;
	
	// ------------------------  create 8 registers + accumulator ----------------------
	
	// outputs from registers
	// R0 to R7 are the 8 registers in this processor
	// A is the accumulator, and G is the ALU output register
	wire [8:0] R0, R1, R2, R3, R4, R5, R6, R7, A, G;
	
	regn reg_0 (system_bus, Rin[0], clock, R0);
	regn reg_1 (system_bus, Rin[1], clock, R1);
	regn reg_2 (system_bus, Rin[2], clock, R2);
	regn reg_3 (system_bus, Rin[3], clock, R3);
	regn reg_4 (system_bus, Rin[4], clock, R4);
	regn reg_5 (system_bus, Rin[5], clock, R5);
	regn reg_6 (system_bus, Rin[6], clock, R6);
	regn reg_7 (system_bus, Rin[7], clock, R7);
	regn reg_A (system_bus, Ain, clock, A);
	
	// ------------------------- define the system bus ---------------------------------
	
	// system bus protocol: {DINout, Gout, Rout}
	
	always @(*)
	begin
		case (select_sys_bus_out)
			10'b0000000001: system_bus = R0;
			10'b0000000010: system_bus = R1;
			10'b0000000100: system_bus = R2;
			10'b0000001000: system_bus = R3;
			10'b0000010000: system_bus = R4;
			10'b0000100000: system_bus = R5;
			10'b0001000000: system_bus = R6;
			10'b0010000000: system_bus = R7;
			10'b0100000000: system_bus = G;
			10'b1000000000: system_bus = data_in;
			default: system_bus = data_in;
		endcase
	end
	
	// ------------------------------- ALU --------------------------------------------
	
	always @(*)
	begin
		if (!select_add_subtract)
			ALU_result <= A + system_bus; // add
		else 
			ALU_result <= A - system_bus; // subtract
	end
	
	regn reg_G (ALU_result, store_ALU_output, clock, G);
	
endmodule

// ------------------------------ helper modules --------------------------------------

module decoder_3to8 
	(
		input [2:0] in, 			// input 3 bit bus to be decoded to 8 bit bus
		input enable, 				// enable this module
		output reg [7:0] out			// output 8 bit bus
	);

	always @(*)
	begin
		if (enable) begin
			case (in)
				3'b000: out = 8'b00000001;
				3'b001: out = 8'b00000010;
				3'b010: out = 8'b00000100;
				3'b011: out = 8'b00001000;
				3'b100: out = 8'b00010000;
				3'b101: out = 8'b00100000;
				3'b110: out = 8'b01000000;
				3'b111: out = 8'b10000000;
				default: out = 8'b00000000;
			endcase
		end else
			out = 8'b00000000;
	end

endmodule

module regn (D, Rin, clock, Q);

	parameter n = 9;
	input [n-1:0] D;
	input clock, Rin;
	output reg [n-1:0] Q;
	
	always @(posedge clock)
		if (Rin)
			Q <= D;

endmodule
