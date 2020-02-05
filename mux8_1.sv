// defines a 8 to 1 mux
module mux8_1(out, in, sel);
	output out;
	input [7:0] in;
	input [2:0] sel;
	wire w0, w1;
	
	mux4_1 m0(.out(w0), .i0(in[0]), .i1(in[1]), .i2(in[2]), .i3(in[3]), .sel0(sel[0]), .sel1(sel[1]));
	mux4_1 m1(.out(w1), .i0(in[4]), .i1(in[5]), .i2(in[6]), .i3(in[7]), .sel0(sel[0]), .sel1(sel[1]));
	mux2_1 m (.out(out), .i0(w0), .i1(w1), .sel(sel[2]));
endmodule
