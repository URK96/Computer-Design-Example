
module MultiCycle_MIPS_TOP(
	input clk, Reset,
	output oPCWriteCond, oPCWrite, olorD, oMemRead, oMemWrite, oMemtoReg, oIRWrite, oALUSrcA, oRegWrite, oRegDst,
	output [1:0] oALUOp, oALUSrcB, oPCSource,
	output [31:0] oInst, oAlu_out,
	output reg [31:0] PC,
	output [2:0] oCycle,
	output [3:0] oState
);

	// control variables
	wire [1:0] ALUOp, ALUSrcB, PCSource;
	wire PCWriteCond, PCWrite, lorD, MemRead, MemWrite, MemtoReg, IRWrite, ALUSrcA, RegWrite, RegDst;

	// data path wires
	wire [31:0] pcmuxout, MemData, IROut, MDROut, MDRMux, SignExtendOut, SES4Out, RD1, RD2, ARegOut, BRegOut, AMuxOut, BMuxOut, ALUResult, ALURegOut, nextpc, pcshift2out;
	wire [4:0] instructionmuxout;

	// for test
	wire [2:0] wCycle;
	assign oCycle = wCycle;
	wire [3:0] wState;
	assign oState = wState;
	
	
	assign oALUOp = ALUOp;
	assign oALUSrcB = ALUSrcB;
	assign oPCSource = PCSource;

	assign oPCWriteCond = PCWriteCond;
	assign oPCWrite = PCWrite;
	assign olorD = lorD;
	assign oMemRead = MemRead;
	assign oMemWrite = MemWrite;
	assign oMemtoReg = MemtoReg;
	assign oIRWrite = IRWrite;
	assign oALUSrcA = ALUSrcA;
	assign oRegWrite = RegWrite;
	assign oRegDst = RegDst;

	assign oInst = IROut;
	assign oAlu_out = ALURegOut;

	//stuff to update PC
	wire PCWriteEnable;
	wire tempPCvar;

	//pcMux
	assign pcmuxout = lorD ? ALURegOut : PC;

	//memory
	DataMemory DataMemory1(.clk(clk), .MemRead(MemRead), .MemWrite(MemWrite), .Address(pcmuxout), .WriteData(BRegOut), .MemData(MemData));

	//Instruction register
	IR IR1(.CLK(clk), .IRWrite(IRWrite), .DataIn(MemData), .DataOut(IROut));

	//Memory Data Register
	Register MDR1(.CLK(clk), .DataIn(MemData), .DataOut(MDROut));

	//Controller
	controller Control1(.clk(clk), .Reset(Reset), .Op(IROut[31:26]), .ALUOp(ALUOp), .ALUSrcB(ALUSrcB), .PCSource(PCSource), 
								.PCWriteCond(PCWriteCond), .PCWrite(PCWrite), .lorD(lorD), .MemRead(MemRead), .MemWrite(MemWrite), .MemtoReg(MemtoReg), 
								.IRWrite(IRWrite), .ALUSrcA(ALUSrcA), .RegWrite(RegWrite), .RegDst(RegDst), .oState(wState), .oCycle(wCycle));

	//instruction decoding
	assign instructionmuxout = RegDst ? IROut[15:11] : IROut[20:16];
	assign MDRMux = MemtoReg ? MDROut : ALURegOut;

	//Registers
	RegFile registers(.CLK(clk), .WE(RegWrite), .RA(IROut[25:21]), .RB(IROut[20:16]), .W(instructionmuxout), .WD(MDRMux), .RDA(RD1), .RDB(RD2));
	Register A(.CLK(clk), .DataIn(RD1), .DataOut(ARegOut));
	Register B(.CLK(clk), .DataIn(RD2), .DataOut(BRegOut));

	// sign extend and shift 2;
	SignExtend SE1(.In(IROut[15:0]), .Out(SignExtendOut));
	assign SES4Out = SignExtendOut << 2;

	//muxes for ALU input
	assign AMuxOut= ALUSrcA ? ARegOut : PC;
	Four2One Bmux(.Control(ALUSrcB), .A(BRegOut), .B(32'd4), .C(SignExtendOut), .D(SES4Out), .Out(BMuxOut));

	//ALU controller and ALU
	wire [3:0] Operation;
	ALUControl ALUControl1(.Opcode(IROut[31:26]), .ALUOp(ALUOp), .Funct(IROut[5:0]), .Operation(Operation));
	ALU alu1(.DataA(AMuxOut), .DataB(BMuxOut), .Operation(Operation), .ALUResult(ALUResult), .Zero(zero));
	Register aluout1(.CLK(clk), .DataIn(ALUResult), .DataOut(ALURegOut));


	//jump stuff
	wire [31:0] jumpaddress;
	wire [27:0] jumpaddresstemp;
	assign jumpaddresstemp = IROut[25:0] << 2;
	assign jumpaddress= {PC[31:28],jumpaddresstemp[27:0]};
	Four2One muxfour2one1(.Control(PCSource), .A(ALUResult), .B(ALURegOut), .C(jumpaddress), .D(jumpaddress), .Out(nextpc));

	//updating pc
	assign tempPCvar=zero&PCWriteCond;
	assign PCWriteEnable=tempPCvar|PCWrite;
	always@ (posedge clk)
	begin
		if(PCWriteEnable==1'b1)
		begin
			PC <= nextpc;
		end
	end

endmodule
