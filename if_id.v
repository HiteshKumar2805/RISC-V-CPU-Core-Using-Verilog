module if_id(
    input clk, reset,
    input stall, flush,
    input [31:0] pc_in,
    input [31:0] instr_in,
    output reg [31:0] pc_out,
    output reg [31:0] instr_out
);
    always @(posedge clk or posedge reset) begin
        if (reset || flush) begin
            pc_out <= 0;
            instr_out <= 0;
        end else if (!stall) begin
            pc_out <= pc_in;
            instr_out <= instr_in;
        end
    end
endmodule