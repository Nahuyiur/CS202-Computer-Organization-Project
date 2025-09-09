module CPU_TOP(//new
    input         clk,            // 姘撻檱閳ユ拋鈹㈡崠顭嬵煀锟???婧嶃儮?尾銉冦儏鑴氳銉傦拷??濮戯腹?鏂呯澒锟???锟???
    input         rst,
    input [2:0] number,
    input  [7:0] switch,        // 蹇欓垾瀛ゎ煁顬犵妳浼便儌??姘撻垾尾瓒侇煀锟???婧嶃儮?尾銉冾嚪濡撳枹褉?閮濈柕蔚閾般儍位婧岀妴銉傛壋?婵礛IO鑼傚綍?
    input confirm,
    output [7:0] leds,
    output [7:0] segment1,
    output [7:0] segment2,
    output [7:0] anode,
    output [31:0] reg0,
    output [31:0] reg1,
    output [31:0] reg2,
   output [31:0] reg3,
   output [31:0] reg4,
    output [31:0] reg5,
 output [31:0] reg6,
    output [31:0] reg7,
    output [31:0] reg8,
  output[31:0] reg9,
    output [31:0] reg10,
  output [31:0] reg11,
   output [31:0] reg12,
    output [31:0] reg13,
   output [31:0] reg14,
   output [31:0] reg15,
   output [31:0] reg16,
   output [31:0] reg17,
   output[31:0] reg18,
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
 
   

   
    

   
  
    

    
);//pc,inst[](閺堝鍤戞稉顏吥侀崸锟??鍨归梽銈嗗复锟???)閿涘異ranch閿涘瓑LUOP閿涘瓑LUSRC閿涘EGWrite,MEMread(閸掔娀娅庢禍?)閿涘emWrite
//rs1Data閿涘s2Data,imm32,rs1,rs2,rd,zero

//wire clk;
//cpuclk clk_gen (
//    .clk_in1(clkin),
//    .clk_out1(clk)
//);


reg [2:0] last_number;
wire reset_pc;

assign reset_pc = (number != last_number);

always @(posedge clk or posedge rst) begin
    if (~rst)
        last_number <= 3'b0;
    else
        last_number <= number;
end

wire [31:0] segments;
scan_display scan_display_inst (
    .clk(clk),
    .data(segments), 
    .anode(anode),   
    .seg1(segment1),  
    .seg2(segment2)  
);





wire    wrong_prediction_flag;
wire [31:0] pc;
wire stall_flag;//鏉堟挸鍙咺F_ID濡拷?锟芥健
wire [31:0] pre_pc;//pre_pc鏉堟挸鍙咺F_ID濡拷?锟芥健

wire [31:0] imm32;//鏉堟挸鍙咺Fetch濡拷?锟芥健
wire  [31:0]       program_counter_prediction_IF;
wire [31:0] inst;
wire  [31:0] branch_pc;
IFetch IFetch_inst (
    .clk(clk),
    .rst(rst),
    .wrong_prediction_flag(wrong_prediction_flag),
    .program_counter_prediction(program_counter_prediction_IF),
    .branch_pc(branch_pc),
    .stall_flag(stall_flag),//鏉堟挸锟??
    .reset_pc(reset_pc),

    .inst(inst),
    .pre_pc(pre_pc),
    .pc(pc)
    
);


//wire [31:0] reg0;
//wire [31:0] reg1;
//wire [31:0] reg2;
//wire [31:0] reg3;
//wire [31:0] reg4;
//wire [31:0] reg5;
//wire [31:0] reg6;
//wire [31:0] reg7;
//wire [31:0] reg8;
//wire [31:0] reg9;
//wire [31:0] reg10;
//wire [31:0] reg11;
//wire [31:0] reg12;
//wire [31:0] reg13;
//wire [31:0] reg14;
//wire [31:0] reg15;
//wire [31:0] reg16;
//wire [31:0] reg17;
//wire [31:0] reg18;
//wire [31:0] reg19;
//wire [31:0] reg20;
//wire [31:0] reg21;
//wire [31:0] reg22;
//wire [31:0] reg23;
//wire [31:0] reg24;
//wire [31:0] reg25;
//wire [31:0] reg26;
//wire [31:0] reg27;
//wire [31:0] reg28;
//wire [31:0] reg29;
//wire [31:0] reg30;
//wire [31:0] reg31;
//wire [31:0] use_pc;


Debug debug_unit (
    .clk(clk),
    .rst(rst),
    .current_pc(use_pc),
    .confirm(confirm),
    .switch(switch),
    .reg0(reg0),
    .reg1(reg1),
    .reg2(reg2),
    .reg3(reg3),
    .reg4(reg4),
    .reg5(reg5),
    .reg6(reg6),
    .reg7(reg7),
    .reg8(reg8),
    .reg9(reg9),
    .reg10(reg10),
    .reg11(reg11),
    .reg12(reg12),
    .reg13(reg13),
    .reg14(reg14),
    .reg15(reg15),
    .reg16(reg16),
    .reg17(reg17),
    .reg18(reg18),
    .reg19(reg19),
    .reg20(reg20),
    .reg21(reg21),
    .reg22(reg22),
    .reg23(reg23),
    .reg24(reg24),
    .reg25(reg25),
    .reg26(reg26),
    .reg27(reg27),
    .reg28(reg28),
    .reg29(reg29),
    .reg30(reg30),
    .reg31(reg31),

    .display_data(segments)
);


///// Program Counter Prediction /////

wire              branch_flag_MEM;   
wire  [31:0]      program_counter_MEM;
wire  [31:0]      prev_pcp;

PC_Prediction Program_Counter_Prediction_Instance(
    .clk(clk),
    .rst(rst),
    .branch_from_pc(program_counter_MEM),
    .branch_to_pc(branch_pc),
    .program_counter(pc),
    .branch_flag(branch_flag_MEM),

    .program_counter_prediction(program_counter_prediction_IF),
    .prev_pcp(prev_pcp)
);


//IF_ID
wire [31:0] pc_ID;//鏉堟挸鍤崚鐧怐闂冭埖锟??
wire [31:0] inst_ID;//鏉堟挸鍤崚鐧怐 闂冭埖锟??
wire [31:0] program_counter_prediction_ID;


IF_to_ID IF_ID_inst (
    .clk(clk),
    .rst(rst),
    .stall(stall_flag),
    .wrong_prediction_flag(wrong_prediction_flag),
    .inst_IF(inst),
    .pc_IF(pre_pc),
    .pc_prediction_IF(prev_pcp),

    .inst_ID(inst_ID),
    .pc_ID(pc_ID),
    .pc_prediction_ID(program_counter_prediction_ID)
);


wire        RegWrite, MemorIOtoReg, ALUSrc,MemWrite;
wire [1:0]  ALUOp;
wire [2:0]  load_type, store_type;
wire [6:0]  opcode;
wire        jal_flag_ID;
wire        jalr_flag_ID;
wire        lui_flag_ID;
wire       branch_flag_ID;

Controller controller_inst (
    .inst(inst_ID),

    .Branch(branch_flag_ID),
    .ALUOp(ALUOp),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .MemWrite(MemWrite),
    .load_type(load_type),
    .store_type(store_type),
    .opcode(opcode),
    .MemorIOtoReg(MemorIOtoReg),
    .jal_flag(jal_flag_ID),
    .jalr_flag(jalr_flag_ID),
    .lui_flag(lui_flag_ID)

);

wire [4:0] rs1, rs2, rd;//鏉堟挸鍤崚鐧怐閳ユ柡?鎿闂冭埖锟??
wire [31:0] r_wdata;//鏉堟挸鍙嗛惃鍕晸閸忋儲鏆熼幑?
wire  reg_write_flag_WB;
wire [31:0] imme_ID;
wire [31:0] rs1Data ,rs2Data;
wire [4:0] write_reg_idx_WB;




wire [31:0] pc_WB;

Decoder Decoder_inst (
    .clk(clk),
    .rst(rst),
    .regWrite(reg_write_flag_WB),
    .inst(inst_ID),
    .writeData(r_wdata),
    .pc_WB(pc_WB),
    .write_reg_idx_WB(write_reg_idx_WB),


    .rs1Data(rs1Data),
    .rs2Data(rs2Data),
    .imm32(imme_ID),//鏉堟挸锟??
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .reg0(reg0),
        .reg1(reg1),
        .reg2(reg2),
        .reg3(reg3),
        .reg4(reg4),
        .reg5(reg5),
        .reg6(reg6),
        .reg7(reg7),
        .reg8(reg8),
        .reg9(reg9),
        .reg10(reg10),
        .reg11(reg11),
        .reg12(reg12),
        .reg13(reg13),
        .reg14(reg14),
        .reg15(reg15),
        .reg16(reg16),
        .reg17(reg17),
        .reg18(reg18),
        .reg19(reg19),
        .reg20(reg20),
        .reg21(reg21),
        .reg22(reg22),
        .reg23(reg23),
        .reg24(reg24),
        .reg25(reg25),
        .reg26(reg26),
        .reg27(reg27),
        .reg28(reg28),
        .reg29(reg29),
        .reg30(reg30),
        .reg31(reg31),
        .use_pc(use_pc)
    
    //瀵瑰簲write_reg_idx_ID
);

//ID_EX
//娴犮儰绗呴崸鍥﹁礋鏉堟挸鍤穱鈥冲娇閸掔檴X闂冭埖锟??

wire                  branch_flag_EX;
wire  [1:0]           ALU_operation_EX;
wire                  ALU_src_flag_EX;
wire                  mem_write_flag_EX;
wire                  mem_to_reg_flag_EX;
wire                  reg_write_flag_EX;
wire                  jal_flag_EX;
wire                  jalr_flag_EX;
wire                  lui_flag_EX;
wire  [31:0]          imme_EX;
wire  [31:0]          read_data_1_before_forward_EX;
wire  [31:0]          read_data_2_before_forward_EX;
wire  [4:0]           read_reg_idx_1_EX;
wire  [4:0]           read_reg_idx_2_EX;
wire  [4:0]           write_reg_idx_EX;
wire  [31:0]          inst_EX;
wire  [31:0]          pc_EX;
wire  [31:0]          program_counter_prediction_EX;


ID_to_EX ID_EX_inst (
    .clk(clk),
    .rst(rst),
    .stall(stall_flag),
    .branch_flag_ID(branch_flag_ID),
    .wrong_prediction_flag(wrong_prediction_flag),
    .ALU_operation_ID(ALUOp),
    .ALU_src_flag_ID(ALUSrc),
    .mem_write_flag_ID(MemWrite),
    .mem_to_reg_flag_ID(MemorIOtoReg),
    .reg_write_flag_ID(RegWrite),
    .jal_flag_ID(jal_flag_ID),
    .jalr_flag_ID(jalr_flag_ID),
    .lui_flag_ID(lui_flag_ID),
    .imme_ID(imme_ID),
    .read_data_1_ID(rs1Data),
    .read_data_2_ID(rs2Data),
    .read_reg_idx_1_ID(rs1),
    .read_reg_idx_2_ID(rs2),
    .write_reg_idx_ID(rd),
    .inst_ID(inst_ID),
    .pc_ID(pc_ID),
    .pc_prediction_ID(program_counter_prediction_ID),

    // 鏉堟挸鍤崚鐧奨闂冭埖锟??
    .branch_flag_EX(branch_flag_EX),
    .ALU_operation_EX(ALU_operation_EX),
    .ALU_src_flag_EX(ALU_src_flag_EX),
    .mem_write_flag_EX(mem_write_flag_EX),
    .mem_to_reg_flag_EX(mem_to_reg_flag_EX),
    .reg_write_flag_EX(reg_write_flag_EX),
    .jal_flag_EX(jal_flag_EX),
    .jalr_flag_EX(jalr_flag_EX),
    .lui_flag_EX(lui_flag_EX),
    .imme_EX(imme_EX),
    .read_data_1_EX(read_data_1_before_forward_EX),
    .read_data_2_EX(read_data_2_before_forward_EX),
    .read_reg_idx_1_EX(read_reg_idx_1_EX),
    .read_reg_idx_2_EX(read_reg_idx_2_EX),
    .write_reg_idx_EX(write_reg_idx_EX),
    .inst_EX(inst_EX),
    .pc_EX(pc_EX),
    .pc_prediction_EX(program_counter_prediction_EX)

);

//Forwarding_ALU
wire  [31:0]          read_data_1_forwarding;
wire  [31:0]          read_data_2_forwarding;
wire                  read_data_1_forwarding_flag;
wire                  read_data_2_forwarding_flag;
wire  [31:0]          read_data_1_after_forward_EX;
wire  [31:0]          read_data_2_after_forward_EX;

Forwarding_ALU  Forwarding_ALU_inst (
    .read_data_1_reg(read_data_1_before_forward_EX),
    .read_data_2_reg(read_data_2_before_forward_EX),
    .read_data_1_forwarding(read_data_1_forwarding),
    .read_data_2_forwarding(read_data_2_forwarding),
    .read_data_1_forwarding_flag(read_data_1_forwarding_flag),
    .read_data_2_forwarding_flag(read_data_2_forwarding_flag),

    .read_data_1(read_data_1_after_forward_EX),
    .read_data_2(read_data_2_after_forward_EX)
   
);


wire [31:0] ALU_result_EX;
wire        zero_flag_EX;

ALU ALU_inst (
    .ReadData1(read_data_1_after_forward_EX),
    .ReadData2(read_data_2_after_forward_EX),
    .imm32(imme_EX),
    .ALUOp(ALU_operation_EX),
    .inst(inst_EX),
    .ALUSrc(ALU_src_flag_EX),
    .PC(pc_EX),
    .jal_flag(jal_flag_EX),
    .jalr_flag(jalr_flag_EX),
    .lui_flag(lui_flag_EX),

    .ALU_result(ALU_result_EX),
    .zero(zero_flag_EX)
    
    

);

//EX_MEM
wire  [31:0]          ALU_result_MEM;
wire                  zero_flag_MEM;
wire                  mem_write_flag_MEM;
wire                  mem_to_reg_flag_MEM;
wire                  reg_write_flag_MEM;
wire                  jal_flag_MEM;
wire                  jalr_flag_MEM;
wire  [31:0]          read_data_1_MEM;
wire  [31:0]          read_data_2_MEM;
wire  [4 :0]          write_reg_idx_MEM;
wire  [31:0]          imme_MEM;
wire  [31:0]          inst_MEM;
wire  [31:0]          program_counter_prediction_MEM;  



EX_to_MEM EX_MEM_Instance(
    .clk(clk),
    .rst(rst),
    .wrong_prediction_flag(wrong_prediction_flag),
    .ALU_result_EX(ALU_result_EX),
    .zero_flag_EX(zero_flag_EX),
    .branch_flag_EX(branch_flag_EX),
    .mem_write_flag_EX(mem_write_flag_EX),
    .mem_to_reg_flag_EX(mem_to_reg_flag_EX),
    .reg_write_flag_EX(reg_write_flag_EX),
    .jal_flag_EX(jal_flag_EX),
    .jalr_flag_EX(jalr_flag_EX),
    .imme_EX(imme_EX),
    .read_data_1_EX(read_data_1_after_forward_EX),
    .read_data_2_EX(read_data_2_after_forward_EX),
    .write_reg_idx_EX(write_reg_idx_EX),
    .inst_EX(inst_EX),
    .pc_EX(pc_EX),
    .pc_prediction_EX(program_counter_prediction_EX),


    .ALU_result_MEM(ALU_result_MEM),
    .zero_flag_MEM(zero_flag_MEM),
    .branch_flag_MEM(branch_flag_MEM),//闁插秵鏌婃潏鎾冲毉娴兼fetch
    .mem_write_flag_MEM(mem_write_flag_MEM),
    .mem_to_reg_flag_MEM(mem_to_reg_flag_MEM),
    .reg_write_flag_MEM(reg_write_flag_MEM),
    .jal_flag_MEM(jal_flag_MEM),
    .jalr_flag_MEM(jalr_flag_MEM),
    .imme_MEM(imme_MEM),//鏉堟挸鍤导姝ゝetch
    .read_data_1_MEM(read_data_1_MEM),
    .read_data_2_MEM(read_data_2_MEM),
    .write_reg_idx_MEM(write_reg_idx_MEM),
    .inst_MEM(inst_MEM),
    .pc_MEM(program_counter_MEM),
    .pc_prediction_MEM(program_counter_prediction_MEM)

    
);

///// Branch Target /////

Branch Branch_Target_Instance(
    .jal_flag(jal_flag_MEM),
    .jalr_flag(jalr_flag_MEM),
    .branch_flag(branch_flag_MEM),
    .zero_flag(zero_flag_MEM),
    .read_data_1(read_data_1_MEM),
    .imme(imme_MEM),
    .program_counter(program_counter_MEM),
    .inst(inst_MEM),
    .program_counter_prediction(program_counter_prediction_MEM),

    .wrong_prediction_flag(wrong_prediction_flag),
    .branch_pc(branch_pc)
);




wire [31:0]  output_data;


Dmem Dmem_inst (
    .clk(clk),
    .addr_out(ALU_result_MEM),
    .MemWrite(mem_write_flag_MEM),
    .write_data_memio(rs2Data),
    .load_type(load_type),
    .store_type(store_type),
    .switch_in(switch),
    .number(number),
    .confirm(confirm),

    .loaded_data(output_data),
    .leds(leds),
    .segments(segments)

);


//MEM_WB


wire [31:0] read_data_WB;
wire [31:0] ALU_result_WB;
wire        mem_to_reg_flag_WB;
wire [31:0] imme_WB;




MEM_to_WB MEM_WB_Instance(
    .clk(clk),
    .rst(rst),
    .read_data_MEM(output_data),
    .ALU_result_MEM(ALU_result_MEM),
    .mem_to_reg_flag_MEM(mem_to_reg_flag_MEM),
    .reg_write_flag_MEM(reg_write_flag_MEM),
    .write_reg_idx_MEM(write_reg_idx_MEM),
    .pc_MEM(program_counter_MEM),
    

    .read_data_WB(read_data_WB),
    .ALU_result_WB(ALU_result_WB),
    .mem_to_reg_flag_WB(mem_to_reg_flag_WB),
    .reg_write_flag_WB(reg_write_flag_WB),
    .write_reg_idx_WB(write_reg_idx_WB),
    .pc_WB(pc_WB)
);



// 閸ョ偛鍟撻弫鐗堝祦闁锟??
assign r_wdata = (mem_to_reg_flag_WB) ? read_data_WB : ALU_result_WB;


Forwarding_EX Forwarding_EX_inst (
    .ALU_result_MEM(ALU_result_MEM),
    .write_reg_idx_MEM(write_reg_idx_MEM),
    .write_reg_flag_MEM(reg_write_flag_MEM),
    .mem_to_reg_flag_MEM(mem_to_reg_flag_MEM),
    .ALU_result_WB(ALU_result_WB),
    .read_data_WB(read_data_WB),
    .write_reg_idx_WB(write_reg_idx_WB),
    .write_reg_flag_WB(reg_write_flag_WB),
    .mem_to_reg_flag_WB(mem_to_reg_flag_WB),
    .read_reg_idx_1_EX(read_reg_idx_1_EX),
    .read_reg_idx_2_EX(read_reg_idx_2_EX),

    .read_data_1_forwarding(read_data_1_forwarding),
    .read_data_2_forwarding(read_data_2_forwarding),
    .read_data_1_forwarding_flag(read_data_1_forwarding_flag),
    .read_data_2_forwarding_flag(read_data_2_forwarding_flag)
);


Hazard_Detection_Unit Hazard_Detection_Unit_Instance(
    .write_reg_idx_EX(write_reg_idx_EX),
    .write_reg_flag_EX(reg_write_flag_EX),
    .mem_to_reg_flag_EX(mem_to_reg_flag_EX),
    .read_reg_idx_1_ID(rs1),
    .read_reg_idx_2_ID(rs2),

    .stall(stall_flag)
);



endmodule
