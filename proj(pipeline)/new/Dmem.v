module Dmem(
    input rst,
    input clk,
    input [31:0] addr_out,           // ??掳??鈧�???rs1 + imm???
    input MemWrite,
    input [2:0] store_type,
    input [2:0] load_type,
    input [31:0] write_data_memio,
    input [7:0] switch_in,          // ?陇-茅?篓????鈥�?猫?"?鈥�?
    input [2:0] number,
    input confirm,
    output reg [31:0] loaded_data,   // ?? 猫????"???猫?"???
    output reg [7:0] leds,      // LED ????鈥�???"???猫?"????????? 16 ?????鈥�
    output reg [31:0] segments  // ???茅?鈥懊�?"???
  

);

    // ??掳??鈧�?????鈥�
    localparam LED_ADDR    = 32'h0000_0000;
    localparam SWITCH_ADDR = 32'h0000_0010;
    localparam SEGMENT_ADDR = 32'h0000_0001;
    localparam NUMBER_ADDR = 32'h0000_0011;
    localparam CONFIRM_ADDR = 32'h0000_0012;
    wire [31:0] output_data_raw;
    // IO猫??茅-???陇?-?
    wire is_io_read  = (addr_out == SWITCH_ADDR | addr_out==NUMBER_ADDR | addr_out==CONFIRM_ADDR);
    wire is_io_write = (addr_out == LED_ADDR| addr_out==SEGMENT_ADDR);

    // ????鈥�???搂??????? ??'????茅????掳???
    reg [3:0] wea_mask;

    // ???茅?鈥�??鈥�???猫??茅-??????路????????篓茅?? IO ??掳??鈧�????"篓???
    wire mem_access = ~(is_io_read | is_io_write);

    RAM RAM (
        .clk(clk),
        .addr(addr_out[15:2]),       // ??鈥�??-?????鈧�
        .we({4{MemWrite & mem_access}}), // ??鈥�??篓茅?? IO ??掳??鈧�?-?????鈥�?
        .din(write_data_memio),
        .dout(output_data_raw)
    );

    // ????鈥�?LED茅鈧�?猫?'?????? 16 ?????鈥�?????鈥�??篓??????猫????"??? LED ??掳??鈧�?-?
    always @(posedge clk) begin
        if (~rst) begin
            leds <= 8'b0; // ?陇?????-??鈥�?茅-? LED
            segments <= 32'b0; // ?陇?????-??鈥�?茅-???掳? ????
        end
        else if (MemWrite && is_io_write) begin
            case (addr_out)
                LED_ADDR: begin
                    leds <= write_data_memio[7:0]; // ?鈥β�?篓????鈥�?
                    segments <= segments;
                end
                SEGMENT_ADDR: begin
                    leds <= 8'b0;
                    segments <= {24'b0,write_data_memio[7:0]}; // ?鈥β�?篓????鈥�?
                end
                default: begin
                    leds <= leds; // 茅??猫?陇?鈥�?茅-?
                    segments <= segments; // 茅??猫?陇?鈥�?茅-?
                end
            endcase
        end
        else begin
            leds <= leds; // 茅??猫?陇?鈥�?茅-?
            segments <= segments; // 茅??猫?陇?鈥�?茅-?

        end
      
    end

    // 猫????-??掳???茅鈧�?猫?'
always @(*) begin
    if (is_io_read) begin
        case (addr_out)
            SWITCH_ADDR: begin
                if (load_type == 3'b000) begin
                    loaded_data = {{24{switch_in[7]}}, switch_in[7:0]};  // lb
                end else begin
                    loaded_data = {24'b0, switch_in[7:0]};               // lbu
                end
            end
            NUMBER_ADDR:begin
                    loaded_data = {29'b0, number[2:0]};  // lb
            end
            CONFIRM_ADDR:begin
                    loaded_data = {31'b0,confirm};  // lb
            end
            
            endcase
            end
else begin
        // ??鈥�???猫????-???? ???? load_type ??????
        case (load_type)
            3'b000: loaded_data = {{24{output_data_raw[7]}}, output_data_raw[7:0]};   // lb
            3'b001: loaded_data = {{16{output_data_raw[15]}}, output_data_raw[15:0]}; // lh
            3'b010: loaded_data = output_data_raw;                                    // lw
            3'b100: loaded_data = {24'b0, output_data_raw[7:0]};                       // lbu
            3'b101: loaded_data = {16'b0, output_data_raw[15:0]};                      // lhu
            default: loaded_data = 32'b0;
        endcase
    end
    end

endmodule