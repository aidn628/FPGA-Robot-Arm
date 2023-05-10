module decoder_tb;
    wire [31:0] out;
    wire [4:0] in;

    decoder d(out, in);
    assign {in} = i[4:0];
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            #10;
            $display("in %d, o2: %b, o31: %b, o0: %b", in, out[2], out[31], out[0]);
        end
    end

endmodule