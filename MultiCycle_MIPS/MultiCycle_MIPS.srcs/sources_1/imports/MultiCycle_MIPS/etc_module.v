
module Register(
	input CLK,
	input [31:0] DataIn, 
	output reg [31:0] DataOut
);

	always @(posedge CLK)
	begin
		DataOut = DataIn;
	end
	
endmodule

module IR(
	input CLK, IRWrite,
	input [31:0] DataIn,
	output reg [31:0] DataOut
);

	always @(posedge CLK)
	begin
		if(IRWrite==1'b1) 
		begin
			DataOut <= DataIn;
		end
	end
	
endmodule

module SignExtend(
	input [15:0] In,
	output [31:0] Out
);

	assign Out = {{16{In[15]}},In[15:0]};

endmodule

module Four2One(
	input [1:0] Control,
	input [31:0] A, B, C, D,
	output [31:0] Out
);

	assign Out = Control[1] ? (Control[0] ? D : C) : (Control[0] ? B : A);
	
endmodule


