// ALU
module alu (
	input wire [31:0] d1_in,
	input wire [31:0] d2_in,
	input wire [31:0] c_d_e_in,
	input wire [31:0] pc,
	input wire clock,
	input wire reset,
	output reg [31:0] d1_out,
	output reg branch,
	output reg jalr
	);
	
	initial begin
		d1_out <= 0;
		branch <= 0;
		jalr <= 0;
		end
	
	always @(negedge clock) begin
		if (reset) begin
			d1_out <= 0;
			branch <= 0;
			jalr <= 0;
		end else begin
			d1_out <= 0;
			branch <= 0;
			jalr <= 0;
			
			case (c_d_e_in[6:0])
				7'b0110011: // Math
					begin
						case (c_d_e_in[9:7])
							3'b000:
								begin
									case (c_d_e_in[16:10])
										6'b000000:
											begin // add
												d1_out <= d1_in + d2_in;
											end
										6'b100000:
											begin // sub
												d1_out <= d1_in - d2_in;
											end
									endcase
								end
							3'b001:
								begin // sll
									d1_out <= d1_in << d2_in;
								end
							3'b010:
								begin // slt
									d1_out <= (d1_in < d2_in) ? 1 : 0;
								end
							3'b011:
								begin // sltu
									d1_out <= (d1_in < d2_in) ? 1 : 0;
								end
							3'b100:
								begin // xor
									d1_out <= d1_in ^ d2_in;
								end
							3'b101:
								begin
									case (c_d_e_in[16:10])
										6'b000000:
											begin // srl
												d1_out <= d1_in >> d2_in;
											end
										6'b100000:
											begin // sra
												d1_out <= d1_in >> d2_in;
											end
									endcase
								end
							3'b110:
								begin // or
									d1_out <= d1_in | d2_in;
								end
							3'b111:
								begin // and
									d1_out <= d1_in & d2_in;
								end
						endcase
					end
				7'b0010011: // Math Imm
					begin
						case (c_d_e_in[9:7])
							3'b000:
								begin // addi
									d1_out <= d1_in + d2_in;
								end
							3'b001:
								begin // slli
									d1_out <= d1_in << d2_in[4:0];
								end
							3'b010:
								begin // slti
									d1_out <= (d1_in < d2_in) ? 1 : 0;
								end
							3'b011:
								begin // sltiu
									d1_out <= (d1_in < d2_in) ? 1 : 0;
								end
							3'b100:
								begin // xori
									d1_out <= d1_in ^ d2_in;
								end
							3'b101:
								begin
									case (d2_in[11:5])
										6'b000000:
											begin // srli
												d1_out <= d1_in >> d2_in[4:0];
											end
										6'b100000:
											begin // srai
												d1_out <= d1_in >> d2_in[4:0];
											end
									endcase
								end
							3'b110:
								begin // ori
									d1_out <= d1_in | d2_in;
								end
							3'b111:
								begin // andi
									d1_out <= d1_in & d2_in;
								end
						endcase
					end
				7'b0000011: // Load
					begin // lw
						d1_out <= (d1_in + d2_in) >> 2;
					end
				7'b0100011: // Store
					begin // sw
						d1_out <= (d1_in + d2_in) >> 2;
					end
				7'b1100011: // Branch
					begin
						case (c_d_e_in[9:7])
							3'b000:
								begin // beq
									branch <= (0 == (d1_in - d2_in));
								end
							3'b001:
								begin // bne
									branch <= (0 != (d1_in - d2_in));
								end
							3'b100:
								begin // blt
									branch <= (d1_in < d2_in);
								end
							3'b101:
								begin // bge
									branch <= (d1_in >= d2_in);
								end
							3'b110:
								begin // bltu
									branch <= (d1_in < d2_in);
								end
							3'b111:
								begin // bgeu
									branch <= (d1_in >= d2_in);
								end
						endcase
					end
				7'b1101111: // Jump And Link
					begin // jal
						d1_out <= pc + 4;
						branch <= 1;
					end
				7'b1100111: // Jump And Link Reg
					begin // jalr
						d1_out <= pc + 4;
						branch <= 1;
						jalr <= 1;
					end
				7'b0110111: // Load Upper Imm
					begin // lui
						d1_out <= d2_in << 12;
					end
				7'b0010111: // Add Upper Imm
					begin // auipc
						d1_out <=  pc + (d2_in << 12);
					end
			endcase
		end
	end
	
endmodule