


module displaycounter (SW,KEY,CLOCK_50,LEDR,HEX0);
input [9:0] SW;
input [2:0] KEY;
input CLOCK_50;
output [9:0] LEDR;
output [6:0] HEX0;
wire A,B,C,D,E;
wire [3:0] Q;

assign A = CLOCK_50;
onehzclk c1(
    .d(26'b00000000000000000000000001),
    .clock(CLOCK_50),
    .enable(1),
    .par_load(KEY[0]),
    .reset_n(1),
    .out(B)
    );
fivehzclk c2(
    .d(25'b0000000000000000000000001),
    .clock(CLOCK_50),
    .enable(1),
    .par_load(KEY[0]),
    .reset_n(1),
    .out(C)
    );
tfhzclk c3(
    .d(24'b000000000000000000000001),
    .clock(CLOCK_50),
    .enable(1),
    .par_load(KEY[0]),
    .reset_n(1),
    .out(D)
    );

reg eble;
always @(*)
begin
    case (SW[1:0])
    2'b00: eble = A;
    2'b01: eble = B;
    2'b10: eble = C;
    2'b11: eble = D;
endcase
end
assign E = eble;

ccccounter c4(
    .d(4'b0001),
    .clock(CLOCK_50),
    .enable(E),
    .par_load(KEY[0]),
    .reset_n(1),
    .out(Q)
    );

assign LEDR[3:0] = Q[3:0];


decoderr u4(
        .u(Q[3]),
        .v(Q[2]),
		.w(Q[1]),
        .x(Q[0]),
        .HEX00(HEX0[0]),
		  .HEX01(HEX0[1]),
		  .HEX02(HEX0[2]),
		  .HEX03(HEX0[3]),
		  .HEX04(HEX0[4]),
		  .HEX05(HEX0[5]),
		  .HEX06(HEX0[6])
        );

endmodule



module ccccounter (d,clock, enable,par_load,reset_n,out);
input [3:0] d ;                  // Declare d
input clock;                     // Declare clock
input reset_n;                   // Declare reset_n
input par_load, enable;          // Declare par_load and enable
output [3:0] out;
reg [3:0] q;                    // Declare q
always @(posedge clock)         // Triggered every time clock rises
begin
    if (reset_n == 1'b0)        // When reset_n is 0
        q <= 0 ;                // Set q to 0
    else if ( par_load == 1'b1) // Check if parallel load
        q <= d ;                // Load d
    else if ( enable == 1'b1 )  // Increment q only when enable is 1
        begin
            if ( q == 4'b1111 ) // When q is the maximum value for the counter
                q <= 0 ;        // Reset q into 0
            else                // When q is not the maximum value
                q <= q + 1'b1 ; // Increment q
        end
end
assign out[3:0] = q[3:0];


endmodule


module onehzclk (d,clock, enable,par_load,reset_n,out);
input [25:0] d ;                  // Declare d
input clock;                     // Declare clock
input reset_n;                   // Declare reset_n
input par_load, enable;          // Declare par_load and enable
output out;
reg [25:0] q;                    // Declare q
always @(posedge clock)         // Triggered every time clock rises
begin
    if (reset_n == 1'b0)        // When reset_n is 0
        q <= 0 ;                // Set q to 0
    else if ( par_load == 1'b1) // Check if parallel load
        q <= d ;                // Load d
    else if ( enable == 1'b1 )  // Increment q only when enable is 1
        begin
            if ( q == 26'b10111110101100100101110000 ) // When q is the maximum value for the counter
                q <= 0 ;        // Reset q into 0
            else                // When q is not the maximum value
                q <= q + 1'b1 ; // Increment q
        end
end
reg final;
always @(q)
begin
    case (q[25:0])
    26'b00000000000000000000000000: final = 1;
    default: final = 0;
endcase
end
assign out = final;

endmodule












module tfhzclk (d,clock, enable,par_load,reset_n,out);
input [23:0] d ;                  // Declare d
input clock;                     // Declare clock
input reset_n;                   // Declare reset_n
input par_load, enable;          // Declare par_load and enable
output out;
reg [23:0] q;                    // Declare q
always @(posedge clock)         // Triggered every time clock rises
begin
    if (reset_n == 1'b0)        // When reset_n is 0
        q <= 0 ;                // Set q to 0
    else if ( par_load == 1'b1) // Check if parallel load
        q <= d ;                // Load d
    else if ( enable == 1'b1 )  // Increment q only when enable is 1
        begin
            if ( q == 24'b101111101011110000100000 ) // When q is the maximum value for the counter
                q <= 0 ;        // Reset q into 0
            else                // When q is not the maximum value
                q <= q + 1'b1 ; // Increment q
        end
end
reg final;
always @(q)
begin
    case (q[23:0])
    24'b000000000000000000000000: final = 1;
    default: final = 0;
endcase
end
assign out = final;

endmodule

module fivehzclk (d,clock, enable,par_load,reset_n,out);
input [24:0] d ;                  // Declare d
input clock;                     // Declare clock
input reset_n;                   // Declare reset_n
input par_load, enable;          // Declare par_load and enable
output out;
reg [24:0] q;                    // Declare q
always @(posedge clock)         // Triggered every time clock rises
begin
    if (reset_n == 1'b0)        // When reset_n is 0
        q <= 0 ;                // Set q to 0
    else if ( par_load == 1'b1) // Check if parallel load
        q <= d ;                // Load d
    else if ( enable == 1'b1 )  // Increment q only when enable is 1
        begin
            if ( q == 25'b1011111010101000100110000 ) // When q is the maximum value for the counter
                q <= 0 ;        // Reset q into 0
            else                // When q is not the maximum value
                q <= q + 1'b1 ; // Increment q
        end
end
reg final;
always @(q)
begin
    case (q[24:0])
    25'b0000000000000000000000000: final = 1;
    default: final = 0;
endcase
end
assign out = final;

endmodule






module decoderr(u,v,w,x,HEX00,HEX01,HEX02,HEX03,HEX04,HEX05,HEX06);
    input u;
    input v;
	 input w;
    input x;
	 output HEX00;
	 output HEX01;
	 output HEX02;
	 output HEX03;
	 output HEX04;
	 output HEX05;
	 output HEX06;
    assign HEX00 = ~u & ~v & ~w &x | ~u & v & ~w & ~x| u & ~v & w & x | u & v & ~w & x ;
	 assign HEX01 = ~u & v & ~w & x | u & w & x | u & v & ~x | v & w & ~x ;
	 assign HEX02 = ~u & ~v & w & ~x | u & v & ~x| u & v & w;
	 assign HEX03 = ~u & v & ~w & ~x | ~v & ~w & x | v & w & x | u & ~v & w & ~x ;
	 assign HEX04 = ~u & v & ~w | ~v & ~w & x | ~u & x ;
	 assign HEX05 = ~u & ~v & x | ~u & ~v & w | ~u & w & x | u & v & ~w & x ;
	 assign HEX06 = ~u & ~v & ~w | ~u & v & w & x | u & v & ~w & ~x ;

endmodule