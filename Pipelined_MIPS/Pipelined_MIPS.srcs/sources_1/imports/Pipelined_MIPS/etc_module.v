
module Adder_32Bit(
	input [31:0] In_A, In_B,
	output [31:0] Output
);

	assign Output = In_A + In_B; // Adder�� �����ϱ� ���� ����
	// adder�� �����ϱ� ���ؼ��� �� ��ǲ�� ���� ���� �ƿ�ǲ�� �Ǿ�� �Ѵ�.
	
endmodule


module Mux32bit_2to1(
	input sel,
   input [31:0] in0, in1,
   output reg [31:0] out_mux
);

   always @(sel or in0 or in1)
   begin
      case (sel) // mux�� ����ġ�� ���ҷ� �ش�Ǵ� ���� ���� ��θ� �ٲ��ش�.
         0: out_mux = in0;
		 1: out_mux = in1;	 // CASE�� ���� MUX
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
		 // $readmemh("Top_InstructionMemory.dat", InstMemory); // ��ɾ �о���� �����Դϴ�. �߰����ּ���.
		 // InstMemory�� reg�� �̷���� �迭�̱� ������ �ּ�+4�� �ƴ϶� word ������ +1������ ��ɾ���� �߰��ؾ���.
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
		case (sel) // mux�� ����ġ�� ���ҷ� �ش�Ǵ� ���� ���� ��θ� �ٲ��ش�.
            0: out_mux = in0;
            1: out_mux = in1; // CASE�� ���� MUX
			default : out_mux = 32'b0;
		endcase
   end
endmodule


module Shift_Left_2Bit (
	input  [31:0] Input,
   output [31:0] Output
);  

   assign Output = Input<<2;// �������� 2bit shift,
endmodule

