module comparator();
    input [31:0] read_data1 , read_data2;
    output reg equal;

    always @(read_data1 or read_data2)begin
        equal = (read_data1 == read_data2) ? 1'b1 : 1'b0;
    end
endmodule