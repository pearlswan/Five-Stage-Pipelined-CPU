// defines a 2 to 4 decoder
`timescale 1ps/1ps
module decoder2_4 (out, in0, in1, en);
	output [3:0] out;
	input en, in0, in1;
	wire in0_n, in1_n, w0, w1, w2, w3;

	not #50 n0(in0_n, in0);
	not #50 n1(in1_n, in1);
	and #50 a0(w0, in0_n, in1_n);
	and #50 a1(w1, in0, in1_n);
	and #50 a2(w2, in0_n, in1);
	and #50 a3(w3, in0, in1);
	and #50 a4(out[0], w0, en);
	and #50 a5(out[1], w1, en);
	and #50 a6(out[2], w2, en);
	and #50 a7(out[3], w3, en);
endmodule
