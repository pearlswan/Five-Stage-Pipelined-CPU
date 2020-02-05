module IdReg( ReadData1, ReadData2, Rd, ReadData1out, ReadData2out, Rdout, clk, 
ALUSrc,MemToReg,RegWrite,MemWrite,ALUOp, read_enable, ALUSrcout,MemToRegout,RegWriteout,MemWriteout,ALUOpout, read_enableout ,
ALUImm12in, ALUImm12out, DAddr9in, DAddr9out, Rm, Rmout, Rn, Rnout ,ChooseRd,ChooseRdout);
	input logic [1:0] ALUSrc,MemToReg;
	input logic RegWrite,MemWrite, read_enable;
	input logic [2:0] ALUOp;
	input logic [11:0] ALUImm12in;
	input logic [8:0] DAddr9in;
	input logic clk;
	input logic [63:0] ReadData1, ReadData2;
	input logic [4:0] Rd, Rm, Rn;

	output logic [63:0] ReadData1out, ReadData2out;
	output logic[4:0] Rdout,Rmout,Rnout;
	
	output logic [1:0] ALUSrcout,MemToRegout;
	output logic RegWriteout,MemWriteout, read_enableout;
	output logic [2:0] ALUOpout;
	output logic [11:0] ALUImm12out;
	output logic [8:0] DAddr9out;
	
	input logic ChooseRd;
	output logic ChooseRdout;
	D_FF dff17(.q(ChooseRdout), .d(ChooseRd), .reset(1'b0), .clk(clk)); 
	
	
	genvar i;
	generate
		for(i=0; i < 64; i++) begin : each1
			//D_FF dff1(.q(PCaddrout[i]), .d(PCaddr[i]), .reset(1'b0), .clk(clk)); 
			D_FF dff2(.q(ReadData1out[i]), .d(ReadData1[i]), .reset(1'b0), .clk(clk));
			D_FF dff3(.q(ReadData2out[i]), .d(ReadData2[i]), .reset(1'b0), .clk(clk));
			//D_FF dff4(.q(Branchout[i]), .d(Branch[i]), .reset(1'b0), .clk(clk));
		end   
	endgenerate


	genvar k;
	generate
		for(k=0; k < 5; k++) begin : each3
			D_FF dff4(.q(Rdout[k]), .d(Rd[k]), .reset(1'b0), .clk(clk)); //Rm, Rmout, Rn, Rnout
			D_FF dff5(.q(Rmout[k]), .d(Rm[k]), .reset(1'b0), .clk(clk));
			D_FF dff6(.q(Rnout[k]), .d(Rn[k]), .reset(1'b0), .clk(clk));
		end   
	endgenerate
	
	genvar a;
	generate
		for(a=0; a < 2; a++) begin : each4
			D_FF dff7(.q(ALUSrcout[a]), .d(ALUSrc[a]), .reset(1'b0), .clk(clk)); 
			//D_FF dff8(.q(BrTakenout[a]), .d(BrTaken[a]), .reset(1'b0), .clk(clk)); 
			D_FF dff9(.q(MemToRegout[a]), .d(MemToReg[a]), .reset(1'b0), .clk(clk)); 
		end   
	endgenerate
	
	D_FF dff10(.q(RegWriteout), .d(RegWrite), .reset(1'b0), .clk(clk)); 	
	D_FF dff11(.q(MemWriteout), .d(MemWrite), .reset(1'b0), .clk(clk)); 
	D_FF dff12(.q(read_enableout), .d(read_enable), .reset(1'b0), .clk(clk)); 
	//D_FF dff13(.q(flags_weout), .d(flags_we), .reset(1'b0), .clk(clk));
	
	genvar b;
	generate
		for(b=0; b < 3; b++) begin : each5
			D_FF dff14(.q(ALUOpout[b]), .d(ALUOp[b]), .reset(1'b0), .clk(clk)); 
		end   
	endgenerate
	
	genvar c;
	generate
		for(c=0; c < 12; c++) begin : each6
			D_FF dff15(.q(ALUImm12out[c]), .d(ALUImm12in[c]), .reset(1'b0), .clk(clk)); 
		end   
	endgenerate
	
	genvar d;
	generate
		for(d=0; d < 9; d++) begin : each7
			D_FF dff16(.q(DAddr9out[d]), .d(DAddr9in[d]), .reset(1'b0), .clk(clk)); 
		end   
	endgenerate
endmodule
