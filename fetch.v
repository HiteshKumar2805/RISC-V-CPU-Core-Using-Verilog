module fetch (
    input clk, reset,
    input [31:0] pc_next,
    input stall, flush, 
    // stall : A control signal to pause the stage, preventing PC or instruction updates
    // flush: A control signal to clear the stage, resetting the PC
    output reg [31:0] pc, //The current Program Counter value, used to address memory
    output reg [31:0] instr,// The fetched 32-bit instruction from memory
    output [31:0] pc_out,
    input [31:0] mem_data // 32-bit memory data
);
    // PC Register
    always @(posedge clk or posedge reset) begin
        if (reset) pc <= 0;
        else if (flush) pc <= 0; // Reset PC on flush 
        else if (!stall) pc <= pc_next; // Update PC unless stalled
    end

    // Instruction Fetch
    always @(posedge clk) begin
        if (!stall && !flush) instr <= mem_data; // Fetch instruction from memory
    end

    // Output PC for memory addressing
    assign pc_out = pc;

endmodule
