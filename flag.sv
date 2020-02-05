// Defines a flag register with write-enable
module flag(clk, rst, DataIn, DataOut, we);
	input clk, rst, we;
	input DataIn;
	output DataOut;
	logic data;   
	mux2_1 m (.out(data), .i0(DataOut), .i1(DataIn), .sel(we));	
	D_FF d_FF(DataOut, data, rst, clk);	
endmodule
