module MEM(memData,address,Rd,memDataout,addressout,Rdout,clk,
MemToReg,RegWrite,MemToRegout,RegWriteout,ChooseRd,ChooseRdout); // aluresult flag
	input logic clk;
	input logic [63:0] memData, address;
	input logic [4:0] Rd;
	input logic [1:0] MemToReg;
	input logic RegWrite;

	
	output logic [63:0] memDataout,addressout;
	output logic [4:0] Rdout;	
	output logic [1:0] MemToRegout;
	output logic RegWriteout;

	
	input logic ChooseRd;
	output logic ChooseRdout;
	D_FF dff17(.q(ChooseRdout), .d(ChooseRd), .reset(1'b0), .clk(clk)); 
	
	
	
	genvar i;
	generate
		for(i=0; i < 64; i++) begin : each1
			D_FF dff1(.q(memDataout[i]), .d(memData[i]), .reset(1'b0), .clk(clk));
			D_FF dff2(.q(addressout[i]), .d(address[i]), .reset(1'b0), .clk(clk)); 	

		end   
	endgenerate

	genvar k;
	generate
		for(k=0; k < 5; k++) begin : each3
			D_FF dff3(.q(Rdout[k]), .d(Rd[k]), .reset(1'b0), .clk(clk)); 
		end   
	endgenerate
	

	genvar a;
	generate
		for(a=0; a < 2; a++) begin : each4
			//D_FF dff4(.q(BrTakenout[a]), .d(BrTaken[a]), .reset(1'b0), .clk(clk)); 
			D_FF dff5(.q(MemToRegout[a]), .d(MemToReg[a]), .reset(1'b0), .clk(clk)); 
		end   
	endgenerate
	
	D_FF dff6(.q(RegWriteout), .d(RegWrite), .reset(1'b0), .clk(clk)); 	
	//D_FF dff7(.q(flags_weout), .d(flags_we), .reset(1'b0), .clk(clk));

	
endmodule
