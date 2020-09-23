// Part 2 skeleton

module part2
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
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
	input   [9:0]   SW;
	input   [3:0]   KEY;

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;
	wire ldX, ldY;
	wire [4:0] counter;
	
	assign colour = SW[9:7];

	// Create an Instance of a VGA controller - there can be only one!
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
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.
    
    // Instansiate datapath
	datapath d0(
			.clk(CLOCK_50),
			.ldX(ldX),
			.ldY(ldY),
			.counter(counter),
			.x_in({1'b0, SW[6:0]}),
			.y_in(SW[6:0]),
			.resetn(resetn),
			.x_out(x),
			.y_out(y));

    // Instansiate FSM control
   control c0(
			.clk(CLOCK_50),
			.go(KEY[3]),
			.resetn(resetn),
			.enable(KEY[1]),
			.writeEn(writeEn),
			.ldX(ldX),
			.ldY(ldY),
			.counter(counter));
    
endmodule

module datapath(clk, ldX, ldY, counter, x_in, y_in, resetn, x_out, y_out);
	input clk;
	input ldX, ldY;
	input [4:0] counter; // signal to increment x, y values
	input [7:0] x_in;
	input [6:0] y_in;
	input resetn;
	
	reg [7:0] x;
	reg [6:0] y;
	
	output [7:0] x_out;
	output [6:0] y_out;
	
	always@(posedge clk)
	begin
		if(!resetn)
		begin
			x <= 8'd0;
			y <= 7'd0;
		end
		else if(ldX)
			x <= x_in;
		else if(ldY)
			y <= y_in;
	end
	assign x_out = x + counter[1:0];
	assign y_out = y + counter[3:2];
		
endmodule

module control(clk, go, resetn, enable, writeEn, ldX, ldY, counter);
	input clk, go;
	input resetn;
	input enable;
	output reg writeEn;
	output reg ldX, ldY;
	
	output reg [4:0]counter;
	
	reg [2:0] current_state, next_state;

	localparam S_WAIT			 = 3'd0,
				  S_LOAD_X      = 3'd1,
				  S_LOAD_X_WAIT = 3'd2,
				  S_LOAD_Y      = 3'd3,
				  S_LOAD_Y_WAIT = 3'd4,
				  S_DRAW			 = 3'd5,
				  S_DRAW_WAIT   = 3'd6;
				  
	always@(posedge clk)
	begin
		if(!resetn)
			counter <= 5'b10000;
		else if(enable)
		begin
			if(counter == 5'b00000)
				counter <= 5'b10000;
			else
				counter <= counter - 1'b1;
		end
	end
	
	
	always@(*)
	begin: state_table
		case(current_state)
			S_WAIT: next_state = go ? S_WAIT : S_LOAD_X;
			S_LOAD_X: next_state = go ? S_LOAD_X_WAIT : S_LOAD_X;
			S_LOAD_X_WAIT: next_state = go ? S_LOAD_X_WAIT : S_LOAD_Y;
			S_LOAD_Y: next_state = go ? S_LOAD_Y_WAIT : S_LOAD_Y;
			S_LOAD_Y_WAIT: next_state = ~enable ? S_LOAD_Y_WAIT : S_DRAW;
			S_DRAW: next_state = (counter == 5'b00000) ? S_DRAW_WAIT : S_DRAW;
			S_DRAW_WAIT: next_state = S_WAIT;
			default: next_state = S_WAIT;
		endcase
	end
	
	always@(*)
	begin: enable_signals
		writeEn = 1'b0;
		ldX = 1'b0;
		ldY = 1'b0;
		
		case(current_state)
			S_LOAD_X: ldX = 1'b1;
			S_LOAD_Y: ldY = 1'b1;
			S_DRAW: writeEn = 1'b1;
			S_DRAW_WAIT: writeEn = 1'b1;
		endcase
	end
	
	always@(posedge clk)
	begin: state_FFS
		if(!resetn)
			current_state <= S_WAIT;
		else
			current_state <= next_state;
	end
endmodule
