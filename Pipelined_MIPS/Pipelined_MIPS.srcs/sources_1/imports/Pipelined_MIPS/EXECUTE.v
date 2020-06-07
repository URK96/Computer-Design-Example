
module EXECUTE(
	input clk,
	input RegDst, ALUOp1, ALUOp0, ALUSrc, Branch, MemRead, MemWrite, RegWrite, MemToReg,
	input [5:0] Opcode,
	input [4:0] Instruction_20to16, Instruction_15to11,
	input [31:0] PC_Plus4,
	input [31:0] ReadData_1, ReadData_2,
	input [31:0] Sign_Extend,
	output reg oBranch, oMemRead, oMemWrite, oRegWrite, oMemToReg,
	output reg [31:0] oBranchAddress,
	output reg [31:0] oALU_Result,
	output reg orBranch,
	output reg [31:0] oWriteData,
	output reg [4:0] oInstruction_RegDst
);

	wire [4:0] Instruction_RegDst;
	wire [31:0] ALU_Input2;
	wire [31:0] wShiftedAddress;
	wire [31:0] wBranchAddress;
	wire [3:0] wALU_Control;
	wire [31:0] wALU_Result;
	wire wZero, wrBranch;

	Mux5bit_2to1 Mux_RegDst(.sel(RegDst), .in0(Instruction_20to16), .in1(Instruction_15to11), .out_mux(Instruction_RegDst));

	Mux32bit_2to1 Mux_ALU_Input2(.sel(ALUSrc), .in0(ReadData_2), .in1(Sign_Extend), .out_mux(ALU_Input2));

	Shift_Left_2Bit BranchAddress(.Input(Sign_Extend), .Output(wShiftedAddress));

	Adder_32Bit Adder_BranchAddress(.In_A(PC_Plus4), .In_B(wShiftedAddress), .Output(wBranchAddress));

	ALU_Control ALUControl(.ALUOp({ALUOp1,ALUOp0}), .Opcode(Opcode), .FuncCode(Sign_Extend[5:0]), .ALUControl(wALU_Control));

	ALU ALU1(.ALU_Control(wALU_Control), .ALU_Input1(ReadData_1), .ALU_Input2(ALU_Input2), .ALU_Result(wALU_Result), .Zero(wZero));

	// pipeline regisger
	always @(posedge clk)
	begin
		oBranch <= Branch;
		oMemRead <= MemRead;
		oMemWrite <= MemWrite;
		oRegWrite <= RegWrite;
		oMemToReg <= MemToReg;
		
		oBranchAddress <= wBranchAddress;
		oALU_Result <= wALU_Result;
		orBranch <= wrBranch;
		oWriteData <= ReadData_2;
		oInstruction_RegDst <= Instruction_RegDst;
		oBranchAddress <= wBranchAddress;
	end
	
	assign wrBranch = ((wZero & (Opcode==6'b000100)) || (~wZero & (Opcode==6'b000101)));

endmodule

module ALU_Control(
	input [1:0] ALUOp,
	input [5:0] Opcode, FuncCode,
	output reg [3:0] ALUControl
);

	always @(ALUOp, FuncCode)
	begin
		if(ALUOp==2'b00)
		begin
		    case(Opcode)
		          6'b001101: ALUControl <= 4'b0001; // ori
		          6'b001100: ALUControl <= 4'b0000; // andi
		          6'b001010: ALUControl <= 4'b0111; // slti
		          default: ALUControl <= 4'b0010; // lw, sw, addi
		    endcase
		end
		else if(ALUOp==2'b01)
		begin
		    ALUControl <= 4'b0110; // 01일때는 beq, bne --> sub
		end
		else if(ALUOp==2'b10) // 10일때는 R-type
		begin
		  case(FuncCode)
		          6'b100000: ALUControl <= 4'b0010; // add
		          6'b100010: ALUControl <= 4'b0110; // sub
		          6'b100001: ALUControl <= 4'b0011; // mul
		          6'b100011: ALUControl <= 4'b0100; // div
		          6'b100100: ALUControl <= 4'b0000; // and
		          6'b100101: ALUControl <= 4'b0001; // or
		          6'b101010: ALUControl <= 4'b0111; // slt
		          default: ALUControl <= 4'bxxxx; // 예외상황에는 don't care
		    endcase
		end	
		else
		begin 
            ALUControl <= 4'bxxxx; // 11일때는 don't care
        end
    // ALUOp, FuncCode에 따른 ALUControl 조작부. 상단부 예시 참조해주세요
	end
endmodule


module ALU(
	input [3:0] ALU_Control,
	input [31:0] ALU_Input1, ALU_Input2,
	output reg [31:0] ALU_Result,
	output Zero
);

	always @(ALU_Control, ALU_Input1, ALU_Input2)
	begin
		if(ALU_Control == 4'b0010)  						// add
		begin
			ALU_Result = ALU_Input1 + ALU_Input2;
		end
		else if(ALU_Control == 4'b0110)						// sub
		begin	
			ALU_Result = ALU_Input1 - ALU_Input2;
		end
		else if (ALU_Control == 4'b0011)                    // mul
		begin
		    ALU_Result = ALU_Input1 * ALU_Input2;
		end
		else if (ALU_Control == 4'b0100)                    // div
		begin
		    ALU_Result = ALU_Input1 / ALU_Input2;
		end
		else if(ALU_Control == 4'b0000)						// and
		begin
			ALU_Result = ALU_Input1 & ALU_Input2;
		end
		else if(ALU_Control == 4'b0001)						// or
		begin	
			ALU_Result = ALU_Input1 | ALU_Input2;
		end
		else if(ALU_Control == 4'b0111)						// slt
		begin	
			ALU_Result = (ALU_Input1 < ALU_Input2) ? 1'b1 : 1'b0;
	    end
	end

	assign Zero = (ALU_Result == 32'h00000000) ? 1'b1 : 1'b0;

endmodule
