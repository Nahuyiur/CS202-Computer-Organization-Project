`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: scan_display
// Description: 8位数码管扫描显示模块，seg1 控制低四位段码，seg2 控制高四位段码
//////////////////////////////////////////////////////////////////////////////////

module scan_display (
    input clk,                        // 输入时钟信号（假设100MHz）
    input [31:0] data,                // 输入显示数据，每4bit表示一位十六进制数
    output reg [7:0] anode,           // 数码管位选，低电平有效
    output reg [7:0] seg1,            // 段码输出，控制 anode[0~3]
    output reg [7:0] seg2             // 段码输出，控制 anode[4~7]
);

// 七段码编码（共阴极）
function [7:0] hex_to_7seg;
    input [3:0] hex;
    begin
        case (hex)
            4'h0: hex_to_7seg = 8'b1111_1100; // Num0
            4'h1: hex_to_7seg = 8'b0110_0000; // Num1
            4'h2: hex_to_7seg = 8'b1101_1010; // Num2
            4'h3: hex_to_7seg = 8'b1111_0010; // Num3
            4'h4: hex_to_7seg = 8'b0110_0110; // Num4
            4'h5: hex_to_7seg = 8'b1011_0110; // Num5
            4'h6: hex_to_7seg = 8'b1011_1110; // Num6
            4'h7: hex_to_7seg = 8'b1110_0000; // Num7
            4'h8: hex_to_7seg = 8'b1111_1110; // Num8
            4'h9: hex_to_7seg = 8'b1111_0110; // Num9
            4'hA: hex_to_7seg = 8'b1110_1110; // NumA
            4'hB: hex_to_7seg = 8'b0011_1110; // NumB
            4'hC: hex_to_7seg = 8'b1001_1100; // NumC
            4'hD: hex_to_7seg = 8'b0111_1010; // NumD
            4'hE: hex_to_7seg = 8'b1001_1110; // NumE
            4'hF: hex_to_7seg = 8'b1000_1110; // NumF
            default: hex_to_7seg = 8'b1111_1111; // 全灭
        endcase
    end
endfunction

reg [2:0] current_digit = 3'b000;
reg [20:0] counter = 0; // 计数器用于动态刷新

// 动态扫描定时器（假设100MHz时钟，每1ms切换一位）
always @(posedge clk) begin
    counter <= counter + 1;
    if (counter >= 10000) begin
        counter <= 0;
        current_digit <= (current_digit == 3'd7) ? 3'd0 : current_digit + 1;
    end
end

// 控制数码管位选和对应段码输出
always @(*) begin
    anode = 8'b0; // 初始化位选信号
    anode[current_digit] = 1'b1; // 选中当前位
    // 取出当前位要显示的4bit数据
    case (current_digit)
        3'd0: begin
            seg1 = hex_to_7seg(data[3:0]);    
            seg2 = 8'b0;
        end
        3'd1: begin
            seg1 = hex_to_7seg(data[7:4]);    
            seg2 = 8'b0;
        end
        3'd2: begin
            seg1 = hex_to_7seg(data[11:8]);   
            seg2 = 8'b0;
        end
        3'd3: begin
            seg1 = hex_to_7seg(data[15:12]);  
            seg2 = 8'b0;
        end
        3'd4: begin
            seg2 = hex_to_7seg(data[19:16]);  
            seg1 = 8'b0;
        end
        3'd5: begin
            seg2 = hex_to_7seg(data[23:20]);  
            seg1 = 8'b0;
        end
        3'd6: begin
            seg2 = hex_to_7seg(data[27:24]);  
            seg1 = 8'b0;
        end
        3'd7: begin
            seg2 = hex_to_7seg(data[31:28]);  
            seg1 = 8'b0;
        end

    endcase
end

endmodule