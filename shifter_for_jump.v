`timescale 1 ns / 1 ns

module shifter_for_jump(instructs, pc_page, shifted_address);
    output reg [31:0] shifted_address;
    input [31:0] instructs;
    input [3:0] pc_page;
    always @(instructs or pc_page) begin
        shifted_address = {pc_page, instructs[25:0], 2'b00};
    end
endmodule


module shifter_for_jump_test();
    wire [31:0] shifted_address;
    reg [31:0] instructs, pc;

    shifter_for_jump shfj(instructs , pc[31:28] , shifted_address);

    initial begin
        #400
        instructs = 32'b0000001111111100_0000111000111011;
        pc = 32'b1000000000000000_0000000000000000;
        #400
        $stop;
    end
endmodule