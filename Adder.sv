// A 1 bit adder
`timescale 1ps/1ps
module bitAdder(A, B, Ci, Co, S);
	input A, B, Ci;
	output Co, S;
	wire w1, w2, w3;

	xor #50 x0 (S, Ci, A, B);
	and #50 a0 (w1, A, Ci);
	and #50 a1 (w2, B, Ci);
	and #50 a2 (w3, A, B);
	or #50 o(Co, w1, w2, w3);	
endmodule

// A 64 bit full adder
module Adder(A, B, Ci, Co, S);
	input [63:0] A, B;
	input Ci;
	output Co;
	output [63:0] S;
	wire [63:0] w;
	
	bitAdder ba0 (.A(A[0]), .B(B[0]), .Ci(1'b0), .Co(w[0]), .S(S[0]));

	genvar i;
	generate     
		for(i = 1; i < 64; i++) begin : eachBit   
			bitAdder ba(.A(A[i]), .B(B[i]), .Ci(w[i-1]), .Co(w[i]), .S(S[i]));		
		end   
	endgenerate

endmodule
