
module DataMemory(
	input clk,
	input MemRead, MemWrite, 
	input [31:0] Address, WriteData,
	output [31:0] MemData
);

	reg [31:0] RegFile [512:0];
	
	always @ (posedge clk) 
	begin
		if(MemWrite==1'b1)
		begin
			RegFile[Address] <= WriteData;
		end
	end
	
	assign MemData = (MemRead==1'b1)? RegFile[Address] : 0;

endmodule
