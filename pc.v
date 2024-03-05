// pc.v
module pc (
	input wire [31:0] pc_in,
	input wire [31:0] imm,
	input wire [31:0] rs1,
	input wire branch,
	input wire jalr,
	input wire stall,
	input wire clock,
	input wire reset,
	output reg [31:0] pc_out
	);
	
	
	initial pc_out <= 4194304;
	
	always @ (posedge clock) begin
		if (reset) begin
			pc_out <= 4194304;
		end else if (branch) begin
			if (jalr) begin
				pc_out <= rs1 + imm;
			end else begin
				pc_out <= pc_in + imm - 8;
			end
		end else if (!stall)begin
			pc_out <= pc_in + 4;
		end
	end
	
endmodule