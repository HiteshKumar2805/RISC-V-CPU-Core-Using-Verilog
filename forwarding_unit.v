module forwarding_unit(
    input  [4:0] EX_rs1, EX_rs2,    // Source registers from EX stage
    input  [4:0] MEM_rd, WB_rd,     // Destination registers from later stages
    input        MEM_RegWrite,      // MEM stage will write to register
    input        WB_RegWrite,       // WB stage will write to register
    output reg [1:0] forwardA, forwardB // Control signals for ALU operand muxes
);

    always @(*) begin
        // Default: no forwarding
        forwardA = 2'b00;
        forwardB = 2'b00;

        // Check forwarding for Operand A
        if (MEM_RegWrite && (MEM_rd != 0) && (MEM_rd == EX_rs1))
            forwardA = 2'b01; // Forward from MEM stage
        else if (WB_RegWrite && (WB_rd != 0) && (WB_rd == EX_rs1))
            forwardA = 2'b10; // Forward from WB stage

        // Check forwarding for Operand B
        if (MEM_RegWrite && (MEM_rd != 0) && (MEM_rd == EX_rs2))
            forwardB = 2'b01; // Forward from MEM stage
        else if (WB_RegWrite && (WB_rd != 0) && (WB_rd == EX_rs2))
            forwardB = 2'b10; // Forward from WB stage
    end

endmodule
