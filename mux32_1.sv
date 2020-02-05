// defines a 32 to 1 mux
module mux32_1(out, in, sel);
	output out;
	input [31:0] in;
	input [4:0] sel;
	wire w0, w1, w2, w3;
	
	mux8_1 m0(.out(w0), .in(in[7:0]), .sel(sel[2:0]));
	mux8_1 m1(.out(w1), .in(in[15:8]), .sel(sel[2:0]));
	mux8_1 m2(.out(w2), .in(in[23:16]), .sel(sel[2:0]));
	mux8_1 m3(.out(w3), .in(in[31:24]), .sel(sel[2:0]));
	mux4_1 m (.out(out), .i0(w0), .i1(w1), .i2(w2), .i3(w3), .sel0(sel[3]), .sel1(sel[4]));
endmodule

module mux32_1_testbench();
	reg [31:0] in;
	reg [4:0] sel;
	wire out;
	mux32_1 dut (.out, .in, .sel);
	integer i;
	initial begin
		for(i=0; i< 1024; i++) begin
			{sel, in} = i*1024*1024*1024; #10;
		end
	end
endmodule
