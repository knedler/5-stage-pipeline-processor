// mem_wb
module mem_wb (
	input [31:0] d2_in,
	input [4:0] rd_in,
	input [31:0] c_m_w_in,
	input clock,
	input reset,
	output reg [31:0] d2_out,
	output reg [4:0] rd_out,
	output reg [31:0] c_m_w_out
	);
	
	initial begin
		d2_out <= 0;
		rd_out <= 0;
		c_m_w_out <= 0;
	end
	
	always @ (posedge clock) begin
		if (reset) begin
			d2_out <= 0;
			rd_out <= 0;
			c_m_w_out <= 0;
		end else begin
			d2_out <= d2_in;
			rd_out <= rd_in;
			if ((1 == c_m_w_in[20]) && (0 == rd_in)) begin
				c_m_w_out <= {c_m_w_in[31:21], 1'b0, c_m_w_in[19:0]};
			end else begin
				c_m_w_out <= c_m_w_in;
			end
		end
	end
	
endmodule