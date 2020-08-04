`include "./constant_values.vh"

module IF_ID_Reg(clk, rst,
                    
                    flush, IF_ID_write, 
                    
                    instruction_in, pc_plus_4_in, pc_page_in,
                    
                    instruction_out, pc_plus_4_out, pc_page_out);
                    
    input clk , rst;
    
    input flush , IF_ID_write;
    
    input [31:0] instruction_in , pc_plus_4_in;
    input [3:0] pc_page_in;
    
    output reg [31:0] instruction_out, pc_plus_4_out;
    output reg [3:0] pc_page_out;

    always @(posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            instruction_out <= `WORD_ZERO;
            pc_plus_4_out <= `WORD_ZERO;
            pc_page_out <= 4'b0000;
            $display("@%t: IF_ID_REG::RESET", $time);
        end
        
        else begin
            if (IF_ID_write == 1'b1) begin
                if (flush == 1'b1) begin
                    instruction_out <= `WORD_ZERO;
                    pc_plus_4_out <= `WORD_ZERO;
                    pc_page_out <= 4'b0000;
                    $display("@%t: IF_ID_REG::FLUSH", $time);
                end

                else begin
                    instruction_out <= instruction_in;
                    pc_plus_4_out <= pc_plus_4_in;
                    pc_page_out <= pc_page_in;
                    $display("@%t: IF_ID_REG::WRITE", $time);
                end
            end
        end
    end
endmodule