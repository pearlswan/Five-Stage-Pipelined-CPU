// defines a 5 to 32 decoder
module decoder5_32 (out, in, en);
	output [31:0] out;
	input en;
	input [4:0] in;
	wire [3:0] w;

	decoder2_4 d0(w, in[3], in[4], en);
	decoder3_8 d1(out[7:0], in[2:0], w[0]);
	decoder3_8 d2(out[15:8], in[2:0], w[1]);
	decoder3_8 d3(out[23:16], in[2:0], w[2]);
	decoder3_8 d4(out[31:24], in[2:0], w[3]);
endmodule
