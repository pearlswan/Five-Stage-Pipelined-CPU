module EX(ALUresult,WriteData,Rd,ALUresultout,WriteDataout,Rdout,clk,
MemToReg,RegWrite,MemWrite, read_enable,MemToRegout,RegWriteout,MemWriteout, read_enableout,ChooseRd,ChooseRdout);
	input logic clk;
	input logic [63:0] ALUresult, WriteData;
	input logic [4:0] Rd;
	input logic [1:0] MemToReg;
	input logic RegWrite,MemWrite, read_enable;

	output logic [63:0] ALUresultout, WriteDataout;
	output logic [4:0] Rdout;
	output logic [1:0] MemToRegout;
	output logic RegWriteout,MemWriteout, read_enableout;

	
	input logic ChooseRd;
	output logic ChooseRdout;
	D_FF dff17(.q(ChooseRdout), .d(ChooseRd), .reset(1'b0), .clk(clk)); 
	
	
	
	genvar i;
	generate
		for(i=0; i < 64; i++) begin : each1
			//D_FF dff1(.q(Branchaddrout[i]), .d(Branchaddr[i]), .reset(1'b0), .clk(clk)); 
			D_FF dff2(.q(ALUresultout[i]), .d(ALUresult[i]), .reset(1'b0), .clk(clk));
			D_FF dff3(.q(WriteDataout[i]), .d(WriteData[i]), .reset(1'b0), .clk(clk));
		end   
	endgenerate

	genvar k;
	generate
		for(k=0; k < 5; k++) begin : each2
			D_FF dff4(.q(Rdout[k]), .d(Rd[k]), .reset(1'b0), .clk(clk)); 
		end   
	endgenerate

	genvar a;
	generate
		for(a=0; a < 2; a++) begin : each3 
			//D_FF dff5(.q(BrTakenout[a]), .d(BrTaken[a]), .reset(1'b0), .clk(clk)); 
			D_FF dff6(.q(MemToRegout[a]), .d(MemToReg[a]), .reset(1'b0), .clk(clk)); 
		end   
	endgenerate
	
	D_FF dff7(.q(RegWriteout), .d(RegWrite), .reset(1'b0), .clk(clk)); 	
	D_FF dff8(.q(MemWriteout), .d(MemWrite), .reset(1'b0), .clk(clk)); 
	D_FF dff9(.q(read_enableout), .d(read_enable), .reset(1'b0), .clk(clk)); 
	//D_FF dff10(.q(flags_weout), .d(flags_we), .reset(1'b0), .clk(clk));

endmodule
