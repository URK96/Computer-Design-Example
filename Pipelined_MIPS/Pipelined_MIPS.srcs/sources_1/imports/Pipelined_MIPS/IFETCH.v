
module IFETCH(
	input clk, reset,
	input PCSrc,
	input [31:0] Branch_Address,
	output reg [31:0] oInstruction, oPC_Plus4, oPC
);

	reg [31:0] PC = 32'h00000000;
	wire [31:0] wNext_PC, wPC_Plus4, wInstruction;	

	Mux32bit_2to1 SelPC(.sel(PCSrc), .in0(wPC_Plus4), .in1(Branch_Address), .out_mux(wNext_PC));

	Adder_32Bit PC_Plus4(.In_A(PC), .In_B(32'h00000004), .Output(wPC_Plus4));
	
	InstructionMemory InstMem(.ReadAddress(PC), .Instruction(wInstruction));
	
	always @(negedge clk or negedge reset)
//	always @(posedge clk or negedge reset)
	begin
		if(reset==1'b0)
		begin
			PC <= 32'h00000000;
		end
		else
		begin
			PC <= wNext_PC;
		end
	end
	
	// pipeline regisger
	always @(posedge clk)
	begin
		oPC_Plus4 <= wPC_Plus4;
		oInstruction <= wInstruction;
		
		oPC <= PC;								// for debug
	end
	
endmodule
