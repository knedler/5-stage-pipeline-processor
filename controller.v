// controller.v
module controller (
	input wire [6:0] opcode,
	input wire [2:0] funct3,
	input wire [6:0] funct7,
	input branch,
	input clock,
	input reset,
	output reg [31:0] controller
	);
	
	/* 
	/	Bit 0-6 		= Opcode Value
	/	Bit 7-9 		= Funct3 Value
	/	Bit 10-16 	= Funct7 Value
	/	Bit 17 		= Imm (1) or rs2 (0) for Alu 
	/	Bit 18 		= Write datamem
	/	Bit 19 		= If instruction accesses datamem
	/	Bit 20 		= Write reg 
	*/
	
	initial begin
		controller <= 0;
		end
	
	always @(negedge clock) begin
		if (reset || branch) begin
			controller <= 0;
		end else begin
			case (opcode)
				// R type
				7'b0110011: 
					begin
						controller <= {4'b1000, funct7, funct3, opcode};
					end
				// I-type
				7'b0010011, 7'b1100111:
					begin
						controller <= {4'b1001, funct7, funct3, opcode};
					end
				7'b0000011: //Load
					begin
						controller <= {4'b1101, funct7, funct3, opcode};
					end
				// S-Type
				7'b0100011:
					begin
						controller <= {4'b0111, funct7, funct3, opcode};
					end
				// B-type
				7'b1100011:
					begin
						controller <= {4'b0000, funct7, funct3, opcode};
					end
				// U-type
				7'b0110111, 7'b0010111:
					begin
						controller <= {4'b1001, funct7, funct3, opcode};
					end
				// J-type
				7'b1101111:
					begin
						controller <= {4'b1001, funct7, funct3, opcode};
					end
			endcase
		end
	end
	
endmodule