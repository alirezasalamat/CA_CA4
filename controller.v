`timescale 1 ns/1 ns
`include "./constant_values.vh"

module controller(equal, opcode, func, reg_dst, alu_src, mem_to_reg ,
                  pc_jump, pc_src, reg_write, mem_read, mem_write, alu_operation, branch);
    input equal;
    input [5:0] opcode , func;
    output reg reg_dst , alu_src , mem_to_reg ,
               pc_jump , pc_src , reg_write , mem_read , mem_write;

    // 2'b00 no branch , 2'b01 beq , 2'b10 bne            
    output [1:0] branch;
    output [2:0] alu_operation;

    //alu_op parameters
    parameter MTYPE = 2'b00; // Memorey accses
    parameter BTYPE = 2'b01; // Branch
    parameter RTYPE = 2'b10; // Register
    parameter JTYPE = 2'b11; //Jump

    //opcode parameters
    parameter REGISTER_TYPE = 6'b000000;
    parameter LW = 6'b100011;
    parameter SW = 6'b101011;
    parameter BEQ = 6'b000100;
    parameter BNE = 6'b000101;
    parameter J = 6'b000010;
    parameter ADDI = 6'b001000;
    parameter ANDI = 6'b001100;

    //function parameter
    parameter ADD = 6'b100000;
    parameter AND = 6'b100100;

    reg [1:0] alu_op;
    reg branch;
    reg [5:0] ctrl_func;

    alu_controller alucntrl(alu_op, ctrl_func, alu_operation);

    //determine function for addi/andi
    always @(opcode or func) begin
        ctrl_func = 6'b0;
        if (opcode == ADDI)
            ctrl_func = ADD;
        else if (opcode == ANDI)
            ctrl_func = AND;
        else
            ctrl_func = func;
    end

    //signal branch
    always @(opcode) begin
        if(opcode == BEQ) 
            branch = 2'b01;

        else if(opcode == BNE)
            branch = 2'b10;

        else if(opcode == J)
            branch = 2'b11;

        else
            branch = 2'b00;
    end

    always @(opcode or ctrl_func or equal) begin
        {reg_dst, alu_src, mem_to_reg, pc_jump,
         pc_src, reg_write, mem_read, mem_write} = 8'b0;
        
        alu_op = 2'bzz;
        
        case (opcode)
            REGISTER_TYPE: begin
                reg_dst = 1'b1;
                reg_write = 1'b1;
                alu_op = RTYPE;
            end

            SW: begin
                alu_src = 1'b1;
                mem_write = 1'b1;
                alu_op = MTYPE;
            end

            LW: begin
                alu_src = 1'b1;
                mem_to_reg = 1'b1;
                reg_write = 1'b1;
                mem_read = 1'b1;
                alu_op = MTYPE;
            end

            BEQ: begin
                pc_src = equal;
                alu_op = BTYPE;
            end

            BNE: begin
                pc_src = ~equal;
                alu_op = BTYPE;
            end

            J: begin
                pc_jump = 1'b1;
                alu_op = JTYPE;
            end

            ADDI: begin
                alu_src = 1'b1; 
                reg_write = 1'b1;
                alu_op = RTYPE;
            end

            ANDI: begin
                alu_src = 1'b1; 
                reg_write = 1'b1;
                alu_op = RTYPE;
            end
        endcase
    end
    
endmodule