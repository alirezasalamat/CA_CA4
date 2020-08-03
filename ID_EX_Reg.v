`timescale 1 ns / 1 ns
`include "./constant_values.vh"

module ID_EX_Reg(clk, rst, mem_write_in, mem_read_in, reg_write_in,
                   reg_dst_in, mem_to_reg_in, ALU_src_in, ALU_op_in,
                   
                   read_data1_in, read_data2_in, instr15_0_sign_extended_in,
                   rs_in, rt_in, rd_in,
                   
                   mem_write_out, mem_read_out, reg_write_out,
                   reg_dst_out, mem_to_reg_out, ALU_src_out, ALU_op_out,
                   
                   read_data1_out, read_data2_out, instr15_0_sign_extended_out,
                   rs_out, rt_out, rd_out);

    input clk, rst;
    
    input mem_write_in , mem_read_in , reg_write_in;
    output reg mem_write_out , mem_read_out , reg_write_out;

    input reg_dst_in , mem_to_reg_in , ALU_src_in;
    output reg reg_dst_out , mem_to_reg_out , ALU_src_out;

    input [2:0] ALU_op_in;
    output reg [2:0] ALU_op_out;

    input [31:0] read_data1_in , read_data2_in;
    output reg [31:0] read_data1_out , read_data2_out;

    input [31:0] instr15_0_sign_extended_in;
    output reg [31:0] instr15_0_sign_extended_out;

    input [4:0] rs_in , rt_in , rd_in;
    output reg [4:0] rs_out , rt_out , rd_out;

    always @(posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            mem_write_out <= 1'b0;
            mem_read_out <= 1'b0;
            reg_write_out <= 1'b0;
            reg_dst_out <= 1'b0;
            mem_to_reg_out <= 1'b0;
            ALU_src_out <= 1'b0;
            ALU_op_out <= 3'b0;

            read_data1_out <= `WORD_ZERO;
            read_data2_out <= `WORD_ZERO;
            instr15_0_sign_extended_out <= `WORD_ZERO;
            rs_out <= 5'b00000;
            rt_out <= 5'b00000;
            rd_out <= 5'b00000;    
            $display("@%t: ID_EX_REG::RESET", $time);
        end
        
        else begin
            mem_write_out <= mem_write_in;
            mem_read_out <= mem_read_in;
            reg_write_out <= reg_write_in;
            reg_dst_out <= reg_dst_in;
            mem_to_reg_out <= mem_to_reg_in;
            ALU_src_out <= ALU_src_in;
            ALU_op_out <= ALU_op_in;

            read_data1_out <= read_data1_in;
            read_data2_out <= read_data2_in;
            instr15_0_sign_extended_out <= instr15_0_sign_extended_in;
            rs_out <= rs_in;
            rt_out <= rt_in;
            rd_out <= rd_in;
            
            $display("@%t: ID_EX_REG::WRITE", $time);
        end
    end
endmodule