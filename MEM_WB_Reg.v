`timescale 1 ns / 1 ns
`include "./constant_values.vh"

module MEM_WB_Reg(clk, rst,
                    
                    reg_write_in, mem_to_reg_in,
                    
                    read_data_in, mux_reg_dst_out_in, ALU_result_in,
                    
                    reg_write_out, mem_to_reg_out,
                    
                    read_data_out, mux_reg_dst_out_out, ALU_result_out);

    input clk, rst;

    input reg_write_in;
    output reg reg_write_out;

    input mem_to_reg_in;
    output reg mem_to_reg_out;

    input [31:0] read_data_in;
    output reg [31:0] read_data_out;

    input [4:0] mux_reg_dst_out_in;
    output reg [4:0] mux_reg_dst_out_out;

    input [31:0] ALU_result_in;
    output reg [31:0] ALU_result_out;

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            reg_write_out <= 1'b0;
            mem_to_reg_out <= 1'b0;
            
            read_data_out <= `WORD_ZERO;
            mux_reg_dst_out_out <= `WORD_ZERO;
            ALU_result_out <= `WORD_ZERO;            
        end
        
        else begin
        reg_write_out <= reg_write_in;
        mem_to_reg_out <= mem_to_reg_in;
        
        read_data_out <= read_data_in;
        mux_reg_dst_out_out <= mux_reg_dst_out_in;
        ALU_result_out <= ALU_result_in;
        end
    end
endmodule