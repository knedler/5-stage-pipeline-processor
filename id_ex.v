// ID_EX
module id_ex (
	input [31:0] d1_in,
	input [31:0] d2_in,
	input [4:0] rd_in,
	input [31:0] imm_in,
	input [31:0] c_i_e_in,
	input [31:0] pc_in,
	input branch,
	input clock,
	input reset,
	output reg [31:0] d1_out,
	output reg [31:0] d2_out,
	output reg [4:0] rd_out,
	output reg [31:0] imm_out,
	output reg [31:0] c_i_e_out,
	output reg [31:0] pc_out
	);
	
	initial begin
		d1_out <= 0;
		d2_out <= 0;
		rd_out <= 0;
		imm_out <= 0;
		c_i_e_out <= 0;
		pc_out <= 0;
		end
	
	always @ (posedge clock) begin
		if (reset || branch) begin
			d1_out <= 0;
			d2_out <= 0;
			rd_out <= 0;
			imm_out <= 0;
			c_i_e_out <= 0;
			pc_out <= 0;
		end else begin
			d1_out <= d1_in;
			d2_out <= d2_in;
			rd_out <= rd_in;
			imm_out <= imm_in;
			c_i_e_out <= c_i_e_in;
			pc_out <= pc_in;
		end
	end
	
endmodule