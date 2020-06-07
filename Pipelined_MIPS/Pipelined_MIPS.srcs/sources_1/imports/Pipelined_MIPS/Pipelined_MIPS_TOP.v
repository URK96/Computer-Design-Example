module Pipelined_MIPS_TOP(
	input clk, reset,
	output oRegDst, oALUOp1, oALUOp0, oALUSrc, oBranch, oMemRead, oMemWrite, oRegWrite, oMemToReg,
	output orBranch,
	output [31:0] oPC, oNextPC, oInstruction, oALU_Result, oWB_Data
);
	
	wire wPCSrc;	
	wire [31:0] oFETCH_Instruction, oFETCH_PC_Plus4;
	
	wire oCTL_RegDst, oCTL_ALUOp1, oCTL_ALUOp0, oCTL_ALUSrc, oCTL_Branch, oCTL_MemRead, oCTL_MemWrite, oCTL_RegWrite, oCTL_MemToReg;
	
	wire [31:0] oDEC_PC_Plus4, oDEC_ReadData1, oDEC_ReadData2, oDEC_SignExtend;
	wire [5:0] oOpcode;
	wire [4:0] oDEC_Inst_20to16, oDEC_Inst_15to11;
	
	wire oEXE_Branch, oEXE_MemRead, oEXE_MemWrite, oEXE_RegWrite, oEXE_MemToReg, oEXE_rBranch;
	wire [31:0] oEXE_BranchAddress, oEXE_ALU_Result, oEXE_WriteData;
	wire [4:0] oEXE_RegDst;
	
	wire oMEM_RegWrite, oMEM_MemToReg;	
	wire [4:0] oMEM_Instruction_RegDst;
	wire [31:0] oMEM_Address, oMEM_ReadData;
	
	wire [31:0] wWB_Data;
	
	assign oInstruction = oFETCH_Instruction;
	assign oNextPC = oFETCH_PC_Plus4;
	
	assign oRegDst = oCTL_RegDst;
	assign oALUOp1 = oCTL_ALUOp1;
	assign oALUOp0 = oCTL_ALUOp0;
	assign oALUSrc = oCTL_ALUSrc;
	assign oBranch = oCTL_Branch;
	assign oMemRead = oCTL_MemRead;
	assign oMemWrite = oCTL_MemWrite;
	assign oRegWrite = oCTL_RegWrite;
	assign oMemToReg = oCTL_MemToReg;
	
	assign oALU_Result = oEXE_ALU_Result;
	assign oWB_Data = wWB_Data;
	assign orBranch = oEXE_rBranch;
	
	
	IFETCH IFETCH1(.clk(clk), .reset(reset), .PCSrc(wPCSrc), .Branch_Address(oEXE_BranchAddress), .oInstruction(oFETCH_Instruction), .oPC_Plus4(oFETCH_PC_Plus4), .oPC(oPC));
	

	IDECODE IDECODE1(.clk(clk), .RegWrite(oMEM_RegWrite), .Instruction(oFETCH_Instruction), .PC_Plus4(oFETCH_PC_Plus4), .Dst_WB(oMEM_Instruction_RegDst), .WB_Data(wWB_Data),
				.oOpcode(oOpcode), .oInstruction_20to16(oDEC_Inst_20to16), .oInstruction_15to11(oDEC_Inst_15to11), .oPC_Plus4(oDEC_PC_Plus4), 
				.oReadData_1(oDEC_ReadData1), .oReadData_2(oDEC_ReadData2), .oSign_Extend(oDEC_SignExtend));


	CONTROL CONTROL1(.clk(clk), .Instruction(oFETCH_Instruction), .RegDst(oCTL_RegDst), .ALUOp1(oCTL_ALUOp1), .ALUOp0(oCTL_ALUOp0), .ALUSrc(oCTL_ALUSrc), 
				.Branch(oCTL_Branch), .MemRead(oCTL_MemRead), .MemWrite(oCTL_MemWrite), .RegWrite(oCTL_RegWrite), .MemToReg(oCTL_MemToReg));


	EXECUTE EXECUTE1(.clk(clk), .RegDst(oCTL_RegDst), .ALUOp1(oCTL_ALUOp1), .ALUOp0(oCTL_ALUOp0), .ALUSrc(oCTL_ALUSrc), 
				.Branch(oCTL_Branch), .MemRead(oCTL_MemRead), .MemWrite(oCTL_MemWrite), .RegWrite(oCTL_RegWrite), .MemToReg(oCTL_MemToReg), .Opcode(oOpcode),
				.Instruction_20to16(oDEC_Inst_20to16), .Instruction_15to11(oDEC_Inst_15to11), .PC_Plus4(oDEC_PC_Plus4), 
				.ReadData_1(oDEC_ReadData1), .ReadData_2(oDEC_ReadData2), .Sign_Extend(oDEC_SignExtend),
				.oBranch(oEXE_Branch), .oMemRead(oEXE_MemRead), .oMemWrite(oEXE_MemWrite), .oRegWrite(oEXE_RegWrite), .oMemToReg(oEXE_MemToReg), .oBranchAddress(oEXE_BranchAddress), 
				.oALU_Result(oEXE_ALU_Result), .orBranch(oEXE_rBranch), .oWriteData(oEXE_WriteData), .oInstruction_RegDst(oEXE_RegDst));

	assign wPCSrc = oEXE_Branch & oEXE_rBranch;

	DMEMORY DMEMORY1(.clk(clk), .MemRead(oEXE_MemRead), .MemWrite(oEXE_MemWrite), .RegWrite(oEXE_RegWrite), .MemToReg(oEXE_MemToReg), 
				.Address(oEXE_ALU_Result), .WriteData(oEXE_WriteData), .Instruction_RegDst(oEXE_RegDst),
				.oRegWrite(oMEM_RegWrite), .oMemToReg(oMEM_MemToReg), .oAddress(oMEM_Address), .oReadData(oMEM_ReadData), .oInstruction_RegDst(oMEM_Instruction_RegDst));

	Mux32bit_2to1 Mux_WBData(.sel(oMEM_MemToReg), .in0(oMEM_Address), .in1(oMEM_ReadData), .out_mux(wWB_Data));

endmodule
