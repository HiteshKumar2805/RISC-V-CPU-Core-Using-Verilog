module hazard (
    input clk,
    input [4:0] id_ex_rd,
    input [4:0] ex_mem_rd,
    input [4:0] mem_wb_rd,
    input [4:0] id_ex_rs1,
    input [4:0] id_ex_rs2,
    input id_ex_mem_read,
    input ex_mem_branch,
    input [31:0] if_id_instr,
    output reg stall,
    output reg flush
);
    always @(posedge clk) begin
        // Default: No hazard, pipeline run
        stall = 0;
        flush = 0;

        // Data Hazard: Stall if execute needs data from memory or writeback
        if ((id_ex_rs1 == ex_mem_rd && ex_mem_rd != 0) || (id_ex_rs2 == ex_mem_rd && ex_mem_rd != 0)) begin
            stall = 1; // Stall for data dependency
        end else if ((id_ex_rs1 == mem_wb_rd && mem_wb_rd != 0) || (id_ex_rs2 == mem_wb_rd && mem_wb_rd != 0)) begin
            stall = 1; // Stall for data dependency
        end else if (id_ex_mem_read && ((id_ex_rs1 == ex_mem_rd && ex_mem_rd != 0) || (id_ex_rs2 == ex_mem_rd && ex_mem_rd != 0))) begin
            stall = 1; // Extra stall for load-use hazard
        end

        // Control Hazard: Flush on branch
        if (ex_mem_branch) begin
            flush = 1; // Flush pipeline if branch is taken
        end
    end
endmodule