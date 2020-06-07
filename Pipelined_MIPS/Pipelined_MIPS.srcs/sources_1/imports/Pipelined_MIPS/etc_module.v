
module Adder_32Bit(
	input [31:0] In_A, In_B,
	output [31:0] Output
);

	assign Output = In_A + In_B; // Adder로 동작하기 위한 내용
	// adder로 동작하기 위해서는 두 인풋을 더한 것이 아웃풋이 되어야 한다.
	
endmodule


module Mux32bit_2to1(
	input sel,
   input [31:0] in0, in1,
   output reg [31:0] out_mux
);

   always @(sel or in0 or in1)
   begin
      case (sel) // mux는 스위치의 역할로 해당되는 값에 대해 경로를 바꿔준다.
         0: out_mux = in0;
		 1: out_mux = in1;	 // CASE에 따른 MUX
         default : out_mux = 32'b0;
      endcase
   end
endmodule


module InstructionMemory (
	input [31:0] ReadAddress,
	output [31:0] Instruction
);

	reg [31:0] InstMemory[0:255];
	
	initial
	begin
		 // $readmemh("Top_InstructionMemory.dat", InstMemory); // 명령어를 읽어오는 파일입니다. 추가해주세요.
		 // InstMemory는 reg로 이루어진 배열이기 때문에 주소+4가 아니라 word 단위라서 +1단위로 명령어들을 추가해야함.
		 InstMemory[0] <= 32'h00432021;
		 InstMemory[1] <= 32'h20210001;
         InstMemory[2] <= 32'h00832823;
         InstMemory[3] <= 32'h34460004;
         InstMemory[4] <= 32'h30470005;
         InstMemory[5] <= 32'h28280003;
	end

	assign Instruction = InstMemory[ReadAddress[9:0]>>2];

endmodule


module Sign_Extend (
	input [15:0] Input,
	output [31:0] Output
);

	assign Output = {{16{Input[15]}},Input};

endmodule


module Mux5bit_2to1(
   input sel,
   input [4:0] in0, in1,
   output reg [4:0] out_mux
);

   always @ (sel or in0 or in1)
   begin
		case (sel) // mux는 스위치의 역할로 해당되는 값에 대해 경로를 바꿔준다.
            0: out_mux = in0;
            1: out_mux = in1; // CASE에 따른 MUX
			default : out_mux = 32'b0;
		endcase
   end
endmodule


module Shift_Left_2Bit (
	input  [31:0] Input,
   output [31:0] Output
);  

   assign Output = Input<<2;// 좌측으로 2bit shift,
endmodule

