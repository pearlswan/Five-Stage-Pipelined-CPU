// defines a 2 to 1 mux
`timescale 1ps/1ps
module mux2_1(out, i0, i1, sel);
	output out;
	input i0, i1, sel;
	wire w0, w1, w2;

	not #50 n0(w2, sel);
	and #50 a0(w0, i1, sel);
	and #50 a1(w1, i0, w2);
	or #50 or0(out, w0, w1);
endmodule
