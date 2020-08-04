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

    controller cntrl(equal, opcode, func, reg_dst, ALU_src, mem_to_reg,
                     pc_jump, pc_src, reg_write, mem_read, mem_write, ALU_op, branch);

    forwarding_unit frwrd(dp_EX_MEM_rd, dp_EX_MEM_reg_write, dp_MEM_WB_rd,
                          dp_MEM_WB_reg_write, dp_ID_EX_rs, dp_ID_EX_rt,
                          forward_A, forward_B);
    
    always @(forward_A or forward_B)
        $display("@%t: PROCESSOR: forward_A = %b, forward_B = %b", $time, forward_A, forward_B);

    data_hazard_detection_unit hzrd(dp_ID_EX_rt, dp_ID_EX_mem_read, equal,
                                    dp_IF_ID_rs, dp_IF_ID_rt, branch,
                                    pc_write, IF_ID_write , mux_hz_sel, IF_ID_flush);


endmodule


module processor_test();
    reg clk, rst;
    processor mips(clk, rst);

    initial begin
        #100
        clk = 1'b1;
        repeat(2000) #50 clk = ~clk;
    end

    initial begin
        rst = 1'b1;
        #50 rst = 1'b0;
        #7000 $stop;
        // #56600 $stop; // it is for testbench no.2

        // #24300 $stop; // it is for testbench no.1
        
    end
endmodule