`timescale 1 ns / 1 ns
`include "./constant_values.vh"

module processor(clk,rst);
    
    input clk, rst;

    wire IF_ID_flush, IF_ID_write, pc_src, pc_jump, pc_write;
    wire mem_write, mem_read, reg_write,
            reg_dst, mem_to_reg, 
            ALU_src, mux_hz_sel;
    wire [2:0] ALU_op; 
    
    wire [1:0] forward_A, forward_B;

    wire [5:0] opcode, func;
    wire equal;
    wire [4:0] dp_IF_ID_rs, dp_IF_ID_rt,
                    dp_ID_EX_rt, dp_ID_EX_rs, dp_EX_MEM_rd,
                    dp_MEM_WB_rd;
    wire dp_ID_EX_mem_read, dp_EX_MEM_reg_write, dp_MEM_WB_reg_write;
    wire [1:0] branch;


    datapath dp(clk, rst, IF_ID_flush, IF_ID_write, pc_src, pc_jump, pc_write,
                mem_write, mem_read, reg_write,
                reg_dst, mem_to_reg, 
                ALU_src, mux_hz_sel, ALU_op,
                forward_A, forward_B,
                opcode, func, equal,
                dp_IF_ID_rs, dp_IF_ID_rt,
                dp_ID_EX_rt, dp_ID_EX_rs, dp_EX_MEM_rd, dp_MEM_WB_rd,
                dp_ID_EX_mem_read, dp_EX_MEM_reg_write, dp_MEM_WB_reg_write);

    controller cntrl(equal, opcode, func, reg_dst, jal_reg, );

    forwarding_unit frwrd(dp_EX_MEM_rd, dp_EX_MEM_reg_write, dp_MEM_WB_rd,
                          dp_MEM_WB_reg_write, dp_ID_EX_rs, dp_ID_EX_rt,
                          forward_A, forward_B);

    data_hazard_detection_unit hzrd(dp_ID_EX_rt, dp_ID_EX_mem_read, equal,
                                    dp_IF_ID_rs, dp_IF_ID_rt, branch,
                                    pc_write, IF_ID_write , mux_hz_sel, IF_ID_flush);


endmodule