module ALU(
    input [31:0] ReadData1,
    input [31:0] ReadData2,
    input [31:0] imm32,//娴肩姴鍙嗗鑼病婢跺嫮鎮婃總鐣屾畱 imm
    input [1:0] ALUOp,
    input [31:0] inst,
    input [31:0] PC,
    input jal_flag,
    input jalr_flag,
    input lui_flag,
    input ALUSrc,
    output reg [31:0] ALU_result,
    output  zero
);

    // Internal signals
    wire [31:0] operand_2 = ALUSrc ? imm32 : ReadData2;
    wire [31:0] operand_1 = ReadData1;
    reg [3:0] ALUControl;
     wire [2:0] funct3 = inst[14:12];     // Extract funct3 (bits [14:12])
     wire [6:0] funct7 = inst[31:25];
     wire [6:0] opcode = inst[6:0];
     assign zero = (ALU_result == 0);

    // ALU control logic
    // ALUOp are defined as follows:
    // 00: S-type and load subset of I-type
    // 01: B-type
    // 10: R-type and arithmetic subset of I-type
    always @(*) begin
        case(ALUOp)
            2'b00: ALUControl = 4'b0000;  // add (for lw/sw)
            2'b01: 
               begin
                       if (funct3 == 3'b110 || funct3 == 3'b111) // bltu or bgeu
                           ALUControl = 4'b1001; // sltu
                       else if (funct3 == 3'b100 || funct3 == 3'b101) // blt or bge
                           ALUControl = 4'b1000; // slt
                       else // beq or bne
                           ALUControl = 4'b0001; // sub
                end
            2'b10: begin               
               case(funct3)
                    3'b000:
                        begin
                            if(funct7 == 7'b0000000 || opcode == 7'b0010011)
                                ALUControl = 4'b0000; // add
                            else
                                ALUControl = 4'b0001; // sub
                
                        end
                    3'b001:
                        begin
                            
                                ALUControl = 4'b0101; // sll
                        end
                      3'b010:
                       begin
                                ALUControl = 4'b1000; // slt
                        end
                      3'b011:
                      begin
                                ALUControl = 4'b1001;//sltu
                        end
                        3'b100:
                        begin
                                ALUControl = 4'b0010; // xor
                        end
                        3'b101:
                        begin
                            if(funct7 == 7'b0000000)
                                ALUControl = 4'b0110; // srl
                            else
                                ALUControl = 4'b0111; // sra
                        end
                       3'b110:
                       begin
                                ALUControl = 4'b0011;//or
                       end
                       3'b111:
                       begin
                                ALUControl = 4'b0100;//and
                       end
                endcase
            end
            default: ALUControl = 4'b1111;
        endcase
    end

    // ALU operation
    // 0000: add
    // 0001: sub
    // 0011: or
    // 0100: and
    // 1000: slt
    // 1001: sltu
    always @(*) begin
        if (jal_flag || jalr_flag) begin
        ALU_result = PC + 4;
    end 
    else if (lui_flag) begin
        ALU_result = imm32;
    end 
    else 
    begin
        case(ALUControl)
            4'b0000:
                    begin
                        ALU_result = operand_1 + operand_2;
                    end
                    4'b0001:
                    begin
                        ALU_result = operand_1 - operand_2;
                    end
                    
                    4'b0011:
                    begin
                        ALU_result = operand_1 | operand_2;
                    end
                    4'b0100:
                    begin
                        ALU_result = operand_1 & operand_2;
                    end
                    4'b0010:
                    begin
                        ALU_result = operand_1 ^ operand_2;
                    end
                    4'b0011:
                    begin
                        ALU_result = operand_1 | operand_2;
                    end
                    4'b0100:
                    begin
                        ALU_result = operand_1 & operand_2;
                    end
                    4'b0101:
                    begin
                        ALU_result = operand_1 << operand_2[4:0];
                    end
                    4'b0110:
                    begin
                        ALU_result = operand_1 >> operand_2[4:0];
                    end
                    4'b0111:
                    begin
                        ALU_result = operand_1 >>> operand_2[4:0];
                    end
                    4'b1000:
                    begin
                        ALU_result = ($signed(operand_1) < $signed(operand_2)) ? 32'b1 : 32'b0;
                    end
                    4'b1001:
                    begin
                        ALU_result = (operand_1 < operand_2) ? 32'b1 : 32'b0;
                    end
                    default:
                    begin
                        ALU_result = 32'b0;
                    end
        endcase
    end
        
    end
   

endmodule