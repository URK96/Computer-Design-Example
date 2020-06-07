
module CONTROL(
	input clk,
	input [31:0] Instruction,
	output RegDst, ALUOp1, ALUOp0, ALUSrc, Branch, MemRead, MemWrite, RegWrite, MemToReg
);

	wire [5:0] Opcode;
	reg R, Lw, Sw, Beq, Bne, J, I;

	assign Opcode = Instruction[31:26];

	always @(posedge clk)
	begin
		if(Opcode==6'b000000)
			R = 1;
		else
			R = 0;
			
		if(Opcode==6'b100011) // LW를 결정합니다. 참고자료 4번째 사진 이용
			Lw = 1;
		else
			Lw = 0;
			
		if(Opcode==6'b101011) // SW를 결정합니다. 참고자료 4번째 사진 이용
			Sw = 1;
		else
			Sw = 0;
			
		if(Opcode==6'b000100) // Beq를 결정합니다. 참고자료 4번째 사진 이용
			Beq = 1;
		else
			Beq = 0;
			
		if(Opcode==6'b000101) // Bne를 결정합니다. 참고자료 4번째 사진 이용
			Bne = 1;
		else
			Bne = 0;
			
		if(Opcode==6'b000010) // J-Type을 결정합니다. 참고자료 4번째 사진 이용
			J = 1;
		else
			J = 0;
			
		if((Opcode==6'b001000)||(Opcode==6'b001100)||(Opcode==6'b001101)||(Opcode==6'b001010)) // I-Type을 결정합니다. Opcode가 4종류 있습니다.
			I = 1; // addi, andi, ori, slti
		else
			I = 0;
	end

	assign RegDst = R;
	assign ALUOp1 = R;
	assign ALUOp0 = Beq || Bne;
	assign ALUSrc = Lw || Sw || I;
	assign Branch = Beq || Bne;
	assign MemRead = Lw;
	assign MemWrite = Sw;
	assign RegWrite = R || Lw || I;
	assign MemToReg = Lw;

endmodule
