// defines a 4 to 1 mux
module mux4_1(out, i0, i1, i2, i3, sel0, sel1);
	output out;
	input i0, i1, i2, i3, sel0, sel1;
	wire v0, v1;
	
	mux2_1 m0(.out(v0), .i0(i0), .i1(i1), .sel(sel0));
	mux2_1 m1(.out(v1), .i0(i2), .i1(i3), .sel(sel0));
	mux2_1 m (.out(out), .i0(v0), .i1(v1), .sel(sel1));
endmodule
