`timescale 1 ns / 1 ns
`include "./constant_values.vh"

module mux_hazard_unit(mem_write_in, mem_read_in, reg_write_in,
                        reg_dst_in, mem_to_reg_in, 
                        ALU_src_in, ALU_op_in, 
                        
                        mem_write_out, mem_read_out, reg_write_out,
                        reg_dst_out, mem_to_reg_out, 
                        ALU_src_out, ALU_op_out,
                        
                        sel);

    input mem_write_in, mem_read_in, reg_write_in,
            reg_dst_in, mem_to_reg_in, 
            ALU_src_in;
        
    input [2:0] ALU_op_in;

    input sel;

    output reg mem_write_out, mem_read_out, reg_write_out,
                        reg_dst_out, mem_to_reg_out, 
                        ALU_src_out;
    
    output reg [2:0] ALU_op_out;

    always @(mem_write_in, mem_read_in, reg_write_in,
        reg_dst_in, mem_to_reg_in, 
        ALU_src_in, ALU_op_in, sel) begin
            {mem_write_out, mem_read_out, reg_write_out,
                reg_dst_out, mem_to_reg_out, 
                ALU_src_out} = 6'b000_000;
            ALU_op_out = `ALU_OFF;
                
        if (sel == 1'b1) begin
            mem_write_out = mem_write_in;
            mem_read_out = mem_read_in;
            reg_write_out = reg_write_in;
            reg_dst_out = reg_dst_in;
            mem_to_reg_out = mem_to_reg_in;
            ALU_src_out = ALU_src_in;
            ALU_op_out = ALU_op_in;
            
        end
        $display("@%t: MUX_HAZARD_UNIT: mem_write is %d", $time, mem_write_out);
            $display("@%t: MUX_HAZARD_UNIT: mem_read is %d", $time, mem_read_out);
            $display("@%t: MUX_HAZARD_UNIT: reg_write is %d", $time, reg_write_out);
            $display("@%t: MUX_HAZARD_UNIT: reg_dst is %d", $time, reg_dst_out);
            $display("@%t: MUX_HAZARD_UNIT: mem_to_reg is %d", $time, mem_to_reg_out);
            $display("@%t: MUX_HAZARD_UNIT: alu_src is %d", $time, ALU_src_out);
            $display("@%t: MUX_HAZARD_UNIT: alu_op is %d", $time, ALU_op_out);
    end
endmodule