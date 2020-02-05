// Defines an alu block that have two single bit input

`timescale 1ps/1ps
module bit_alu (A, B, Ci, Co, R, sel);
	input A, B, Ci;
	input[2:0] sel;
	output Co, R;
	wire w0, w1, w2, w3;
	
	and #50 a (w1, A, B);
	or #50 o0 (w2, A, B);
	xor #50 xo (w3, A, B);
	add_sub as0 (A, B, Ci, Co, w0, sel[0]);
	mux8_1 m (.out(R), .in({1'bx, w3, w2, w1, w0, w0, 1'bx, B}), .sel(sel));
endmodule
