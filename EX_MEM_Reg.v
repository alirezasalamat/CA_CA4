module EX_MEM_Reg(clk ,  mem_write_in , mem_read_in , reg_write_in ,
                    mem_to_reg_in ,  mux_reg_dst_out_in , ALU_zero_in ,
                    ALU_result_in , mux_ALU_src_B_out_in , mem_write_out ,
                    mem_read_out , reg_write_out , mem_to_reg_out ,
                    mux_reg_dst_out_out , ALU_zero_out , ALU_result_out,
                    mux_ALU_src_B_out_out);
                    
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
    
    always @(posedge clk) begin

        mem_write_out <= mem_write_in;
        mem_read_out <= mem_read_in;
        reg_write_out <= reg_write_in;  
        mem_to_reg_out <= mem_to_reg_in;
        mux_reg_dst_out_out <= mux_reg_dst_out_in;
        ALU_zero_out <= ALU_zero_in;
        ALU_result_out <= ALU_result_in;
        mux_ALU_src_B_out_out <= mux_ALU_src_B_out_in;
    
    end
endmodule
