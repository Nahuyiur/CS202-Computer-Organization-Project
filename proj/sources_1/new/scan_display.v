

module scan_display (
    input clk,                    
    input base,
    input signed [31:0] data,          
    output reg [7:0] anode,           
    output reg [7:0] seg1,          
    output reg [7:0] seg2           
);

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
            default: hex_to_7seg = 8'b1111_1111; 
        endcase
    end
endfunction

reg [2:0] current_digit = 3'b000;
reg [20:0] counter = 0; 
reg isNegative=0;
reg [31:0] segData;

always @(posedge clk) begin
    counter <= counter + 1;
    if (counter >= 10000) begin
        counter <= 0;
        current_digit <= (current_digit == 3'd7) ? 3'd0 : current_digit + 1;
    end
end
always @(*) begin
    if(base==1&data[31]==1) begin
            isNegative = 1;
            segData = -data;
    end
    else begin
        segData = data;
        isNegative = 0;
    end
end
always @(*) begin
seg1=8'b0;
seg2=8'b0;
    anode = 8'b0;
    anode[current_digit] = 1'b1; 
    case (base)
    0: begin
    case (current_digit)
        3'd0: begin
            seg1 = hex_to_7seg(segData[3:0]);    
            seg2 = 8'b0;
        end
        3'd1: begin
            seg1 = hex_to_7seg(segData[7:4]);    
            seg2 = 8'b0;
        end
        3'd2: begin
            seg1 = hex_to_7seg(segData[11:8]);   
            seg2 = 8'b0;
        end
        3'd3: begin
            seg1 = hex_to_7seg(segData[15:12]);  
            seg2 = 8'b0;
        end
        3'd4: begin
            seg2 = hex_to_7seg(segData[19:16]);  
            seg1 = 8'b0;
        end
        3'd5: begin
            seg2 = hex_to_7seg(segData[23:20]);  
            seg1 = 8'b0;
        end
        3'd6: begin
            seg2 = hex_to_7seg(segData[27:24]);  
            seg1 = 8'b0;
        end
        3'd7: begin
            seg2 = hex_to_7seg(segData[31:28]);  
            seg1 = 8'b0;
        end
    endcase
    end
    1:begin
        case (current_digit)
        3'd0: begin
            seg1 = hex_to_7seg(segData%10);    
            seg2 = 8'b0;
        end
        3'd1: begin
            seg1 = hex_to_7seg((segData%100)/10);    
            seg2 = 8'b0;
        end
        3'd2: begin
            seg1 = hex_to_7seg((segData%1000)/100);    
            seg2 = 8'b0;
        end
        3'd3: begin
            seg1 = hex_to_7seg((segData%10000)/1000);       
            seg2 = 8'b0;
                end
        3'd4: begin
            seg2 = hex_to_7seg((segData%100000)/10000);    
            seg1 = 8'b0;
        end
         3'd5: begin
                   seg1 = 8'b0;    
                   seg2 = 8'b0;
                       end
       3'd6: begin
           seg1 = 8'b0;    
           seg2 = 8'b0;
       end   
        3'd7: begin
            seg2 = isNegative?8'b00000010:8'b0;  
            seg1 = 8'b0;
        end
        default:begin
            seg1 = 8'b0;
            seg2 = 8'b0;
        end
    endcase
    end
endcase

end


endmodule
