`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/17 10:40:18
// Design Name: 
// Module Name: RAM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RAM(
    input clk,
    input [13:0] addr,         // 地址宽度支持 16K x 32bit = 64KB（addr[13:0]），注意字对齐
    input [31:0] din,
    input [3:0] we,           // 按字节写使能
    output reg [31:0] dout
);

    // 16384 个字（32bit），对应 64KB 空间
    reg [7:0] mem [0:1023];  // 字节地址访问（更灵活）

    always @(posedge clk) begin
        // 写操作：按字节写
        if (we) 
        begin
            mem[{addr, 2'b00} + 0] <= din[7:0];
            mem[{addr, 2'b00} + 1] <= din[15:8];
            mem[{addr, 2'b00} + 2] <= din[23:16];
            mem[{addr, 2'b00} + 3] <= din[31:24];
        end
    end

    always @(*) begin
        // 读操作：按字节读
        dout[7:0]   = mem[{addr, 2'b00} + 0];
        dout[15:8]  = mem[{addr, 2'b00} + 1];
        dout[23:16] = mem[{addr, 2'b00} + 2];
        dout[31:24] = mem[{addr, 2'b00} + 3];
    end

endmodule