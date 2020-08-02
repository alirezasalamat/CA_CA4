`timescale 1 ns / 1 ns
`include "./constant_values.vh"

module datapath(clk, rst,
                IF_ID_flush, IF_ID_write, pc_src, pc_jump, pc_write,
                mem_write, mem_read, reg_write,
                reg_dst, mem_to_reg, 
                ALU_src, mux_hz_sel, ALU_op,
                forward_A, forward_B,
                opcode, func, equal,
                dp_IF_ID_rs, dp_IF_ID_rt,
                dp_ID_EX_rt, dp_EX_MEM_rd, dp_MEM_WB_rd,
                dp_ID_EX_mem_read, dp_EX_MEM_reg_write, dp_MEM_WB_reg_write);
    
    input clk, rst;

    input IF_ID_flush, IF_ID_write, pc_src, pc_jump, pc_write;

    input mem_write, mem_read, reg_write,
            reg_dst, mem_to_reg, 
            ALU_src, mux_hz_sel;

    input [2:0] ALU_op; 
    
    input [1:0] forward_A, forward_B;

    output reg [5:0] opcode, func;
    output equal;
    output [4:0] dp_IF_ID_rs, dp_IF_ID_rt,
                    dp_ID_EX_rt, dp_EX_MEM_rd,
                    dp_MEM_WB_rd;
    output dp_ID_EX_mem_read, dp_EX_MEM_reg_write, dp_MEM_WB_reg_write;

    wire [31:0] pc_out, instruction;
    instruction_mem inst_mem(pc_out, instruction);

    wire [31:0] mux_pc_jump_out;
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
    sign_ext_16_to_32 instruction_15_0_sign_ext(IF_ID_instruction_out[15:0], instruction_15_0_sign_ext_out);

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

    comparator reg_file_comparator(reg_file_read_data_1, reg_file_read_data_2, equal);

    wire mux_hz_mem_write_out, mux_hz_mem_read_out, mux_hz_reg_write_out,
            mux_hz_reg_dst_out, mux_hz_mem_to_reg_out, 
            mux_hz_ALU_src_out;
    
    wire [2:0] mux_hz_ALU_op_out;

    mux_hazard_unit mux_hz(mem_write, mem_read, reg_write,
                            reg_dst, mem_to_reg, 
                            ALU_src, ALU_op,
                            mux_hz_mem_write_out, mux_hz_mem_read_out, mux_hz_reg_write_out,
                            mux_hz_reg_dst_out, mux_hz_mem_to_reg_out, 
                            mux_hz_ALU_src_out, mux_hz_ALU_op_out,
                            mux_hz_sel);

    wire ID_EX_mem_write_out, ID_EX_mem_read_out, ID_EX_reg_write_out,
            ID_EX_reg_dst_out, ID_EX_mem_to_reg_out, ID_EX_ALU_src_out;
    
    wire [2:0] ID_EX_ALU_op_out;

    wire [31:0] ID_EX_read_data_1_out, ID_EX_read_data_2_out,
                ID_EX_instruction_15_0_sign_ext_out;

    wire [4:0] ID_EX_rs_out, ID_EX_rt_out, ID_EX_rd_out;

    ID_EX_Reg id_ex(clk, rst, mux_hz_mem_write_out, mux_hz_mem_read_out, mux_hz_reg_write_out,
                    mux_hz_reg_dst_out, mux_hz_mem_to_reg_out, mux_hz_ALU_src_out, mux_hz_ALU_op_out,
                    reg_file_read_data_1, reg_file_read_data_2, instruction_15_0_sign_ext_out,
                    IF_ID_rs, IF_ID_rt, IF_ID_rd,
                    ID_EX_mem_write_out, ID_EX_mem_read_out, ID_EX_reg_write_out,
                    ID_EX_reg_dst_out, ID_EX_mem_to_reg_out, ID_EX_ALU_src_out, ID_EX_ALU_op_out,
                    ID_EX_read_data_1_out, ID_EX_read_data_2_out,
                    ID_EX_instruction_15_0_sign_ext_out,
                    ID_EX_rs_out, ID_EX_rt_out, ID_EX_rd_out);

    
    wire [31:0] EX_MEM_ALU_result_out, mux_forward_A_out;
    mux_3_to_1_32_bit mux_forward_A(ID_EX_read_data_1_out, EX_MEM_ALU_result_out,
                                    mux_mem_to_reg_out, mux_forward_A_out, forward_A);

    wire [31:0] mux_forward_B_out;
    mux_3_to_1_32_bit mux_forward_B(ID_EX_read_data_2_out, EX_MEM_ALU_result_out,
                                    mux_mem_to_reg_out, mux_forward_B_out, forward_B);

    wire [31:0] mux_alu_src_out;
    mux_32_bit mux_alu_src(mux_forward_B_out, ID_EX_instruction_15_0_sign_ext_out,
                            mux_alu_src_out, ID_EX_ALU_src_out);
    
    wire alu_zero_out, alu_result_out;
    alu main_alu(mux_forward_A_out, mux_alu_src_out, alu_result_out, 
                    alu_zero_out, ID_EX_ALU_op_out);

    wire [4:0] mux_reg_dst_out;
    mux_32_bit mux_reg_dst(ID_EX_rt_out, ID_EX_rd_out, mux_reg_dst_out, ID_EX_reg_dst_out);

    wire EX_MEM_mem_write_out, EX_MEM_mem_read_out,
            EX_MEM_reg_write_out, EX_MEM_mem_to_reg_out;
    wire [4:0] EX_MEM_mux_reg_dst_out;
    wire EX_MEM_ALU_zero_out;
    wire [31:0] EX_MEM_mux_forward_B_out;
    EX_MEM_Reg ex_mem(clk, rst,
                        ID_EX_mem_write_out, ID_EX_mem_read_out,
                        ID_EX_reg_write_out, ID_EX_mem_to_reg_out,
                        mux_reg_dst_out, ALU_zero_out,
                        ALU_result_out, mux_forward_B_out,
                        EX_MEM_mem_write_out, EX_MEM_mem_read_out,
                        EX_MEM_reg_write_out, EX_MEM_mem_to_reg_out,
                        EX_MEM_mux_reg_dst_out, EX_MEM_ALU_zero_out,
                        EX_MEM_ALU_result_out, EX_MEM_mux_forward_B_out);

    wire [31:0] data_mem_read_data_out;
    data_mem data_memory(EX_MEM_ALU_result_out, EX_MEM_mux_forward_B_out,
                            data_mem_read_data_out, 
                            EX_MEM_mem_read_out, EX_MEM_mem_write_out,
                            clk);

    wire MEM_WB_mem_to_reg_out;
    wire [31:0] MEM_WB_read_data_out, MEM_WB_ALU_result_out;
    wire [4:0] MEM_WB_mux_reg_dst_out;
    MEM_WB_Reg mem_wb(clk, rst,
                        EX_MEM_reg_write_out, EX_MEM_mem_to_reg_out,
                        data_mem_read_data_out, EX_MEM_mux_reg_dst_out, EX_MEM_ALU_result_out,
                        MEM_WB_reg_write_out, MEM_WB_mem_to_reg_out,
                        MEM_WB_read_data_out, MEM_WB_mux_reg_dst_out, MEM_WB_ALU_result_out);
    
    mux_32_bit mux_mem_to_reg(MEM_WB_ALU_result_out, MEM_WB_read_data_out,
                                mux_mem_to_reg_out, MEM_WB_mem_to_reg_out);
    
    always @(instruction) begin
        opcode = instruction[31:26];
        func = instruction[5:0];
    end

    assign dp_IF_ID_rs = IF_ID_rs;
    assign dp_IF_ID_rt = IF_ID_rt;
    assign dp_ID_EX_rt = ID_EX_rt_out;
    assign dp_EX_MEM_rd = EX_MEM_mux_reg_dst_out;
    assign dp_MEM_WB_rd = MEM_WB_mux_reg_dst_out;
    assign dp_MEM_WB_reg_write = MEM_WB_reg_write_out;

endmodule