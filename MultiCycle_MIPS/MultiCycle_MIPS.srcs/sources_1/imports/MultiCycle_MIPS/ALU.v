module ALU(
	input [31:0] DataA, DataB,
	input [3:0] Operation,
	output reg [31:0] ALUResult,
	output reg Zero
);

	always @ (Operation, DataA, DataB) 
	// Fill the Blank
	begin
		if(	Operation == 4'b0010) 
		begin
			ALUResult <= DataA + DataB; // DataA+DataB
		end
		if(	Operation == 4'b0110) 
		begin
			ALUResult <= DataA - DataB; // DataA-DataB
		end
		if (Operation == 4'b1000)
		begin
		    ALUResult <= DataA * DataB; // DataA*DataB
		end
		if(	Operation == 4'b0000) 
		begin
			ALUResult <= DataA & DataB; // DataA&DataB
		end
		if(	Operation == 4'b0001) 
		begin
			ALUResult <= DataA | DataB; // DataA|DataB
		end
		if(	Operation == 4'b0111) 
		begin
			if(DataB>DataA) 
				ALUResult <= 1;
			if(DataB<=DataA) 
				ALUResult <= 0;
		end
		if(Operation== 4'b1100) 
		begin
			ALUResult <= ~(DataA|DataB);
		end
		if(Operation== 4'b0011) 
		begin
			ALUResult <= DataA ^ DataB; // DataA^DataB
		end
		if(DataA==DataB) 
		begin
			Zero<=1'b1;
		end
		else
		begin
			Zero<=1'b0;
		end
	end

endmodule
