module if_id(
  input [31:0] instruction,
  input [31:0] pc_in,
  input branch,
  input clock,
  input reset,
  output reg [6:0] opcode,
  output reg [4:0] rd,
  output reg [2:0] funct3,
  output reg [4:0] rs1,
  output reg [4:0] rs2,
  output reg [6:0] funct7,
  output reg [31:0] immediate,
  output reg [31:0] pc_out
);

	initial begin
		opcode <= 7'b0;
      rd <= 5'b0;
      funct3 <= 3'b0;
      rs1 <= 5'b0;
      rs2 <= 5'b0;
      funct7 <= 7'b0;
      immediate <= 32'b0;
      pc_out <= 32'b0;
		end

  always @(posedge clock) begin
    if (reset || branch) begin
      opcode <= 7'b0;
      rd <= 5'b0;
      funct3 <= 3'b0;
      rs1 <= 5'b0;
      rs2 <= 5'b0;
      funct7 <= 7'b0;
      immediate <= 32'b0;
      pc_out <= 32'b0;
    end else begin
      opcode <= instruction[6:0];
      rd <= instruction[11:7];
      funct3 <= instruction[14:12];
      rs1 <= instruction[19:15];
      rs2 <= instruction[24:20];
      funct7 <= instruction[31:25];
      pc_out <= pc_in;
		
      case (instruction[6:0])
        // R-type instructions have no immediate field.
        7'b0110011: immediate <= 32'h0;
        // I-type instructions have a 12-bit immediate field.
        7'b0010011, 7'b0000011, 7'b1100111, 7'b1110011:
          immediate <= {{20{instruction[31]}}, instruction[31:20]};
        // S-type instructions have a 12-bit immediate field.
        7'b0100011: 
          immediate <= {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
        // B-type instructions have a 13-bit immediate field.
        7'b1100011:
          immediate <= {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
        // U-Type instructions have a 20-bit immediate field.
        7'b0010111, 7'b0110111:
          immediate <= {{12{instruction[31]}}, instruction[31:12]};
        // J-type instructions have a 20-bit immediate field.
        7'b1101111:
          immediate <= {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
        default: immediate <= 32'h0; // Set to 0 for unknown opcodes.
      endcase
    end
  end
  
endmodule
