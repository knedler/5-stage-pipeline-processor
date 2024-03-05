module hazard_detection(
  input [31:0] ins,
  input [4:0] rd_id,
  input [4:0] rd_ex,
  input [4:0] rd_mem,
  input reset,
  input clock,
  output reg [31:0] ins_if,
  output reg stall
);

	initial begin
		stall <= 0;
		ins_if <= 0;
		end

	always @(*) begin
		if (reset) begin
			stall <= 1'b0;
			ins_if <= 32'h13;
		end else begin
			// Handle stalling
			if ((rd_id != 0 && (ins[19:15] == rd_id)) || (rd_ex != 0 && (ins[19:15] == rd_ex))) begin // Check Rs1
				stall <= 1;
				ins_if <= 32'h13;
			end else begin
				case (ins[6:0])
					7'b0110011, 7'b0100011, 7'b1100011: begin // R-Type, S-Type, B-Type
							if ((rd_id != 0 && (ins[24:20] == rd_id)) || (rd_ex != 0 && (ins[24:20] == rd_ex))) begin // Check Rs2
								stall <= 1;
								ins_if <= 32'h13;
							end else begin
								stall <= 0;
								ins_if <= ins;
							end
						end
					default: begin
							stall <= 0;
							ins_if <= ins;
						end
				endcase
			end
		end
	end

endmodule