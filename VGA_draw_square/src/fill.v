
module fill
	(
		CLOCK_50,						//	On Board 50 MHz
		SW,                        // On Board switches
		KEY,							// On Board Keys
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	
	// KEY[3] is used to load a position value (X or Y) into memory
	// KEY[2] clears the entire screen to black
	// KEY[1] plots a square at position (X, Y) with colour specified by SW[9:7]
	// KEY[0] is the system active low reset (Resetn) which resets the FSM and the registers
	input	[3:0]	KEY;
	
	// SW[9:7] are the input RGB signals, which can represent a total of 8 colours
	// SW[6:0] are used to input X and Y locations one after another into memory
	// locations are 7 bit, can only access 128 columns of the display
	input [9:0] SW;
	
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[7:0]	VGA_R;   				//	VGA Red[7:0] Changed from 10 to 8-bit DAC
	output	[7:0]	VGA_G;	 				//	VGA Green[7:0]
	output	[7:0]	VGA_B;   				//	VGA Blue[7:0]
	
	// ----------------------------------- Input set for VGA_draw_square module ---------------------------------------
	
	wire resetn;
	wire [6:0] pos_in;
	wire store_pos;
	wire clear_scr;
	wire plot;
	
	// assigned according to table above
	assign resetn = KEY[0];
	assign pos_in = SW[6:0];
	assign store_pos = ~KEY[3];
	assign clear_scr = ~KEY[2];
	assign plot = ~KEY[1];
	
	// ----------------------------------- Output set from VGA_draw_square module --------------------------------------
	// ----------------------------------- These are inputs to the VGA controller --------------------------------------

	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;

	// --------------------------------------- Instance of VGA controller  ---------------------------------------------
	
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
		
	// ----------------------------------- Instance of VGA_draw_square module ---------------------------------------
			
	// Loads the position values sequentially into memory and generates the position vectors for a 4x4 square
	// For each position vector, it produces a high plot_enable which writes the pixel to the VGA frame buffer
	// Signals produced below: x, y, colour and writeEn for the VGA controller
	
	VGA_draw_square draw_square(
	
		// -------------------------------------- inputs ---------------------------------------
	
		.clock(CLOCK_50),
		
		// resets the FSM to the initial state
		// this is KEY[0]
		.resetn(resetn),
		
		// input position (X or Y) to be loaded in memory
		.pos_in(pos_in),
		
		// input color in RGB, total of 8 possible colors
		.color_in(SW[9:7]),
		
		// control signal to store input position in memory
		.store_pos(store_pos),
		
		// clears screen to black
		.clear_scr(clear_scr),
		
		.plot(plot),
		
		// -------------------------------------- outputs ---------------------------------------
		
		// generates writeEn only after X and Y have been loaded in memory
		// disregards plot until position values have been loaded and generates plot_enable after
		// draws a 4x4 square by default, by changing X and Y and producing plot_enable for each position vector (X,Y)
		
		.plot_enable(writeEn),
		
		// X and Y position generated at each FSM cycle
		.X(x),
		.Y(y),
		
		// color_in usually flows out to color_out unless the screen is being cleared in which case it is 000 i.e. black
		.color_out(colour)
	
	);
	
endmodule
