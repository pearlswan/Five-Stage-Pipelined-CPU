// An Or Gate for 66 bits input
`timescale 1ps/1ps
module OR_66 (out, in);
	input [65:0] in;
	output out;
	wire w0, w1, w2;
	
	OR_24 or0(w0, in[23:0]);
	OR_24 or1(w1, in[47:24]);
	OR_24 or2(w2, {6'b000000, in[65:48]});
	or #50 or3(out, w0, w1, w2);	
endmodule
