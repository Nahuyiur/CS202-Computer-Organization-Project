`timescale 1ns / 1ps

module IF_to_ID(
    input clk,
    input rst,
    input stall,
    input wrong_prediction_flag,
    
    input [31:0] inst_IF,// instruction from IFetch stage
    input [31:0] pc_IF,//浠嶪fetch闃舵浼犻?掕繃鏉ョ殑pc
    input [31:0] pc_prediction_IF,//鍒嗘敮棰勬祴鐨刾c鐨勫??

    output reg [31:0] inst_ID,
    output reg [31:0] pc_ID,//浼犻?掑埌ID闃舵鐨刾c
    output reg [31:0] pc_prediction_ID//浼犻?掑埌鍒嗘敮棰勬祴鐨刾c鐨勫??
);

always @(posedge clk or negedge rst ) begin
    if (~rst ) begin
        inst_ID <= 32'b0;
        pc_ID <= 32'b0;
        pc_prediction_ID <= 32'b0;
    end 
    else if (stall) begin
        inst_ID <= inst_ID;
        pc_ID <= pc_ID;
        pc_prediction_ID <= pc_prediction_ID;
    end
    else begin
        inst_ID <= inst_IF;
        pc_ID <= pc_IF;
        pc_prediction_ID <= pc_prediction_IF;
    end
end
endmodule