`timescale 1 ns / 1 ns
`include "./constant_values.vh"

module mux_3_to_1_32_bit(in_0, in_1, in_2, out, sel);
    input [31:0] in_0, in_1, in_2;
    input [1:0] sel;
    output reg [31:0] out;

    always @ (in_0, in_1, in_2, sel) begin
        out = `WORD_ZERO;
        case (sel)
            2'b00: out = in_0;
            2'b01: out = in_1;
            2'b10: out = in_2;
        endcase
    end
endmodule

module mux_3_to_1_test();
    reg [31:0] in_0, in_1, in_2;
    reg [1:0] sel;
    wire [31:0] out;

    mux_3_to_1_32_bit mux(in_0, in_1, in_2, out, sel);

    initial begin
        in_0 = `WORD_ZERO;
        in_1 = `WORD_ZERO;
        in_2 = `WORD_ZERO;

        sel = 2'b01;

        #100 in_1 = 32'b1100110011001100_1100110011001100;
        #200 sel = 2'b10;

        #400 in_2 = 32'b1101110111011101_1101110111011101;
        #200;
        $stop;
    end
endmodule