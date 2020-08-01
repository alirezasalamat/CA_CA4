module data_hazard_detection_unit(ID_EX_rt, ID_EX_mem_read , equal , IF_ID_rs , IF_ID_rt,
                                   branch , pc_write , IF_ID_write , mux_hz_unit , flush);

    input [31:0] ID_EX_rt;
    input ID_EX_mem_read , equal;
    input [4:0] IF_ID_rs , IF_ID_rt;
    input [1:0] branch;

    output reg pc_write , IF_ID_write , mux_hz_unit , flush;

    always @(ID_EX_mem_read or IF_ID_rt or IF_ID_rs or ID_EX_rt)begin
        pc_write = 1'b1;
        IF_ID_write = 1'b1;
        mux_hz_unit = 1'b1;

        if(ID_EX_mem_read == 1'b1 && (IF_ID_rs == ID_EX_rt || IF_ID_rt == ID_EX_rt))begin
            pc_write = 1'b0;
            IF_ID_write = 1'b0;
            mux_hz_unit = 1'b0;
        end
    end

    always @(branch)begin
        if(branch == 2'b01 && equal == 1'b1) begin
            flush = 1'b1;
        end

        else if(branch == 2'b10 && equal == 1'b0) begin
            flush = 1'b1;
        end

        else if(branch == 2'b11) begin
            flush = 1'b1;
        end
        
        else if(branch == 2'b00) begin
            flush = 1'b0;
        end
    end
endmodule
