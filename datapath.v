`timescale 1 ns / 1 ns
`include "./constant_values.vh"

module datapath(clk, rst);
    input clk, rst;

    input IF_ID_flush, IF_ID_write, pc_src, pc_jump,
            reg_write;

    output reg [5:0] opcode, func;
    
    wire [31:0] pc_out;
    instruction_mem inst_mem(pc_out, instruction);
    
    wire [31:0] mux_pc_jump_out;
    wire pc_write;
    pc program_counter(mux_pc_jump_out, pc_out, clk, rst, pc_write);

    wire [31:0] adder_pc_4_out;
    adder adder_pc_4(pc_out, `FOUR, adder_pc_4_out);

    wire [3:0] IF_ID_pc_page_out;
    wire [31:0] IF_ID_pc_plus_4_out;
    wire [31:0] IF_ID_instruction_out;

    IF_ID_Reg if_id(clk, rst,                    
                    IF_ID_flush, IF_ID_write,
                    instruction, adder_pc_4_out, pc_out[31:28],
                    IF_ID_instruction_out, IF_ID_pc_plus_4_out, IF_ID_pc_page_out);

    reg [4:0] IF_ID_rs, IF_ID_rt, IF_ID_rd;
    always @(IF_ID_instruction_out) begin
        IF_ID_rs = IF_ID_instruction_out[25:21];
        IF_ID_rt = IF_ID_instruction_out[20:16];
        IF_ID_rd = IF_ID_instruction_out[15:11];    
    end

    wire [31:0] instruction_15_0_sign_ext_out;
    sign_ext_16_to_32 instruction_15_0_sign_ext(IF_ID_instruction_out[15:0], instruction_15_0_sign_ext);

    wire [31:0] shift_left_2_out;
    shift_left_2 sh_l_2(instruction_15_0_sign_ext_out, shift_left_2_out);
    
    wire [31:0] adder_branch_out;
    adder adder_branch(IF_ID_pc_plus_4_out, shift_left_2, adder_branch_out);

    wire [31:0] mux_pc_src_out;
    mux_32_bit mux_pc_src(adder_pc_4_out, adder_branch_out, mux_pc_src_out, pc_src);

    wire [31:0] shift_jump_out;
    shifter_for_jump shift_jump(IF_ID_instruction_out, IF_ID_pc_page_out, shift_jump_out);

    mux_32_bit mux_pc_jump(mux_pc_src_out, shift_jump_out, mux_pc_jump_out, pc_jump);

    wire MEM_WB_reg_write_out;
    wire [4:0] MEM_WB_reg_dst_out;
    wire [31:0] mux_mem_to_reg_out;
    wire [31:0] reg_file_read_data_1, reg_file_read_data_2;
    register_file reg_file(IF_ID_rs, IF_ID_rt,
                            MEM_WB_reg_dst_out, mux_mem_to_reg_out, MEM_WB_reg_write_out,
                            reg_file_read_data_1, reg_file_read_data2, clk);
    
    ID_EX_Reg id_ex(clk, rst, mem_write_in, mem_read_in, reg_write_in,
                   reg_dst_in, mem_to_reg_in, ALU_src_in, ALU_op_in,
                   
                   read_data1_in, read_data2_in, instr15_0_sign_extended_in,
                   rs_in, rt_in, rd_in,
                   
                   mem_write_out, mem_read_out, reg_write_out,
                   reg_dst_out, mem_to_reg_out, ALU_src_out, ALU_op_out,
                   
                   read_data1_out, read_data2_out, instr15_0_sign_extended_out,
                   rs_out, rt_out, rd_out);

    always @(instruction) begin
        opcode = instruction[31:26];
        func = instruction[5:0];
    end

endmodule