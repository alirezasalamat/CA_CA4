module ID_EX_Reg(clk , mem_write_in , mem_read_in , reg_write_in ,
                   reg_dst_in , mem_to_reg_in , ALU_src_in , ALU_op_in ,
                   read_data1_in , read_data2_in , instr15_0_signextended_in ,
                   rs_in , rt_in , rd_in , mem_write_out , mem_read_out , reg_write_out ,
                   reg_dst_out , mem_to_reg_out , ALU_src_out , ALU_op_out , read_data1_out , 
                   read_data2_out , instr15_0_signextended_out , rs_out , rt_out , rd_out);

    input clk;
    input mem_write_in , mem_read_in , reg_write_in;
    output reg mem_write_out , mem_read_out , reg_write_out;

    input reg_dst_in , mem_to_reg_in , ALU_src_in;
    output reg reg_dst_out , mem_to_reg_out , ALU_src_out;

    input [2:0] ALU_op_in;
    output reg [2:0] ALU_op_out;

    input read_data1_in , read_data2_in;
    output reg read_data1_out , read_data2_out;

    input [15:0] instr15_0_signextended_in;
    output reg [15:0] instr15_0_signextended_out;

    input [4:0] rs_in , rt_in , rd_in;
    output reg [4:0] rs_out , rt_out , rd_out;

    always @(posedge clk) begin
        mem_write_out <= mem_write_in;
        mem_read_out <= mem_read_in;
        reg_write_out <= reg_write_in;
        reg_dst_out <= reg_dst_in;
        mem_to_reg_out <= mem_to_reg_in;
        ALU_src_out <= ALU_src_in;
        ALU_op_out <= ALU_op_in;
        read_data1_out <= read_data1_in;
        read_data2_out <= read_data2_in;
        instr15_0_signextended_out <= instr15_0_signextended_in;
        rs_out <= rs_in;
        rt_out <= rt_in;
        rd_out <= rd_in;
    end
endmodule

