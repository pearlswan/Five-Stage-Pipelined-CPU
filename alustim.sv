// Test bench for ALU
`timescale 1ns/10ps

// Meaning of signals in and out of the ALU:

// Flags:
// negative: whether the result output is negative if interpreted as 2's comp.
// zero: whether the result output was a 64-bit zero.
// overflow: on an add or subtract, whether the computation overflowed if the inputs are interpreted as 2's comp.
// carry_out: on an add or subtract, whether the computation produced a carry-out.

// cntrl			Operation						Notes:
// 000:			result = B						value of overflow and carry_out unimportant
// 010:			result = A + B
// 011:			result = A - B
// 100:			result = bitwise A & B		value of overflow and carry_out unimportant
// 101:			result = bitwise A | B		value of overflow and carry_out unimportant
// 110:			result = bitwise A XOR B	value of overflow and carry_out unimportant


module alustim();

	parameter delay = 100000;

	logic		[63:0]	A, B;
	logic		[2:0]		cntrl;
	logic		[63:0]	result;
	logic					negative, zero, overflow, carry_out ;

	parameter ALU_PASS_B=3'b000, ALU_ADD=3'b010, ALU_SUBTRACT=3'b011, ALU_AND=3'b100, ALU_OR=3'b101, ALU_XOR=3'b110;
	

	alu dut (.A, .B, .cntrl, .result, .negative, .zero, .overflow, .carry_out);

	// Force %t's to print in a nice format.
	initial $timeformat(-9, 2, " ns", 10);

	integer i, j;
	logic [63:0] test_val;
	initial begin
	
		$display("%t testing PASS_A operations", $time);
		cntrl = ALU_PASS_B;
		for (i=0; i<100; i++) begin
			A = $random(); B = $random();
			#(delay);
			assert(result == B && negative == B[63] && zero == (B == '0));
		end
		
		$display("%t testing addition", $time);
		cntrl = ALU_ADD;
		A = 64'h0000000000000001; B = 64'h0000000000000001;
		#(delay);
		assert(result == 64'h0000000000000002 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 0);
		#(delay);
		for (i=0; i<16; i++) begin
			for (j=0; j<16; j++) begin
				A = A + 64'h000000000000000f;
				#(delay);
				assert(result == (A+B) && zero == (result == '0)); 
			end
			B = B + 64'h000000000000000f;
		end
		#(delay);
		A = 64'h7fffffffffffffff; B = 64'h0000000000000001;
		#(delay);
		assert(result == 64'h8000000000000000 && carry_out == 0 && overflow == 1 && negative == 1 && zero == 0);
		#(delay);
		
		$display("%t testing subtraction", $time);
		cntrl = ALU_SUBTRACT;
		A = 64'h0000000000000001; B = 64'h0000000000000001;
		#(delay);
		assert(result == 64'h0000000000000000 && carry_out == 1 && overflow == 0 && negative == 0 && zero == 1);
		#(delay);
		A = 64'h0000000000000001; B = 64'h0000000000000002;
		#(delay);
		assert(result == 64'hffffffffffffffff && carry_out == 0 && overflow == 0 && negative == 1 && zero == 0);
		#(delay);
		A = 64'h8000000000000000; B = 64'h0000000000000001;
		#(delay);
		assert(result == 64'h7fffffffffffffff && carry_out == 1 && overflow == 1 && negative == 0 && zero == 0);
		#(delay);

		$display("%t testing and", $time);
		cntrl = ALU_AND;
		A = 64'h0000000000000001; B = 64'h0000000000000001;
		#(delay);
		assert(result == 64'h0000000000000001 && negative == 0 && zero == 0);
		#(delay);
		A = 64'h0000000000000011; B = 64'h0000000000000011;
		#(delay);
		assert(result == 64'h0000000000000011 && negative == 0 && zero == 0);
		#(delay);
		A = 64'h0000000000001100; B = 64'h0000011000000001;
		#(delay);
		assert(result == 64'h0000000000000000 && negative == 0 && zero == 1);
		#(delay);
		A = 64'hf000000000000101; B = 64'hf000000000011010;
		#(delay);
		assert(result == 64'hf000000000000000 && negative == 1 && zero == 0);
		#(delay);

		$display("%t testing or", $time);
		cntrl = ALU_OR;
		A = 64'h0000000000000000; B = 64'h0000000000000000;
		#(delay);
		assert(result == 64'h0000000000000000 && negative == 0 && zero == 1);
		#(delay);
		A = 64'h0000000000000011; B = 64'h0000000000000001;
		#(delay);
		assert(result == 64'h0000000000000011 && negative == 0 && zero == 0);
		#(delay);
		A = 64'h0000000000000101; B = 64'h0000000000011011;
		#(delay);
		assert(result == 64'h0000000000011111 && negative == 0 && zero == 0);
		#(delay);
		A = 64'hf000000000000101; B = 64'h0000000000011011;
		#(delay);
		assert(result == 64'hf000000000011111 && negative == 1 && zero == 0);
		#(delay);
		A = 64'hf000000000000101; B = 64'hf000000000011010;
		#(delay);
		assert(result == 64'hf000000000011111 && negative == 1 && zero == 0);
		#(delay);

		$display("%t testing xor", $time);
		cntrl = ALU_XOR;
		A = 64'h0000000000000000; B = 64'h0000000000000000;
		#(delay);
		assert(result == 64'h0000000000000000 && negative == 0 && zero == 1);
		#(delay);
		A = 64'h0000000000000011; B = 64'h0000000000000001;
		#(delay);
		assert(result == 64'h0000000000000010 && negative == 0 && zero == 0);
		#(delay);
		A = 64'h0000000000000101; B = 64'h0000000000011011;
		#(delay);
		assert(result == 64'h0000000000011110 && negative == 0 && zero == 0);
		#(delay);
		A = 64'hf000000000000101; B = 64'h0000000000011011;
		#(delay);
		assert(result == 64'hf000000000011110 && negative == 1 && zero == 0);
		#(delay);
		A = 64'hf000000000000101; B = 64'hf000000000011010;
		#(delay);
		assert(result == 64'h0000000000011111 && negative == 0 && zero == 0);
		#(delay);

	end
endmodule
