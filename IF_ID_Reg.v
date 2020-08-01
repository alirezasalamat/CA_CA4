`include "constant_values.h"

module IF_ID_Reg(clk , flush , IF_ID_write , instruction_in , 
                    pc_in , instruction_out , pc_out);
                    
    input clk , flush , IF_ID_write;
    input [31:0] instruction_in , pc_in;
    output reg [31:0] instruction_out, pc_out;

    always @(posedge clk) begin
        if(IF_ID_write == 1'b1) begin
            if(flush == 1'b1)begin
                instruction_out <= `WORD_ZERO;
                pc_out <= `WORD_ZERO;
            end

            else begin
                instruction_out <= instruction_in;
                pc_out <= pc_in;
            end
        end

        else begin
            instruction_out <= `WORD_ZERO;
            pc_out <= `WORD_ZERO;
        end
    end
endmodule