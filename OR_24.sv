// An Or Gate for 24 bits input
`timescale 1ps/1ps
module OR_24 (out, in);
	input [23:0] in;
	output out;
	wire w0, w1, w2;
	
	OR_9 or0(w0, in[8:0]);
	OR_9 or1(w1, in[17:9]);
	OR_9 or2(w2, {3'b000, in[23:18]});
	or #50 or3(out, w0, w1, w2);	
endmodule
