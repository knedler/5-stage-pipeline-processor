// IF_ID
`include "riscv_defs.v"

module if_id (
   input [31:0] instruction,
	input clock,
	input reset,
   output wire [6:0] opcode,
   output wire [4:0] rs1,
   output wire [4:0] rs2,
   output wire [4:0] rd,
   output wire [31:0] immediate
);

   // Extract the opcode and other fields from the instruction.
   assign opcode = instruction[6:0];
   assign rs1 = instruction[19:15];
   assign rs2 = instruction[24:20];
	assign rd = instruction[11:7];
	
	// Sign-extend the immediate field, depending on the instruction type.
   reg [31:0] sign_extended_immediate;
	always @ (posedge clock) begin
		if (reset) begin
			sign_extended_immediate <= 0;
		end else begin
			case(opcode)
            // R-type instructions have no immediate field.
            7'b0110011: sign_extended_immediate <= 32'h0;

            // I-type instructions have a 12-bit immediate field.
            7'b0010011: sign_extended_immediate <= {{20{instruction[31]}}, instruction[31:20]};

            // S-type instructions have a 12-bit immediate field.
            7'b0100011: sign_extended_immediate <= {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};

            // B-type instructions have a 13-bit immediate field.
            7'b1100011: sign_extended_immediate <= {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8]};

            // J-type instructions have a 20-bit immediate field.
            7'b1101111: sign_extended_immediate <= {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21]};

            // AUIPC and LUI instructions have a 20-bit immediate field.
            7'b0010111, 7'b0110111: sign_extended_immediate <= {{12{instruction[31]}}, instruction[31:12]};

            default: sign_extended_immediate <= 32'h0;
        endcase
		end
	end

	// Assign the immediate output.
	assign immediate = sign_extended_immediate;
	
endmodule