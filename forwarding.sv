module forwarding(RmID, RnID, RdEXout, RdMEMout, RegWriteEXout, RegWriteMEMout, forwardA, forwardB, forwarden);
	input logic [4:0] RdEXout, RdMEMout, RmID, RnID;
	input logic RegWriteEXout, RegWriteMEMout, forwarden;
	output logic [1:0] forwardA, forwardB;
	logic [4:0] forwardApost, forwardBpost; 
	
	always_comb begin
	
		if (RegWriteEXout == 1'b1 && RdEXout!= 5'b11111 && RdEXout == RnID) // forward from EX
			forwardA = 2'b10;
		else if (RegWriteMEMout == 1'b1 && RdMEMout!= 5'b11111 && RdMEMout == RnID && (RdEXout != RnID || RegWriteEXout == 1'b0)) // forward from MEM
			forwardA = 2'b01;
		else forwardA = 2'b00;
		
		if (forwarden == 1'b1 && RegWriteEXout == 1'b1 && RdEXout!= 5'b11111 && RdEXout == RmID) // forward from EX
			forwardB = 2'b10;
		else if (forwarden == 1'b1 && RegWriteMEMout == 1'b1 && RdMEMout!= 5'b11111 && RdMEMout == RmID && (RdEXout != RmID || RegWriteEXout == 1'b0)) // forward from MEM
			forwardB = 2'b01;
		else forwardB = 2'b00;
			
			
			
			/*
		if (RegWriteEXout == 1'b1 && RdEXout!= 5'b11111 && RdEXout == RnID) // forward from EX
			forwardA = 2'b10;
		else if (RegWriteMEMout == 1'b1 && RdMEMout != 5'b11111 && RdMEMout == RnID 
		&& !(RdEXout != RnID && RdEXout!= 5'b11111 && RegWriteEXout == 1'b1)) // forward from MEM
			forwardA = 2'b01;
		else forwardA = 2'b00;
		
		if (forwarden == 1'b1 && RegWriteEXout == 1'b1 && RdEXout!= 5'b11111 && RdEXout == RmID) // forward from EX
			forwardB = 2'b10;
		else if (forwarden == 1'b1 && RegWriteMEMout == 1'b1 && RdMEMout != 5'b11111 && RdMEMout == RmID 
		&& !(RdEXout != RmID && RdEXout!= 5'b11111 && RegWriteEXout == 1'b1)) // forward from MEM
			forwardB = 2'b01;
		else forwardB = 2'b00;
		*/
	end
//	genvar j;
//	generate
//		for(j=0; j < 32; j++) begin : each2
//			D_FF dff1(.q(forwardA[j]), .d(forwardApost[j]), .reset(1'b0), .clk(clk));
//			D_FF dff2(.q(forwardB[j]), .d(forwardBpost[j]), .reset(1'b0), .clk(clk));
//		end   
//	endgenerate
endmodule
