// defines a 1 bit adder/subtractor
`timescale 1ps/1ps
module add_sub(A, B, Ci, Co, S, sel);
	input A, B, Ci, sel;
	output Co, S;
	wire Bi, B_n, w1, w2, w3;

	not #50 n (B_n, B);
	mux2_1 m (.out(Bi), .i0(B), .i1(B_n), .sel(sel));
	xor #50 x0 (S, Ci, A, Bi);
	and #50 a0 (w1, A, Ci);
	and #50 a1 (w2, Bi, Ci);
	and #50 a2 (w3, A, Bi);
	or #50 o(Co, w1, w2, w3);	
endmodule
