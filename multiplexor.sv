// defines a 32 multiplexor to select 64 bits
module multiplexor (RegIn, data, readReg);
	input logic [31:0] [63:0] RegIn;
	input [4:0] readReg;
	output [63:0] data;

	genvar i;
	generate     
		for(i=0; i < 64; i++) begin : eachMux      
			mux32_1 m(.out(data[i]), .in({RegIn[31][i], RegIn[30][i], RegIn[29][i], RegIn[28][i], RegIn[27][i], RegIn[26][i], 
											 RegIn[25][i], RegIn[24][i], RegIn[23][i], RegIn[22][i], RegIn[21][i], RegIn[20][i],
											 RegIn[19][i], RegIn[18][i], RegIn[17][i], RegIn[16][i], RegIn[15][i], RegIn[14][i], 
											 RegIn[13][i], RegIn[12][i], RegIn[11][i], RegIn[10][i], RegIn[9][i], RegIn[8][i], RegIn[7][i], 
											 RegIn[6][i], RegIn[5][i], RegIn[4][i], RegIn[3][i], RegIn[2][i], RegIn[1][i], RegIn[0][i]}), .sel(readReg));   
		end   
	endgenerate 
endmodule
