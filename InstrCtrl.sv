// datapath for instruction and program counter
module InstrCtrl(clk, reset, DbResult, instruction, BrTaken, UncondBr, CondAddr19, BrAddr26,NextAddr, PCaddr_IF, PCaddr_Reg); // output PCaddr
	input logic clk, reset, UncondBr;
	input logic [63:0] DbResult;
	input logic [1:0] BrTaken;
	input logic [18:0] CondAddr19;
	input logic [25:0] BrAddr26;
	output logic [31:0] instruction;
	output logic [63:0] NextAddr,PCaddr_IF; 
	wire co1, co2;
	logic [63:0] addr, CondAddr, BrAddr, addr1, addr2,postPCaddr;	
	
	input logic [63:0] PCaddr_Reg;
	
	assign NextAddr = addr2;

	SE_19 se19(.in(CondAddr19), .out(CondAddr));
	SE_26 se26(.in(BrAddr26), .out(BrAddr));

	//alu result
	genvar i;
	generate
		for(i=0; i < 64; i++) begin : each
			mux2_1 m0 (.out(addr[i]), .i0(CondAddr[i]), .i1(BrAddr[i]), .sel(UncondBr)); // choose conditional/unconditional branch
			mux4_1 m1(.out(postPCaddr[i]), .i0(addr2[i]), .i1(addr1[i]), .i2(DbResult[i]), .i3(1'b0), .sel0(BrTaken[0]), .sel1(BrTaken[1])); // choose value for next PC address		
			D_FF dffpc(.q(PCaddr_IF[i]), .d(postPCaddr[i]), .reset(reset), .clk(clk)); // update program counter
		end   
	endgenerate

	Adder adder1(.A(addr), .B(PCaddr_Reg), .Ci(1'b0), .Co(co1), .S(addr1)); // if branch choose PCaddr_Reg
	Adder adder2(.A(PCaddr_IF), .B(64'h0000000000000004), .Ci(1'b0), .Co(co2), .S(addr2));
	
	instructmem instr(.address(PCaddr_IF), .instruction(instruction), .clk(clk)); // get instruction with PC address
endmodule
