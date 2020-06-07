module tb_top_MultiCycle_MIPS();

	// Inputs
	reg clk;
	reg Reset;

	// Outputs
	wire oPCWriteCond;
	wire oPCWrite;
	wire olorD;
	wire oMemRead;
	wire oMemWrite;
	wire oMemtoReg;
	wire oIRWrite;
	wire oALUSrcA;
	wire oRegWrite;
	wire oRegDst;
	wire [1:0] oALUOp;
	wire [1:0] oALUSrcB;
	wire [1:0] oPCSource;
	wire [31:0] oInst;
	wire [31:0] oAlu_out;
	wire [31:0] PC;
	
	wire [2:0] oCycle;
	wire [3:0] oState;

	// Instantiate the Unit Under Test (UUT)
	MultiCycle_MIPS_TOP MIPS(
		.clk(clk), 
		.Reset(Reset), 
		.oPCWriteCond(oPCWriteCond), 
		.oPCWrite(oPCWrite), 
		.olorD(olorD), 
		.oMemRead(oMemRead), 
		.oMemWrite(oMemWrite), 
		.oMemtoReg(oMemtoReg), 
		.oIRWrite(oIRWrite), 
		.oALUSrcA(oALUSrcA), 
		.oRegWrite(oRegWrite), 
		.oRegDst(oRegDst), 
		.oALUOp(oALUOp), 
		.oALUSrcB(oALUSrcB), 
		.oPCSource(oPCSource), 
		.oInst(oInst), 
		.oAlu_out(oAlu_out), 
		.PC(PC),
		.oCycle(oCycle),
		.oState(oState)
	);

	// Using VCS
	initial
	begin
		//$vcdplusfile("../waveform/top.vpd");
		//$vcdpluson;
		//$vcdplusmemon;
	end

	// Input Data Initialize
	initial
	begin
		Reset = 1'b1;
		#3 Reset = 1'b0;
		#10 Reset = 1'b1;
	end

   // Define Clock
	initial
	begin
		clk = 0;
		forever #5 clk = ~clk;
	end
		
	initial
	begin
		MIPS.PC = 124;															// first instruction in DataMemory.RegFile[124+4]
	
		MIPS.DataMemory1.RegFile[0] <= 32'd8;
		MIPS.DataMemory1.RegFile[1] <= 32'd1;
		MIPS.DataMemory1.RegFile[2] <= 32'd1;

		MIPS.DataMemory1.RegFile[128] <= 32'h8c030000;    
		MIPS.DataMemory1.RegFile[132] <= 32'h8c040001;    
		MIPS.DataMemory1.RegFile[136] <= 32'h8c050002;    
		MIPS.DataMemory1.RegFile[140] <= 32'h8c010002;    
		MIPS.DataMemory1.RegFile[144] <= 32'h10600006;    
		MIPS.DataMemory1.RegFile[148] <= 32'h20840004;    
		MIPS.DataMemory1.RegFile[152] <= 32'h00852020;   
		MIPS.DataMemory1.RegFile[156] <= 32'h00852822;    
		MIPS.DataMemory1.RegFile[160] <= 32'h00611820;   
		MIPS.DataMemory1.RegFile[164] <= 32'h2063fffb;    
		MIPS.DataMemory1.RegFile[168] <= 32'h1000fff9;   
		MIPS.DataMemory1.RegFile[172] <= 32'hac040006; 
		MIPS.DataMemory1.RegFile[176] <= 32'h8c060006;   
		MIPS.DataMemory1.RegFile[180] <= 32'h00c63821;    
		// Make more instruction set 
	end
		
		
	initial
	begin
		#1000 $stop;
	end
		
endmodule

