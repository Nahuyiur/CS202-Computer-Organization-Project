module IFetch(
    input clk,
    input rst,
    input branch,
    input [31:0] imm32,
    input zero,
    output [31:0] inst,
    input reset_pc, 
    input jalr_flag,
    input jal_flag,
    input [31:0] rs1Data,
    output reg [31:0] pc,
 input  upg_rst_i,       
input    upg_clk_i, 
input    upg_wen_i,   
input [13:0] upg_adr_i,
 input [31:0] upg_dat_i, 
 input   upg_done_i,
 output kickOff   
);

 wire [13:0] prgrom_addr = pc[15:2];  
 assign kickOff = upg_rst_i | (~upg_rst_i & upg_done_i);
    // ROM 实例
    prgrom urom(
        .clka(kickOff?clk:upg_clk_i),
        .wea(kickOff?1'b0:upg_wen_i),
        .addra(kickOff?prgrom_addr:upg_adr_i), 
        .dina(kickOff?32'b0:upg_dat_i), 
        .douta(inst)
    );

    always @(negedge clk or negedge rst) begin
        if (~rst|reset_pc)
            pc <= 32'h00000000;
        else if (jalr_flag)
            pc <= rs1Data + imm32;
        else if (jal_flag) begin
            pc <= pc + imm32;
        end
        else if (branch && zero)
            pc <= pc+imm32;
        else
            pc <= pc + 4;
    end

endmodule
