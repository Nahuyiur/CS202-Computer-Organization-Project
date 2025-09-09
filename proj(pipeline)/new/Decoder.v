module Decoder(
    input clk,
    input rst,
    input regWrite,
    input [31:0] inst,
    input [4:0] write_reg_idx_WB,
    input [31:0] writeData,
    input [31:0] pc_WB,
    output [31:0] rs1Data,
    output [31:0] rs2Data,
    output reg [31:0] imm32,
    output [4:0] rs1,
    output [4:0] rs2,
    output [4:0] rd,

    output [31:0] reg0,
    output [31:0] reg1,
    output [31:0] reg2,
    output [31:0] reg3,
    output [31:0] reg4,
    output [31:0] reg5,
    output [31:0] reg6,
    output [31:0] reg7,
    output [31:0] reg8,
    output [31:0] reg9,
    output [31:0] reg10,
    output [31:0] reg11,
    output [31:0] reg12,
    output [31:0] reg13,
    output [31:0] reg14,
    output [31:0] reg15,
    output [31:0] reg16,
    output [31:0] reg17,
    output [31:0] reg18,
    output [31:0] reg19,
    output [31:0] reg20,
    output [31:0] reg21,
    output [31:0] reg22,
    output [31:0] reg23,
    output [31:0] reg24,
    output [31:0] reg25,
    output [31:0] reg26,
    output [31:0] reg27,
    output [31:0] reg28,
    output [31:0] reg29,
    output [31:0] reg30,
    output [31:0] reg31,
    output [31:0] use_pc
);
    // 寄存器堆
    reg [31:0] registers[0:31];
    assign use_pc = pc_WB;

    // 译码字段
    assign rs1 = inst[19:15];
    assign rs2 = inst[24:20];
    assign rd  = inst[11:7];
    wire [6:0] opcode = inst[6:0];

    // 寄存器读取
    assign rs1Data = (rs1 == 0) ? 32'h0 : registers[rs1];
    assign rs2Data = (rs2 == 0) ? 32'h0 : registers[rs2];

    // 立即数生成
    always @(*) begin
        case(opcode)
            7'b0110011: imm32 = 32'b0; // R
            7'b0010011, 7'b0000011, 7'b1100111: imm32 = {{20{inst[31]}}, inst[31:20]}; // I
            7'b0100011: imm32 = {{20{inst[31]}}, inst[31:25], inst[11:7]}; // S
            7'b1100011: imm32 = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0}; // B
            7'b0110111, 7'b0010111: imm32 = {inst[31:12], 12'b0}; // U
            7'b1101111: imm32 = {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0}; // J
            default: imm32 = 32'h0;
        endcase
    end

    // 写寄存器
    integer i;
    always @(negedge clk or negedge rst) begin
        if (~rst) begin
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'h0;
        end else if (regWrite && (write_reg_idx_WB != 0)) begin
            registers[write_reg_idx_WB] <= writeData;
        end
    end

    // 输出寄存器内容
    assign reg0 = registers[0];
    assign reg1 = registers[1];
    assign reg2 = registers[2];
    assign reg3 = registers[3];
    assign reg4 = registers[4];
    assign reg5 = registers[5];
    assign reg6 = registers[6];
    assign reg7 = registers[7];
    assign reg8 = registers[8];
    assign reg9 = registers[9];
    assign reg10 = registers[10];
    assign reg11 = registers[11];
    assign reg12 = registers[12];
    assign reg13 = registers[13];
    assign reg14 = registers[14];
    assign reg15 = registers[15];
    assign reg16 = registers[16];
    assign reg17 = registers[17];
    assign reg18 = registers[18];
    assign reg19 = registers[19];
    assign reg20 = registers[20];
    assign reg21 = registers[21];
    assign reg22 = registers[22];
    assign reg23 = registers[23];
    assign reg24 = registers[24];
    assign reg25 = registers[25];
    assign reg26 = registers[26];
    assign reg27 = registers[27];
    assign reg28 = registers[28];
    assign reg29 = registers[29];
    assign reg30 = registers[30];
    assign reg31 = registers[31];

endmodule
