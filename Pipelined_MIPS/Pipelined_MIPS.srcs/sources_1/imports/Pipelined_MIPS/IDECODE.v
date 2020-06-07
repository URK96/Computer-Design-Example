
module IDECODE(
	input clk,
	input RegWrite,
	input [31:0] Instruction, PC_Plus4,
	input [31:0] Dst_WB, WB_Data,
	output reg [5:0] oOpcode,
	output reg [4:0] oInstruction_20to16, oInstruction_15to11,
	output reg [31:0] oPC_Plus4,
	output reg [31:0] oReadData_1, oReadData_2,
	output reg [31:0] oSign_Extend
);

	wire [31:0] wReadData_1, wReadData_2, wSign_Extend;
	
	Registers RegFile(.RegWrite(RegWrite), .ReadRegister_1(Instruction[25:21]), .ReadRegister_2(Instruction[20:16]), 
							.WriteRegister(Dst_WB), .WriteData(WB_Data), .ReadData_1(wReadData_1), .ReadData_2(wReadData_2));
	
	Sign_Extend SignExtend(.Input(Instruction[15:0]), .Output(wSign_Extend));
	
	// pipeline regisger
	always @(posedge clk)
	begin
		oPC_Plus4 <= PC_Plus4;
		oOpcode <= Instruction[31:26];
		oInstruction_20to16 <= Instruction[20:16];
		oInstruction_15to11 <= Instruction[15:11];
		oReadData_1 <= wReadData_1;
		oReadData_2 <= wReadData_2;
		oSign_Extend <= wSign_Extend;
	end

endmodule

module Registers (
	input clk,
	input RegWrite,
	input [4:0] ReadRegister_1, ReadRegister_2,
	input [4:0] WriteRegister,
	input [31:0] WriteData,
	output reg [31:0] ReadData_1, ReadData_2
);

	reg [31:0] Register[0:31];
	
	initial
	begin
		//$readmemh("Top_RegFileData.dat", Register); // 레지스터 데이터가 들어있는 파일입니다
		Register[0] <= 32'h00000000; 
		Register[1] <= 32'h00000001;
		Register[2] <= 32'h00000002;
		Register[3] <= 32'h00000003;
		Register[4] <= 32'h00000004;
		Register[5] <= 32'h00000005;
		Register[6] <= 32'h00000006;
	end
	
	always @(*)
	begin
		if(RegWrite==1'b1)
		begin
			Register[WriteRegister] <= WriteData;
		end
	end

	always @(*)
	begin
		ReadData_1 <= Register[ReadRegister_1];
		ReadData_2 <= Register[ReadRegister_2];
	end
	
endmodule
