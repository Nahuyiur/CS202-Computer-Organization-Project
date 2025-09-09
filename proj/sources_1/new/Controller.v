module Controller(
    input [31:0] inst,
    output reg Branch,
    output reg [1:0] ALUOp,
    output reg ALUSrc,
    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg jal_flag,           
    output reg jalr_flag,          
    output reg lui_flag,  
    output reg auipc_flag,
    output reg ecall_flag,             
    output reg [2:0] load_type,  
    output reg [2:0] store_type,  
    output reg [6:0] opcode,
    output reg MemorIOtoReg     
);

    wire [2:0] funct3 = inst[14:12];

    always @(*) begin

        opcode = inst[6:0];

        Branch = 0;
        ALUOp = 2'b00;
        ALUSrc = 0;
        RegWrite = 0;
        MemRead = 0;
        MemWrite = 0;
        load_type = 3'b000;
        store_type = 3'b000;
        MemorIOtoReg = 0;
        jal_flag = 0;
        jalr_flag = 0;
        lui_flag = 0;
        auipc_flag = 0;
        ecall_flag = 0;
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
                MemorIOtoReg = 1; 
            end

            7'b0010011: begin // I-type 
                ALUSrc = 1;          
                ALUOp = 2'b10;      
                RegWrite = 1;         
                MemRead = 0;
                MemWrite = 0;
                MemorIOtoReg = 0;    
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

            7'b1101111: begin // JAL
                RegWrite = 1;
                jal_flag = 1;
                Branch = 1;
            end

            7'b1100111: begin // JALR
                RegWrite = 1;
                Branch = 1;
                jalr_flag = 1;
            end

            7'b0110111: begin // LUI
                ALUSrc = 1;
                RegWrite = 1;
                lui_flag = 1;
            end
            7'b0010111: begin // AUIPC
                ALUSrc = 1;
                RegWrite = 1;
                auipc_flag = 1;
            end
            7'b1110011: begin // SYSTEM 
                if (inst[31:20] == 12'b000000000000) begin // ecall
                    ecall_flag = 1;
                    MemorIOtoReg = 1;
                end
            end
        endcase
    end

endmodule