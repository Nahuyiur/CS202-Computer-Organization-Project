module IFetch(
    input clk,
    input rst,
    input branch,
    input   wrong_prediction_flag,    /// see Program_Counter_Prediction.v for details
    input      [31:0] branch_pc,
    input      [31:0] program_counter_prediction,
    input [31:0] imm32,
    input zero,
    input reset_pc,

    input stall_flag,
    output [31:0] inst,
    output reg [31:0] pre_pc,
    output reg [31:0] pc

);

    wire [13:0] prgrom_addr = pc[15:2];  // 閻╁瓨甯撮悽? pc 锟??? ROM 閸︽澘锟??

    prgrom urom(
        .clka(clk),
        .addra(prgrom_addr),

        .douta(inst)
    );

    // 閺冭泛绨柅鏄忕帆閺囧瓨锟?? PC
    always @(negedge clk or negedge rst) begin
        if (~rst|| reset_pc)begin
            pc <= 32'h00000000;
            pre_pc <= 32'h00000000;
        end
        else if (wrong_prediction_flag) begin
            pc <= branch_pc;
            pre_pc <= pc;
        end
        else if (stall_flag)begin
            pc <= pc;
            pre_pc <= pre_pc;
        end
       
        else begin
            pc <= program_counter_prediction;
            pre_pc <= pc;
        end    
    end
        
   
endmodule
