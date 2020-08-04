`timescale 1 ns / 1 ns
`include "./constant_values.vh"

module EX_MEM_Reg(clk, rst,

                    mem_write_in, mem_read_in, reg_write_in, mem_to_reg_in,
                    
                    mux_reg_dst_out_in, ALU_zero_in,
                    ALU_result_in, mux_ALU_src_B_out_in,
                    
                    mem_write_out, mem_read_out, reg_write_out, mem_to_reg_out,
                    
                    mux_reg_dst_out_out, ALU_zero_out,
                    ALU_result_out, mux_ALU_src_B_out_out);
                    
    input clk, rst;
    input mem_to_reg_in;
    output reg mem_to_reg_out;

    input [4:0] mux_reg_dst_out_in;
    output reg [4:0] mux_reg_dst_out_out;

    input ALU_zero_in;
    input [31:0] ALU_result_in;
    output reg ALU_zero_out;
    output reg [31:0] ALU_result_out;

    input [31:0] mux_ALU_src_B_out_in;
    output reg [31:0] mux_ALU_src_B_out_out;
    
    input mem_read_in, mem_write_in;
    output reg mem_read_out, mem_write_out;

    input reg_write_in;
    output reg reg_write_out;

    always @(posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            mem_write_out <= 1'b0;
            mem_read_out <= 1'b0;
            reg_write_out <= 1'b0;  
            mem_to_reg_out <= 1'b0;

            mux_reg_dst_out_out <= `WORD_ZERO;
            ALU_zero_out <= 1'b0;
            ALU_result_out <= `WORD_ZERO;
            mux_ALU_src_B_out_out <= `WORD_ZERO;
        end

        else begin
            mem_write_out <= mem_write_in;
            mem_read_out <= mem_read_in;
            reg_write_out <= reg_write_in;  
            mem_to_reg_out <= mem_to_reg_in;

            mux_reg_dst_out_out <= mux_reg_dst_out_in;
            ALU_zero_out <= ALU_zero_in;
            ALU_result_out <= ALU_result_in;
            mux_ALU_src_B_out_out <= mux_ALU_src_B_out_in;
        end
    end
endmodule
