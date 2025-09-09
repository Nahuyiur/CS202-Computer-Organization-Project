module Controller(
    input [31:0] inst,
    output reg Branch,
    output reg [1:0] ALUOp,
    output reg ALUSrc,
    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output wire jal_flag,           
    output wire jalr_flag,          
    output wire lui_flag,            
    output reg [2:0] load_type,   // 加载类型
    output reg [2:0] store_type,  // 存储类型
    output reg [6:0] opcode,
    output reg MemorIOtoReg       // 新增信号
);

    wire [2:0] funct3 = inst[14:12];

    always @(*) begin
        // 提取 opcode
        opcode = inst[6:0];

        // 默认控制信号值
        Branch = 0;
        ALUOp = 2'b00;
        ALUSrc = 0;
        RegWrite = 0;
        MemRead = 0;
        MemWrite = 0;
        load_type = 3'b000;
        store_type = 3'b000;
        MemorIOtoReg = 0;


        case (opcode)
            7'b0110011: begin // R-type
                ALUOp = 2'b10;
                RegWrite = 1;

            end

            7'b0000011: begin // I-type load
                ALUSrc = 1;
                ALUOp = 2'b00;
                RegWrite = 1;
                MemRead = 1;
                load_type = funct3;
                MemorIOtoReg = 1; // 从内存或 I/O 写回
            end

            7'b0010011: begin // I-type 算术立即数指令（如 addi, andi, ori...）
                ALUSrc = 1;           // 使用立即数作为第二个操作数
                ALUOp = 2'b10;        // 可与 R-type 共用同一个 ALU 控制路径
                RegWrite = 1;         // 写寄存器
                MemRead = 0;
                MemWrite = 0;
                MemorIOtoReg = 0;     // 写回来源于 ALU，而不是内存/I/O
            end
            7'b0100011: begin // S-type store
                ALUSrc = 1;
                ALUOp = 2'b00;
                MemWrite = 1;
                store_type = funct3;
            end

            7'b1100011: begin // B-type branch
                ALUOp = 2'b01;
                Branch = 1;
            end
        endcase
    end

    assign jal_flag   = opcode == 7'b1101111;
    assign jalr_flag  = opcode == 7'b1100111;
    assign lui_flag   = opcode == 7'b0110111;

endmodule