// Defines an alu block that have input of two 64 bit data
// alu control
// cntrl			Operation						Notes:
// 000:			result = B						value of overflow and carry_out unimportant
// 010:			result = A + B
// 011:			result = A - B
// 100:			result = bitwise A & B		value of overflow and carry_out unimportant
// 101:			result = bitwise A | B		value of overflow and carry_out unimportant
// 110:			result = bitwise A XOR B
`timescale 1ps/1ps
module alu (A, B, cntrl, result, negative, zero, overflow, carry_out);
	input [63:0] A, B;
	input [2:0] cntrl;
	output [63:0] result;
	output negative, zero, overflow, carry_out;
	wire zero_n;
	wire [63:0] w;
	
	bit_alu ba0 (.A(A[0]), .B(B[0]), .Ci(cntrl[0]), .Co(w[0]), .R(result[0]), .sel(cntrl));

	genvar i;
	generate     
		for(i = 1; i <= 63; i++) begin : eachBit_alu     
			bit_alu ba(.A(A[i]), .B(B[i]), .Ci(w[i-1]), .Co(w[i]), .R(result[i]), .sel(cntrl));		
		end   
	endgenerate
	
	xor #50 x0 (overflow, w[62], w[63]);
	assign negative = result[63];
	assign carry_out = w[63];

	// To calculate zero flag
	OR_66 allOr (.out(zero_n), .in({2'b00, result}));
	not #50 n(zero, zero_n);

endmodule
