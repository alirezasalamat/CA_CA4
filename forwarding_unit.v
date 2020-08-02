`timescale 1 ns / 1 ns
`include "./constant_values.h"

module forwarding_unit(EX_MEM_rd_out, EX_MEM_reg_write_out,
                        MEM_WB_rd_out, MEM_WB_reg_write_out,
                        ID_EX_rs_out, ID_EX_rt_out,
                        forward_A, forward_B);

    // an additional 3-to-1 mux is added before each alu input
    // which would select output as following:
    // 00: no forwarding
    // 01: forward from ex_mem
    // 10: forward from mem_wb

    input EX_MEM_reg_write_out, MEM_WB_reg_write_out;
    input [4:0] EX_MEM_rd_out, MEM_WB_rd_out, ID_EX_rs_out, ID_EX_rt_out;

    output reg [1:0] forward_A, forward_B;

    wire forward_A_from_ex_mem, forward_A_from_mem_wb;
    wire forward_B_from_ex_mem, forward_B_from_mem_wb;

    assign forward_A_from_ex_mem = (EX_MEM_reg_write_out == 1'b1) && 
                                    (ID_EX_rs_out == EX_MEM_rd_out) &&
                                    (EX_MEM_rd_out != 5'b00000);

    assign forward_A_from_mem_wb = (MEM_WB_reg_write_out == 1'b1) &&
                                    (ID_EX_rs_out == MEM_WB_rd_out) &&
                                    (MEM_WB_rd_out != 5'b00000) &&
                                    (~forward_A_from_ex_mem);

    assign forward_B_from_ex_mem = (EX_MEM_reg_write_out == 1'b1) && 
                                    (ID_EX_rt_out == EX_MEM_rd_out) &&
                                    (EX_MEM_rd_out != 5'b00000);

    assign forward_B_from_mem_wb = (MEM_WB_reg_write_out == 1'b1) &&
                                    (ID_EX_rt_out == MEM_WB_rd_out) &&
                                    (MEM_WB_rd_out != 5'b00000) &&
                                    (~forward_A_from_ex_mem);

    always @(forward_A_from_ex_mem or forward_A_from_mem_wb) begin
        forward_A = 2'b00;
        if (forward_A_from_ex_mem == 1'b1)
            forward_A = 2'b01;
        if (forward_A_from_mem_wb == 1'b1)
            forward_A = 2'b10;    
    end

    always @(forward_B_from_ex_mem or forward_B_from_mem_wb) begin
        forward_B = 2'b00;
        if (forward_B_from_ex_mem == 1'b1)
            forward_B = 2'b01;
        if (forward_B_from_mem_wb == 1'b1)
            forward_B = 2'b10;    
    end

endmodule