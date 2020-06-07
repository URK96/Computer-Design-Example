module ALUControl(
	input [1:0] ALUOp,
	input [5:0] Funct, Opcode,
	output reg[3:0] Operation
);

	always @ (ALUOp, Funct)
	begin
	// Fill the blank 
		if(ALUOp == 2'b00) 
		begin
			 Operation <= 4'b0010;					// for lw , sw
		end
		else if(ALUOp == 2'b01) 
		begin
			Operation <= 4'b0110;				// for beq
		end
		else if(ALUOp == 2'b10)						// for R-Type
		begin
		  if(Funct == 6'b100000) 
		  begin
		      Operation <= 4'b0010;				// for add
		  end
		  else if( Funct == 6'b100010 )  
		  begin
		      Operation <= 4'b0110;
		  end				// for sub
		  else if(Funct == 6'b100001)
		  begin
		      Operation <= 4'b1000;           // for mul
		  end
			
			if( Funct == 6'b100100) 
			begin
				Operation <= 4'b0000;					// for and
			end
			if(Funct==6'b100101)
			begin
				Operation <= 4'b0001;				// for or
			end
			if(Funct == 6'b101010 ) 
			begin
				Operation <= 4'b0111;			// for slt
			end
			if(Funct==6'b100111) 
			begin
				Operation <= 4'b1100;					// for nor
			end
			if(Funct==6'b100110)
			begin
				Operation <= 4'b0011;					// for xor
			end
		end
	
		if(Opcode == 6'b001000) 	
		begin 
			Operation <= 4'b0010;					// for add immediate
		end
	end

endmodule
