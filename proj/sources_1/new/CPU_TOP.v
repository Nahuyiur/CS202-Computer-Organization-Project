module CPU_TOP(
    input         clkin,        
    input         rst,
    input [2:0] number,
    input  [7:0] switch,        
    input confirm,
    output [7:0] leds,
    output [7:0] segment1,
    output [7:0] segment2,
    output [7:0] anode,
    input start_pg,
    input rx,
    output tx,
    output kickOff
);
wire upg_clk_i;
wire upg_clk_o;
wire upg_wen_o;      
wire upg_done_o;    
wire [14:0] upg_adr_o;     
wire [31:0] upg_dat_o;  
wire spg_bufg;
 BUFG U1(.I(start_pg), .O(spg_bufg));   
 reg upg_rst;
 uart_bmpg_0 uart_bmpg_0_inst(
    .upg_clk_i(upg_clk_i),
    .upg_rst_i(upg_rst),
    .upg_rx_i(rx),
    .upg_clk_o(upg_clk_o),
    .upg_wen_o(upg_wen_o),
    .upg_done_o(upg_done_o),
    .upg_adr_o(upg_adr_o),
    .upg_dat_o(upg_dat_o)
 );
 always @ (posedge clkin) begin
    if(~rst) begin
        upg_rst <= 1'b1;
    end 
    if (spg_bufg) begin
        upg_rst <= 1'b0;
    end
 end

 wire rst1;      
assign rst1 = rst | !upg_rst;
//µ÷Õû
wire clk;
cpuclk clk_gen (
    .clk_in1(clkin),
    .clk_out1(clk),
    .clk_out2(upg_clk_i)
);

wire [31:0] a0;
wire [31:0] a7;
wire [31:0] segments;
wire [31:0] pc;
wire [31:0] inst;
wire [31:0] imm32;
wire [31:0] ALUResult;
wire lui_flag;
wire auipc_flag;
wire [31:0] rs2Data;
wire [31:0] output_data;
wire zero;
wire Branch;
wire [31:0] r_wdata;
wire [31:0] rs1Data;
wire         ALUSrc, MemRead, MemWrite, RegWrite, MemorIOtoReg;
wire [1:0]  ALUOp;
wire [2:0]  load_type, store_type;
wire [6:0]  opcode;
reg [2:0] last_number;
wire reset_pc;
wire jal_flag;
wire jalr_flag;
wire ecall_flag;
wire base;

assign reset_pc = (number != last_number);

always @(posedge clk or posedge rst) begin
    if (~rst)
        last_number <= 3'b0;
    else
        last_number <= number;
end

scan_display scan_display_inst (
    .clk(clk),
    .data(segments), 
    .anode(anode),       
    .seg1(segment1), 
    .seg2(segment2), 
    .base(base)
);
// æ¨¡å—å®žä¾‹ï¿???
IFetch IFetch_inst (
    .clk(clk),
    .rst(rst),
    .branch(Branch),     
    .imm32(imm32),     
    .zero(zero),        
    .inst(inst),
    .pc(pc),
    .reset_pc(reset_pc), 
    .rs1Data(rs1Data), 
    .jalr_flag(jalr_flag), 
    .jal_flag(jal_flag),  
    .upg_rst_i(upg_rst),  
    .upg_clk_i(upg_clk_o), 
   .upg_wen_i(upg_wen_o & (~upg_adr_o[14])),
    .upg_adr_i(upg_adr_o[13:0]),
    .upg_dat_i(upg_dat_o), 
    .upg_done_i(upg_done_o), 
    .kickOff(kickOff)
);


Controller controller_inst (
    .inst(inst),
    .Branch(Branch),
    .ALUOp(ALUOp),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .load_type(load_type),
    .store_type(store_type),
    .opcode(opcode),
    .MemorIOtoReg(MemorIOtoReg),
    .jal_flag(jal_flag),          
    .jalr_flag(jalr_flag),        
    .lui_flag(lui_flag),           
    .ecall_flag(ecall_flag),      
    .auipc_flag(auipc_flag)      
    
);

Decoder Decoder_inst (
    .clk(clk),
    .rst(rst1),
    .regWrite(RegWrite),
    .inst(inst),
    .writeData(r_wdata),
    .rs1Data(rs1Data),
    .rs2Data(rs2Data),
    .imm32(imm32),
    .a0(a0),
    .a7(a7),
    .ecall_flag(ecall_flag)       
);

ALU ALU_inst (
    .ReadData1(rs1Data),
    .ReadData2(rs2Data),
    .imm32(imm32),
    .ALUOp(ALUOp),
    .inst(inst),
    .ALUSrc(ALUSrc),
    .ALU_result(ALUResult),
    .zero(zero),
    .jal_flag(jal_flag),          
    .jalr_flag(jalr_flag),     
    .lui_flag(lui_flag),       
    .auipc_flag(auipc_flag),        
    .pc(pc)
);

Dmem Dmem_inst (
    .rst(rst),
    .clk(clk),
    .addr_out(ALUResult),
    .MemWrite(MemWrite),
    .write_data_memio(rs2Data),
    .load_type(load_type),
    .store_type(store_type),
    .switch_in(switch),
    .number(number),
    .confirm(confirm),
    .loaded_data(output_data),
    .leds(leds),
    .segments(segments),
    .base(base),
    .ecall_flag(ecall_flag),
    .a0(a0),
    .a7(a7)
);

assign r_wdata = (MemorIOtoReg) ? output_data : ALUResult;

endmodule
