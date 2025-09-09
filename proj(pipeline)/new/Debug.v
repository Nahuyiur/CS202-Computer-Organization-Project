module Debug #(
    parameter MAX_CYCLE = 256
)(
    input clk,
    input rst,
    input [31:0] current_pc,
    input confirm,
    input [7:0] switch,  

    input [31:0] reg0,
    input [31:0] reg1,
    input [31:0] reg2,
    input [31:0] reg3,
    input [31:0] reg4,
    input [31:0] reg5,
    input [31:0] reg6,
    input [31:0] reg7,
    input [31:0] reg8,
    input [31:0] reg9,
    input [31:0] reg10,
    input [31:0] reg11,
    input [31:0] reg12,
    input [31:0] reg13,
    input [31:0] reg14,
    input [31:0] reg15,
    input [31:0] reg16,
    input [31:0] reg17,
    input [31:0] reg18,
    input [31:0] reg19,
    input [31:0] reg20,
    input [31:0] reg21,
    input [31:0] reg22,
    input [31:0] reg23,
    input [31:0] reg24,
    input [31:0] reg25,
    input [31:0] reg26,
    input [31:0] reg27,
    input [31:0] reg28,
    input [31:0] reg29,
    input [31:0] reg30,
    input [31:0] reg31,

    output reg [31:0] display_data
);

    reg [31:0] pc_log [0:MAX_CYCLE-1];
    reg [31:0] reg_log [0:MAX_CYCLE-1][0:31];
    reg [9:0] cycle_index;
    reg [9:0] view_index;

 
    wire [31:0] current_regfile [0:31];
    assign current_regfile[0]  = reg0;
    assign current_regfile[1]  = reg1;
    assign current_regfile[2]  = reg2;
    assign current_regfile[3]  = reg3;
    assign current_regfile[4]  = reg4;
    assign current_regfile[5]  = reg5;
    assign current_regfile[6]  = reg6;
    assign current_regfile[7]  = reg7;
    assign current_regfile[8]  = reg8;
    assign current_regfile[9]  = reg9;
    assign current_regfile[10] = reg10;
    assign current_regfile[11] = reg11;
    assign current_regfile[12] = reg12;
    assign current_regfile[13] = reg13;
    assign current_regfile[14] = reg14;
    assign current_regfile[15] = reg15;
    assign current_regfile[16] = reg16;
    assign current_regfile[17] = reg17;
    assign current_regfile[18] = reg18;
    assign current_regfile[19] = reg19;
    assign current_regfile[20] = reg20;
    assign current_regfile[21] = reg21;
    assign current_regfile[22] = reg22;
    assign current_regfile[23] = reg23;
    assign current_regfile[24] = reg24;
    assign current_regfile[25] = reg25;
    assign current_regfile[26] = reg26;
    assign current_regfile[27] = reg27;
    assign current_regfile[28] = reg28;
    assign current_regfile[29] = reg29;
    assign current_regfile[30] = reg30;
    assign current_regfile[31] = reg31;

    integer i;
    
    always @(negedge clk or negedge rst) begin
        if (~rst) begin
            cycle_index <= 0;
            view_index <= 0;
            display_data <= 0;
        end else begin
               if (cycle_index < MAX_CYCLE) begin
                pc_log[cycle_index] <= current_pc;//记录pc
                for (i = 0; i < 32; i = i + 1)
                    reg_log[cycle_index][i] <= current_regfile[i];
                cycle_index <= cycle_index + 1;
            end

        end
    end
    always @(posedge clk) begin
        if (cycle_index > 0) begin
            if(confirm && switch == 0) begin
             view_index <= view_index + 1;
             display_data <= pc_log[view_index];
           end else begin
           if(confirm && switch != 0) begin
              display_data <= reg_log[view_index][switch];
              end
           end
       end 
      end
    
    
endmodule
