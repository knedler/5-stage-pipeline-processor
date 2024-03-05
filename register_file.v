//file register_file.v
module register_file (
	input wire [4:0] read_address_1,
	input wire [4:0] read_address_2,
	input wire [31:0] write_data_in,
	input wire [4:0] write_address,
	input wire WriteEnable,
	input wire reset,
	input wire clock,
	input wire [4:0] read_address_debug,
	input wire clock_debug,
	output reg [31:0] data_out_1,
	output reg [31:0] data_out_2,
	output reg [31:0] data_out_debug
	);
	
	reg [31:0] register [0:31];
	integer i;
	
	initial begin
		for (i = 0; i < 32; i = i + 1) begin
			if (2 == i) begin
				register[i] = 2147479548;
			end else begin
				register[i] = 0;
			end
		end;
		
		data_out_1 <= 0;
		data_out_2 <= 0;
		end
	
	always @ (posedge clock_debug) begin
		if (reset) begin
			for (i = 0; i < 32; i = i + 1) begin
				if (2 == i) begin
					register[i] = 2147479548;
				end else begin
					register[i] = 0;
				end
			end;
		end else if (WriteEnable) begin
			register[write_address] <= write_data_in;
		end
	end
	
	always @ (negedge clock_debug) begin
		if (reset) begin
			data_out_1 <= 0;
			data_out_2 <= 0;
		end
			data_out_1 <= register[read_address_1];
			data_out_2 <= register[read_address_2];
	end
	
	always @ (negedge clock_debug) begin
		data_out_debug <= register[read_address_debug];
	end
	
	
endmodule