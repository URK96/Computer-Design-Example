module controller (
	input clk, Reset,
	input [5:0] Op,
	output reg [1:0] ALUOp, ALUSrcB, PCSource,
	output reg PCWriteCond, PCWrite, lorD, MemRead, MemWrite, MemtoReg, IRWrite, ALUSrcA, RegWrite, RegDst,
	output [3:0] oState, 
	output reg [2:0] oCycle
);

	reg [3:0] state = 0;					// initial state
	reg [3:0] nextstate;

	parameter S0=0;
	parameter S1=1;
	parameter S2=2;
	parameter S3=3;
	parameter S4=4;
	parameter S5=5;
	parameter S6=6;
	parameter S7=7;
	parameter S8=8;
	parameter S9=9;
	parameter S10=10;
	parameter S11=11;
	parameter S12=12;
	parameter S13=13;

	// for test
	assign oState = state;

	always@(posedge clk, negedge Reset) 
	begin
		if(Reset == 1'b0)
		begin
			state = S0;
		end
		else
			state = nextstate;
	end
	
	always @(state, Op)
	begin
		case(state)
			S0: 
			begin
				MemRead = 1'b1;
				MemWrite = 1'b0;
				lorD = 1'b0;
				IRWrite = 1'b1;
								
				PCWrite = 1'b1;
				PCWriteCond = 1'b0;
				PCSource = 2'b00;
				
				ALUSrcA = 1'b0;
				ALUSrcB = 2'b01;
				ALUOp = 2'b00;
						
				RegWrite = 1'b0;		
				RegDst = 1'b0;
				MemtoReg = 1'b0;
						
				nextstate = S1;
				oCycle = 3'b001;
			end
			
			S1: 
			begin
				MemRead=1'b0;
				MemWrite=1'b0;		
				IRWrite=1'b0;
				
				PCWrite=1'b0;
				
				ALUSrcA=1'b0;
				ALUSrcB=2'b11;
				ALUOp= 2'b00;
// Fill the blank				
				if(	Op == 6'b100011)  //if op code is lw or sw
				begin
					nextstate = S2;
				end
				else if(Op == 6'b101011)  //if op code is lw or sw
				begin	
					nextstate = S2;
				end
				else if(Op == 6'b000000)  // if R type instruction
				begin
					nextstate = S6;
				end
				else if(Op == 6'b000100)  //if beq instruction
				begin
					nextstate = S8;
				end
				else if(Op == 6'b000010)  //if jump instruction
				begin
					nextstate = S9;
				end
				else if(Op == 6'b001000) // if addi instruction
				begin
				    nextstate = S12;
				end
				else if((Op == 6'b001100) || (Op == 6'b001101) || (Op == 6'b001010	))  //if I type
				begin
					nextstate = S10;
				end
				
				oCycle = 3'b010;
			end
			
			S2: 
			begin
				MemRead = 1'b0;
				MemWrite = 1'b0;
				
				ALUSrcA = 1'b1;
				ALUSrcB = 2'b10;
				ALUOp = 2'b00;
// Fill the blank		
				if(Op == 6'b100011	)  //if lw
				begin
					nextstate = S3;
				end
				else if(Op == 6'b101011)  // if SW instruction
				begin
					nextstate = S5;
				end
				
				oCycle = 3'b011;
			end
			
			S3: 
			begin
				MemRead=1'b1;
				MemWrite = 1'b0;
				lorD = 1'b1;
				
				nextstate=S4;	
				oCycle = 3'b100;
			end
	
			S4: 
			begin
				MemRead=1'b0;
				MemWrite = 1'b0;
				
				RegDst = 1'b0;
				RegWrite = 1'b1;
				MemtoReg= 1'b1;
				
				nextstate=S0;
				oCycle = 3'b101;
			end
			
			S5: 
			begin
				MemRead=1'b0;
				MemWrite=1'b1;
				lorD= 1'b1;
				
				nextstate=S0;
				oCycle = 3'b100;
			end
	
			S6: 
			begin
				ALUSrcA= 1'b1;
				ALUSrcB= 2'b00;
				ALUOp = 2'b10;
				
				nextstate = S7;
				oCycle = 3'b011;
			end
	
			S7: 
			begin
				RegDst= 1'b1;
				RegWrite = 1'b1;
				MemtoReg = 1'b0;
				
				nextstate= S0;	
				oCycle = 3'b100;
			end
			
			S8: 
			begin
				ALUSrcA= 1'b1;
				ALUSrcB= 2'b00;
				ALUOp=2'b01;
				
				PCWriteCond= 1'b1;
				PCSource = 2'b01;
				
				nextstate= S0;
				oCycle = 3'b011;
			end
			
			S9: 
			begin
				PCWrite= 1'b1;
				PCSource= 2'b10;
				
				nextstate= S0;
				oCycle = 3'b011;
			end
			
			S10: 
			begin
				ALUSrcA= 1'b1;
				ALUSrcB= 2'b10;
				ALUOp = 2'b10;
				nextstate = S11;
				
				oCycle = 3'b100;
			end
			
			S11: 
			begin
				RegDst= 1'b1;
				RegWrite = 1'b1;
				MemtoReg = 1'b0;
				nextstate= S0;
				
				oCycle = 3'b100;
			end
			
			S12:
			begin
			    ALUSrcA= 1'b1;
				ALUSrcB= 2'b10;
				ALUOp = 2'b10;
				
				nextstate = S13;
				oCycle = 3'b011;
			end
			
			S13:
			begin
			    RegDst= 1'b0;
				RegWrite = 1'b1;
				MemtoReg = 1'b0;
				
				nextstate= S0;	
				oCycle = 3'b100;
			end
			
			default:
			begin
				nextstate = S0;
				
				oCycle = 3'b111;
			end
		endcase
	end
	
endmodule
