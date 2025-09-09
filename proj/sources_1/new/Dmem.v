module Dmem(
    input rst,
    input clk,
    input [31:0] addr_out,       
    input MemWrite,
    input [2:0] store_type,
    input [2:0] load_type,
    input [31:0] write_data_memio,
    input [7:0] switch_in,        
    input [2:0] number,
    input confirm,
    input ecall_flag,
    input [31:0] a0,
    input [31:0] a7,
    output reg base,
    output reg [31:0] loaded_data,   
    output reg [7:0] leds,     
    output reg [31:0] segments
 );       

    localparam LED_ADDR    = 32'h0000_2000;
    localparam SWITCH_ADDR = 32'h0000_2010;
    localparam SEGMENT_ADDR = 32'h0000_2001;
    localparam NUMBER_ADDR = 32'h0000_2011;
    localparam CONFIRM_ADDR = 32'h0000_2012;
    localparam BASE_ADDR = 32'h0000_2002;
    wire [31:0] output_data_raw;
    wire is_io_read  = (addr_out == SWITCH_ADDR | addr_out==NUMBER_ADDR | addr_out==CONFIRM_ADDR);
    wire is_io_write = (addr_out == LED_ADDR| addr_out==SEGMENT_ADDR|addr_out==BASE_ADDR);

    wire mem_access = ~(is_io_read | is_io_write);

    RAM RAM (
        .clk(clk),
        .addr(addr_out[15:2]),     
        .we(MemWrite & mem_access),
        .din(write_data_memio),
        .dout(output_data_raw)
    );


    always @(posedge clk) begin
        if (~rst) begin
            leds <= 8'b0; 
            segments <= 32'b0; 
            base <= 0;
        end
        else if (MemWrite && is_io_write) begin
            case (addr_out)
                LED_ADDR: begin
                    leds <= write_data_memio[7:0]; 
                    segments <= 8'b0;
                    base <= base;
                end
                SEGMENT_ADDR: begin
                    leds <= 8'b0;
                    segments <= write_data_memio;
                    base <= base;
                end
                BASE_ADDR: begin
                    leds <= leds; 
                    segments <= segments; 
                    base <= write_data_memio[0];
                end
                default: begin
                    leds <= leds; 
                    segments <= segments;
                    base <= base;
                end
            endcase
        end
        else if (a7==32'd1&ecall_flag) begin
            leds <= 8'b0;
            segments <= a0; 
            base <= base;
        end
        else begin
            leds <= leds; 
            segments <= segments; 
            base <= base;

        end
      
    end

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
            else if(a7==32'd5&ecall_flag) begin
                    loaded_data = {{24{switch_in[7]}}, switch_in[7:0]};  // lb
            end
           else begin
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
