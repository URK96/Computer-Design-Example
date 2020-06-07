
module tb_Pipelined_MIPS_TOP();

	// Inputs
	reg clk;
	reg reset;

	// Outputs
	wire oRegDst;
	wire oALUOp1;
	wire oALUOp0;
	wire oALUSrc;
	wire oBranch;
	wire oMemRead;
	wire oMemWrite;
	wire oRegWrite;
	wire oMemToReg;
	wire [31:0] oPC;
	wire [31:0] oNextPC;
	wire [31:0] oInstruction;
	wire [31:0] oALU_Result;
	wire orBranch;
	wire [31:0] oWB_Data;

	// Instantiate the Unit Under Test (UUT)
	Pipelined_MIPS_TOP MIPS(
		.clk(clk), 
		.reset(reset), 
		.oRegDst(oRegDst), 
		.oALUOp1(oALUOp1), 
		.oALUOp0(oALUOp0), 
		.oALUSrc(oALUSrc), 
		.oBranch(oBranch), 
		.oMemRead(oMemRead), 
		.oMemWrite(oMemWrite), 
		.oRegWrite(oRegWrite), 
		.oMemToReg(oMemToReg), 
		.orBranch(orBranch),
		.oPC(oPC),
		.oNextPC(oNextPC), 
		.oInstruction(oInstruction), 
		.oALU_Result(oALU_Result), 
		.oWB_Data(oWB_Data)	
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
		reset = 1'b1;
		#3 reset = 1'b0;
		#10 reset = 1'b1;
	end

   // Define Clock
	initial
	begin
		clk = 0;
		forever #5 clk = ~clk;
	end
	
	
	initial
	begin
		#1000 $stop;
	end
      
endmodule

