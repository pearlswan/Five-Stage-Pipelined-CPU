// An Or Gate for 9 bits input
`timescale 1ps/1ps
module OR_9 (out, in);
	input [8:0] in;
	output out;
	wire w0, w1, w2;
	
	or #50 or0(w0, in[2], in[1], in[0]);
	or #50 or1(w1, in[5], in[4], in[3]);
	or #50 or2(w2, in[8], in[7], in[6]);
	or #50 or3(out, w0, w1, w2);	
endmodule
