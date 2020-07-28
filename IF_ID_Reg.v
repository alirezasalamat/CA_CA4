module IF_ID_Reg(clk , flush , stall , instruction_in , 
                    pc_in , instruction_out , instruction_out);
                    
    input clk , flush , stall;
    input [31:0] instruction_in , pc_in;
    output reg [31:0] instruction_out, pc_out;

    always @(posedge clk) begin
        if(stall == 1'b0) begin
            if(flush == 1'b1)begin
                instruction_out <= 32'bz;
                pc_out <= pc_in;
            end

            else begin
                instruction_out <= instruction_in;
                pc_out <= pc_in;
            end
        end

        else begin
            instruction_out <= 32'bz;
            pc_out <= 32'bz;
        end
    end
endmodule