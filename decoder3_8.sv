// defines a 3 to 8 decoder
`timescale 1ps/1ps
module decoder3_8 (out, in, en);
	output [7:0] out;
	input en;
	input [2:0] in;
	wire w0, w1, w2, w3;

	not #50 n0(w2, in[2]);
	and #50 a0(w0, w2, en);
	and #50 a1(w1, in[2], en);
	decoder2_4 d0(out[3:0], in[0], in[1], w0);
	decoder2_4 d1(out[7:4], in[0], in[1], w1);
endmodule
