module Decoder(
    input clk,
    input rst,
    input regWrite,
    input [31:0] inst,
    input [31:0] writeData,
    input ecall_flag,
    output [31:0] rs1Data,
    output [31:0] rs2Data,
    output reg [31:0] imm32,
    output  reg [31:0] a0,
    output  reg [31:0] a7
);

    // 32x32 Register File
    reg [31:0] registers[31:0];
    always @(*) begin
        a0 = registers[10];
        a7 = registers[17];
    end
    // Instruction Field Extraction
    wire [4:0] rs1 = inst[19:15];
    wire [4:0] rs2 = inst[24:20];
    wire [4:0] rd  = inst[11:7];
    wire [6:0] opcode = inst[6:0];

    // Combinational Read Logic
    assign rs1Data = (rs1 == 0) ? 32'h0 : registers[rs1];
    assign rs2Data = (rs2 == 0) ? 32'h0 : registers[rs2];


    always @(*) begin
        case(opcode)
            // I-type (lw, ALU-I)
            7'b0000011, 7'b0010011: 
                imm32 = {{20{inst[31]}}, inst[31:20]};

            // S-type (sw)
            7'b0100011: 
                imm32 = {{20{inst[31]}}, inst[31:25], inst[11:7]};

            // SB-type (beq)
            7'b1100011: 
                imm32 = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};

            //lui
            7'b0110111,7'b0010111:
                imm32 = {inst[31:12],12'b0};

                 // J-type
            7'b1101111:
                imm32 = {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};
            
            default: 
                imm32 = 32'h0;
        endcase
    end


    reg [5:0] i;
    always @(negedge clk) begin
    registers[0]<= 32'h00000000;
    registers[31] <= 32'h00002000;
    if (~rst) begin
        for (i = 0; i < 32; i = i + 1)
            registers[i] <= 32'h0;
        registers[31] <= 32'h00002000; 
    end
    else if (regWrite && (rd != 0)) begin
        registers[rd] <= writeData;
    end
    else if (ecall_flag==1&a7==32'd5) begin
        registers[10] <= writeData;
    end
end


endmodule