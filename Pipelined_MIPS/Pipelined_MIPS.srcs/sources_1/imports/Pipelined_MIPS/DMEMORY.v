
module DMEMORY(
	input clk,
	input MemRead, MemWrite, RegWrite, MemToReg,
	input [31:0] Address, WriteData,
	input [4:0] Instruction_RegDst,
	output reg oRegWrite, oMemToReg,
	output reg [31:0] oAddress, oReadData,
	output reg [4:0] oInstruction_RegDst
);
	
	wire [31:0] wReadData;
	
	DataMemory DMemory(.MemRead(MemRead), .MemWrite(MemWrite), .Address(Address), .WriteData(WriteData), .ReadData(wReadData));
	
	// pipeline regisger
	always @(posedge clk)
	begin
		oRegWrite <= RegWrite;
		oMemToReg <= MemToReg;
		
		oAddress <= Address;
		oInstruction_RegDst <= Instruction_RegDst;
		oReadData <= wReadData;
	end

endmodule


module DataMemory(
	input MemRead, MemWrite,
	input [31:0] Address, WriteData,
	output [31:0] ReadData
);

	reg [31:0] DataMemory[0:255];

	initial
	begin
		// $readmemh("Top_DataMemory.dat", DataMemory); // 데이터 메모리 읽어오는 부분
		DataMemory[0] <= 32'h00000004;
        DataMemory[1] <= 32'h00000040;
        DataMemory[2] <= 32'h00000400;
        DataMemory[3] <= 32'h00000444;
        DataMemory[4] <= 32'h00000080;
        DataMemory[5] <= 32'h00000008;
        DataMemory[6] <= 32'h00000000;
        DataMemory[7] <= 32'h00000001;
        DataMemory[8] <= 32'h00000000;
        DataMemory[8] <= 32'h00000000;
        DataMemory[9] <= 32'h00000000;
        DataMemory[10] <= 32'h00000000;
        DataMemory[11] <= 32'h00000000;
        DataMemory[12] <= 32'h00000000;
        DataMemory[13] <= 32'h00000000;
        DataMemory[14] <= 32'h00000000;
        DataMemory[15] <= 32'h00000000;
	end

	assign ReadData = (MemRead) ? DataMemory[Address[7:0]] : 32'hxxxxxxxx;

	always @(*)
	begin
		if(MemWrite) 
			DataMemory[Address] <= WriteData;
	end


endmodule
