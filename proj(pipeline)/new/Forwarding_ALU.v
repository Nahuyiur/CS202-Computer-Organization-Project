`timescale 1ns / 1ps

module Forwarding_ALU(
    input [31:0] read_data_1_reg,
    input [31:0] read_data_2_reg,//娴犲窎egester file娑擃叀顕伴崙铏规畱閺佺増宓�
    input [31:0] read_data_1_forwarding,
    input [31:0] read_data_2_forwarding,//娴犲锭orwarding_EX閸楁洖鍘撴稉顓☆嚢閸戣櫣娈戦弫鐗堝祦
    input read_data_1_forwarding_flag,
    input read_data_2_forwarding_flag,

    output [31:0] read_data_1,
    output [31:0] read_data_2
);

assign read_data_1 = (read_data_1_forwarding_flag) ? read_data_1_forwarding : read_data_1_reg;
assign read_data_2 = (read_data_2_forwarding_flag) ? read_data_2_forwarding : read_data_2_reg;
endmodule