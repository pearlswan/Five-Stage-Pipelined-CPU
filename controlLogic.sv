// use combinational logic to set all control signals 
`timescale 1ps/1ps
module controlLogic(instruction,Zero, NegativeFlag, overflowFlag,Reg2Loc,ALUSrc,MemToReg,RegWrite,MemWrite,BrTaken,UncondBr,ALUOp, read_enable, flags_we,clk, reset, forwarden, ChooseRd); // Reg2loc
	input logic [31:0] instruction;
	input logic Zero,NegativeFlag,overflowFlag,clk, reset;
	output logic [1:0] ALUSrc, BrTaken,MemToReg;
	output logic Reg2Loc,RegWrite,MemWrite,UncondBr, read_enable, flags_we, forwarden, ChooseRd;
	output logic [2:0] ALUOp;
	logic bLT;
	
	xor #50 (bLT, NegativeFlag, overflowFlag);
	always_comb begin
		if (instruction[31:21] == 11'b10101011000 ) begin // adds 
			Reg2Loc = 1'b1;
			ALUSrc = 2'b00;
			MemToReg = 2'b00;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			BrTaken = 2'b00;
			UncondBr = 1'bx;
			ALUOp = 3'b010;
			read_enable = 1'b0;
			flags_we = 1'b1;
			forwarden = 1'b1;
			ChooseRd = 1'b1;
		end else if (instruction[31:22] == 10'b1001000100) begin // addi 
			Reg2Loc = 1'bx;
			ALUSrc = 2'b10;
			MemToReg = 2'b00;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			BrTaken = 2'b00;
			UncondBr = 1'bx;
			ALUOp = 3'b010;	
			read_enable = 1'b0;
			flags_we = 1'b0;
			forwarden = 1'b0;
			ChooseRd = 1'b1;
		end else if (instruction[31:21] == 11'b11101011000) begin // subs
			Reg2Loc = 1'b1;
			ALUSrc = 2'b00;
			MemToReg = 2'b00;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			BrTaken = 2'b00;
			UncondBr = 1'bx;
			ALUOp = 3'b011;
			read_enable = 1'b0;
			flags_we = 1'b1;
			forwarden = 1'b1;
			ChooseRd = 1'b1;
		end else if (instruction[31:21] == 11'b11111000010) begin// ldur
			Reg2Loc = 1'bx;
			ALUSrc = 2'b01;
			MemToReg = 2'b01;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			BrTaken = 2'b00;
			UncondBr = 1'bx;
			ALUOp = 3'b010;
			read_enable = 1'b1;
			flags_we = 1'b0;
			forwarden = 1'b0;
			ChooseRd = 1'b1;
		end else if (instruction[31:21] == 11'b11111000000) begin // sdur
			Reg2Loc = 1'b0;
			ALUSrc = 2'b01;
			MemToReg = 2'b0x;
			RegWrite = 1'b0;
			MemWrite = 1'b1;
			BrTaken = 2'b00;
			UncondBr = 1'bx;
			ALUOp = 3'b010;
			read_enable = 1'b0;
			flags_we = 1'b0;
			forwarden = 1'b0;
			ChooseRd = 1'b0;
		end else if (instruction[31:26] == 6'b000101) begin // b
			Reg2Loc = 1'bx;
			ALUSrc = 2'bxx;
			MemToReg = 2'b0x;
			RegWrite = 1'b0;
			MemWrite = 1'b0;
			BrTaken = 2'b01;
			UncondBr = 1'b1;
			ALUOp = 3'bxxx;
			read_enable = 1'b0;
			flags_we = 1'b0;
			forwarden = 1'b0;
			ChooseRd = 1'bx;
		end else if (instruction[31:24] == 8'b01010100 && instruction[4:0] == 5'b01011) begin // b.LT 
			Reg2Loc = 1'b0;
			ALUSrc = 2'b00;
			MemToReg = 2'b0x;
			RegWrite = 1'b0;
			MemWrite = 1'b0;
			BrTaken = {1'b0,bLT};
			UncondBr = 1'b0;
			ALUOp = 3'b000;	
			read_enable = 1'b0;
			flags_we = 1'b0;
			forwarden = 1'b0;
			ChooseRd = 1'bx;
		end else if (instruction[31:24] == 8'b10110100) begin // cbz
			Reg2Loc = 1'b0;
			ALUSrc = 2'b00;
			MemToReg = 2'b0x;
			RegWrite = 1'b0;
			MemWrite = 1'b0;
			BrTaken = {1'b0,Zero};
			UncondBr = 1'b0;
			ALUOp = 3'b000;
			read_enable = 1'b0;
			flags_we = 1'b0;
			forwarden = 1'b0;
			ChooseRd = 1'bx;
		end else if (instruction[31:21] == 11'b11010110000) begin // br  PC = Reg[Rd]. 
			Reg2Loc = 1'b0;
			ALUSrc = 2'bxx;
			MemToReg = 2'b00;
			RegWrite = 1'b0;
			MemWrite = 1'b0;
			BrTaken = 2'b10;
			UncondBr = 1'bx;
			ALUOp = 3'bxxx;
			read_enable = 1'b0;
			flags_we = 1'b0;
			forwarden = 1'b0; //????
			ChooseRd = 1'b0; //??/
		end else if (instruction[31:26] == 6'b100101) begin //bl
			Reg2Loc = 1'bx;
			ALUSrc = 2'bxx;
			MemToReg = 2'b10;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			BrTaken = 2'b01;
			UncondBr = 1'b1;
			ALUOp = 3'bxxx;
			read_enable = 1'b0;
			flags_we = 1'b0;
			forwarden = 1'b0; //?????
			ChooseRd = 1'b1;
		end else begin // default
			Reg2Loc = 1'bx;
			ALUSrc = 2'bxx;
			MemToReg = 2'bxx;
			RegWrite = 1'b0;
			MemWrite = 1'b0;
			BrTaken = 2'b00;
			UncondBr = 1'bx;
			ALUOp = 3'bxxx;
			read_enable = 1'bx;
			flags_we = 1'b0;
			forwarden = 1'bx;
			ChooseRd = 1'b1; //?
		end
	end
endmodule
