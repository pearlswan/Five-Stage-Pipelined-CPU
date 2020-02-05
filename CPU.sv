`timescale 1ns/10ps
// Defines a single cycled CPU
module CPU(clk, reset);
	input clk, reset;	
	//logic [31:0] instruction; // 32 bit instruction 
	logic [1:0] ALUSrc,BrTaken; // control signals
	logic Reg2Loc,UncondBr,flags_we; // control signals
	logic [2:0] ALUOp; // control signals
	logic Zero,Negative,overflow, carry_out; // output flags from ALU
	logic NegativeFlag,overflowFlag,carry_outFlag,ZeroFlag; // register style flags of previous instructions
	logic [63:0] DbResult, NextAddr; 
	logic [4:0] Rd, x30;
	assign x30 =5'b11110;
	
	logic [31:0] instruction_IF, instruction_Reg;
	logic [63:0] PCaddr_IF,PCaddr_Reg, Da, Db,ReadData1out,ReadData2out;
	logic [1:0] ALUSrcout, BrTakenout;
	logic  flags_weout;
	logic [2:0] ALUOpout;
	logic [4:0] Rdout,RdIDout,RdEXout,RdMEMout, RmID, RnID;

	logic [63:0] ALUresult, ALUresultDataMem, WriteDataout;
	logic MemWriteID, MemWriteIDout,MemWriteEX, read_enableID, read_enableIDout, read_enableEX;
	
	logic [63:0] MemDout, MemData,ALUresultWB;
	logic [1:0]  MemToRegID,MemToRegIDout,MemToRegEXout,MemToRegMEMout;
	logic RegWriteID, RegWriteIDout, RegWriteEXout, RegWriteMEMout;
	logic [11:0] ALUImm12;
	logic [8:0] DAddr9;
	genvar i;
	generate
		for(i=0; i < 5; i++) begin : mux1     
			mux2_1 m1(.out(Rd[i]), .i0(instruction_Reg[i]), .i1(x30[i]), .sel(MemToRegID[1])); // choose Rd. Rd = X30 for Br instruction
		end   
	endgenerate

	logic [1:0] forwardA, forwardB;
	logic forwarden , ChooseRd;
	
	IF IFID(.PCaddr(PCaddr_IF), .instruction(instruction_IF), .PCaddrout(PCaddr_Reg),.instructionOut(instruction_Reg), .clk(clk));

	IdReg IDEX( .ReadData1(Da), .ReadData2(DbResult), .Rd(Rd), .ReadData1out(ReadData1out), .ReadData2out(ReadData2out), .Rdout(RdIDout), .clk(clk), 
	.ALUSrc(ALUSrc),.MemToReg(MemToRegID),.RegWrite(RegWriteID),.MemWrite(MemWriteID), .ALUOp(ALUOp), .read_enable(read_enableID), .ALUSrcout(ALUSrcout),
	.MemToRegout(MemToRegIDout),.RegWriteout(RegWriteIDout),.MemWriteout(MemWriteIDout),.ALUOpout(ALUOpout), .read_enableout(read_enableIDout),
	.ALUImm12in(instruction_Reg[21:10]), .ALUImm12out(ALUImm12), .DAddr9in(instruction_Reg[20:12]), .DAddr9out(DAddr9),
	.Rm(instruction_Reg[20:16]), .Rmout(RmID), .Rn(instruction_Reg[9:5]), .Rnout(RnID),
	.ChooseRd(ChooseRd),.ChooseRdout(ChooseRdID));
	// ALUImm12(instruction_Reg[21:10]) ALUImm12
	
	EX EXMEM(.ALUresult(ALUresult), .WriteData(ReadData2out),.Rd(RdIDout),.ALUresultout(ALUresultDataMem),.WriteDataout(WriteDataout),.Rdout(RdEXout),.clk(clk),
	.MemToReg(MemToRegIDout),.RegWrite(RegWriteIDout),.MemWrite(MemWriteIDout), .read_enable(read_enableIDout),
	.MemToRegout(MemToRegEXout),.RegWriteout(RegWriteEXout),.MemWriteout(MemWriteEX), .read_enableout(read_enableEX), .ChooseRd(ChooseRdID),.ChooseRdout(ChooseRdEX));
	
	MEM MEMWB(.memData(MemDout), .address(ALUresultDataMem),.Rd(RdEXout),.memDataout(MemData), .addressout(ALUresultWB),.Rdout(RdMEMout),.clk(clk),
	.MemToReg(MemToRegEXout),.RegWrite(RegWriteEXout),.MemToRegout(MemToRegMEMout),.RegWriteout(RegWriteMEMout), .ChooseRd(ChooseRdEX),.ChooseRdout(ChooseRdMEM)); 
	
	forwarding forward(.RmID(RmID), .RnID(RnID), .RdEXout(RdEXout), .RdMEMout(RdMEMout), .RegWriteEXout(RegWriteEXout), 
	.RegWriteMEMout(RegWriteMEMout), .forwardA(forwardA), .forwardB(forwardB), .forwarden(forwarden));

	
	// set flags 
	flag neg(.clk(clk), .rst(1'b0), .DataIn(Negative), .DataOut(NegativeFlag), .we(flags_we));
	flag ov(.clk(clk), .rst(1'b0), .DataIn(overflow), .DataOut(overflowFlag), .we(flags_we));
	flag co(.clk(clk), .rst(1'b0), .DataIn(carry_out), .DataOut(carry_outFlag), .we(flags_we));
	flag zero(.clk(clk), .rst(1'b0), .DataIn(Zero), .DataOut(ZeroFlag), .we(flags_we));
	
	controlLogic cntl(.instruction(instruction_Reg), .Zero, .NegativeFlag, .overflowFlag,.Reg2Loc, .ALUSrc(ALUSrc), .MemToReg(MemToRegID), .RegWrite(RegWriteID), .MemWrite(MemWriteID),
	.BrTaken, .UncondBr, .ALUOp(ALUOp), .read_enable(read_enableID), .flags_we, .clk(clk), .reset, .forwarden(forwarden), .ChooseRd(ChooseRd));
	
	InstrCtrl instr(.clk(clk),.reset, .DbResult, .instruction(instruction_IF), .BrTaken, .UncondBr, .CondAddr19(instruction_Reg[23:5]), .BrAddr26(instruction_Reg[25:0]),
	.NextAddr,.PCaddr_IF(PCaddr_IF), .PCaddr_Reg(PCaddr_Reg)); // PCaddr_Reg
	
	RegMem regm(.NextAddr,.Reg2Loc(Reg2Loc),.ALUSrc(ALUSrcout),.MemToReg(MemToRegMEMout),.RegWrite(RegWriteMEMout), .MemWrite(MemWriteEX),
	.ALUOp(ALUOpout),.Rd(Rd), .RdMEM(RdMEMout), .Rm(instruction_Reg[20:16]), 
	.Rn(instruction_Reg[9:5]), .DAddr9(DAddr9), .ALUImm12(ALUImm12),.Zero, .Negative, .overflow, .carry_out, 
	.DbResult, .read_enable(read_enableEX), .clk(clk), .Da, .Db, .ReadData1out, .ReadData2out, .ALUresult, .ALUresultDataMem, .WriteDataMem(WriteDataout),.MemDout, .MemData, .ALUresultWB,
	.forwardA(forwardA), .forwardB(forwardB), .ChooseRd(ChooseRdMEM));	
	// Rm(instruction_Reg[20:16]), .Rmout(RmID), .Rn(instruction_Reg[9:5]),
endmodule

module CPU_testbench();

	parameter ClockDelay = 50000;

	logic	clk, reset;
	
	CPU dut (clk,reset);
	
	initial begin // Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end
	
	integer i;
	initial begin
		reset <= 1'b1;
		@(posedge clk); 
		reset <= 1'b0;
		for (i=0; i <= 50; i++) begin
			@(posedge clk); 
		end
		$stop;
		
	end
endmodule
