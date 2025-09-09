`timescale 1ns / 1ps

module CPU_TOP_tb;

    reg clk;
    reg rst;
    reg [2:0] number;
    reg [7:0] switch;
    reg confirm;

    wire [7:0] leds;
    wire [7:0] segment1;
    wire [7:0] segment2;
    wire [7:0] anode;
    wire [31:0] segments;
    wire [31:0] inst;
    wire [31:0] pc;
    wire [31:0] imm32;
    wire [31:0] ALUResult;

    // 实例化被测试模块
    CPU_TOP uut (
        .clk(clk),
        .rst(rst),
        .number(number),
        .switch(switch),
        .confirm(confirm),
        .leds(leds),
        .segment1(segment1),
        .segment2(segment2),
        .anode(anode),
        .segments(segments),
        .inst(inst),
        .pc(pc),
        .imm32(imm32),
        .ALUResult(ALUResult)
    );

    // 10ns 时钟周期
    initial clk = 0;
    always #5 clk = ~clk;

    // 主测试过�?
    initial begin
        // 初始化信�?
        rst = 0;
        number = 3'b000;
        confirm = 1'b0;
        switch = 8'b0;
        #1
        rst = 1; // 复位信号
        #1000
        confirm = 1;
        switch = 8'b11011101;
        
        #1000
        switch = 8'b11110111;
        #5000

        // 结束仿真
        #1000;
        $finish;
    end

endmodule
