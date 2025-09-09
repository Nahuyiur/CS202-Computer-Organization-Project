`timescale 1ns / 1ps

module ID_to_EX(
    input clk,
    input rst,
    input stall,//鏆傚仠淇″彿锛堥珮鐢靛钩鏃朵繚鎸佸綋鍓嶏拷?锟斤級锟??
    input wrong_prediction_flag,//鍒嗘敮棰勬祴閿欒锛堥珮鐢靛钩鏃舵竻绌猴紝闃叉閿欒鎸囦护鎵ц锛夛拷??

    input branch_flag_ID,//鏄惁鏄垎鏀寚锟??
    input [1:0] ALU_operation_ID,// ALU鎿嶄綔绫诲瀷
    input ALU_src_flag_ID,// ALU 鐨勭浜屼釜鎿嶄綔鏁版槸瀵勫瓨鍣ㄨ繕鏄珛鍗虫暟
    input mem_write_flag_ID,
    input mem_to_reg_flag_ID,
    input reg_write_flag_ID,
    input jal_flag_ID,
    input jalr_flag_ID,
    input lui_flag_ID,
    input [31:0] imme_ID,//绔嬪嵆锟??
    input [31:0] read_data_1_ID,
    input [31:0] read_data_2_ID,
    input [4:0] read_reg_idx_1_ID,
    input [4:0] read_reg_idx_2_ID,
    input [4:0] write_reg_idx_ID,
    input [31:0] inst_ID,//鎸囦护
    input [31:0] pc_ID,//pc鐨勶拷??
    input [31:0] pc_prediction_ID,

    output reg branch_flag_EX,
    output reg [1:0] ALU_operation_EX,
    output reg ALU_src_flag_EX,
    //output reg mem_read_flag_EX,
    output reg mem_write_flag_EX,
    output reg mem_to_reg_flag_EX,
    output reg reg_write_flag_EX,
    output reg jal_flag_EX,
    output reg jalr_flag_EX,
    output reg lui_flag_EX,
    output reg [31:0] imme_EX,
    output reg [31:0] read_data_1_EX,
    output reg [31:0] read_data_2_EX,
    output reg [4:0] read_reg_idx_1_EX,
    output reg [4:0] read_reg_idx_2_EX,
    output reg [4:0] write_reg_idx_EX,
    output reg [31:0] inst_EX,
    output reg [31:0] pc_EX,
    output reg [31:0]  pc_prediction_EX
    
  
);

always @(posedge clk or negedge rst) begin
    if (~rst || stall ) begin//锟??鏈夋寚浠ゅ叏閮ㄦ棤鏁堬紝杩欎簺鎸囦护閮芥槸杈撳嚭鍒癊X鐨勯樁锟??
        branch_flag_EX <= 1'b0;
        ALU_operation_EX <= 2'b00;
        ALU_src_flag_EX <= 1'b0;
        //mem_read_flag_EX <= 1'b0;
        mem_write_flag_EX <= 1'b0;
        mem_to_reg_flag_EX <= 1'b0;
        reg_write_flag_EX <= 1'b0;
        jal_flag_EX <= 1'b0;
        jalr_flag_EX <= 1'b0;
        lui_flag_EX <= 1'b0;
        //auipc_flag_EX <= 1'b0;
        imme_EX <= 32'b0;
        read_data_1_EX <= 32'b0;
        read_data_2_EX <= 32'b0;
        read_reg_idx_1_EX <= 5'b0;
        read_reg_idx_2_EX <= 5'b0;
        write_reg_idx_EX <= 5'b0;
        inst_EX <= 32'b0;
        pc_EX <= 32'b0;
        pc_prediction_EX <= 32'b0;
    end
    else begin
        branch_flag_EX <= branch_flag_ID;
        ALU_operation_EX <= ALU_operation_ID;
        ALU_src_flag_EX <= ALU_src_flag_ID;
        //mem_read_flag_EX <= mem_read_flag_ID;
        mem_write_flag_EX <= mem_write_flag_ID;
        mem_to_reg_flag_EX <= mem_to_reg_flag_ID;
        reg_write_flag_EX <= reg_write_flag_ID;
        jal_flag_EX <= jal_flag_ID;
        jalr_flag_EX <= jalr_flag_ID;
        lui_flag_EX <= lui_flag_ID;
        //auipc_flag_EX <= auipc_flag_ID;
        imme_EX <= imme_ID;
        read_data_1_EX <= read_data_1_ID;
        read_data_2_EX <= read_data_2_ID;
        read_reg_idx_1_EX <= read_reg_idx_1_ID;
        read_reg_idx_2_EX <= read_reg_idx_2_ID;
        write_reg_idx_EX <= write_reg_idx_ID;
        inst_EX <= inst_ID;
        pc_EX <= pc_ID;
        pc_prediction_EX <= pc_prediction_ID;
    end
end


endmodule