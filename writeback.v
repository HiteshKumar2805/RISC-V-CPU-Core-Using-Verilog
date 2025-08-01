module writeback (
   input clk,
   input [31:0] mem_data_out,
   input [31:0] alu_result,
   input [4:0] rd_out,
   input reg_write,
   input mem_read_out,
   output reg [31:0] wb_data,
   output reg [4:0] wb_rd,
   output reg wb_reg_write
);
   always @(posedge clk) begin
   wb_rd <= rd_out;              // Always pass the register address
   wb_reg_write <= reg_write;    // Always pass the write enable
   if (mem_read_out) begin
       wb_data <= mem_data_out;  // Use memory data for loads
   end else begin
       wb_data <= alu_result;    // Use ALU result for others
   end
end
endmodule
