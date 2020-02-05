module IF(PCaddr, instruction, PCaddrout,instructionOut, clk); // reset ? we?
	input logic clk;
	input logic [63:0] PCaddr;
	input logic [31:0] instruction;
	output logic [63:0] PCaddrout;
	output logic [31:0] instructionOut;

	genvar i;
	generate
		for(i=0; i < 64; i++) begin : each1
			D_FF dff1(.q(PCaddrout[i]), .d(PCaddr[i]), .reset(1'b0), .clk(clk)); 
		end   
	endgenerate
	
	genvar j;
	generate
		for(j=0; j < 32; j++) begin : each2
			D_FF dff2(.q(instructionOut[j]), .d(instruction[j]), .reset(1'b0), .clk(clk));
		end   
	endgenerate
	
endmodule
