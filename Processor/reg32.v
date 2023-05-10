module reg32(out, in, clk, en, clr);

    input [31:0] in;
    input en, clk, clr;
    output [31:0] out;

    genvar i;
    generate 
        for (i=0; i < 32; i = i + 1) begin: loop1
            dffe_ref a_dff(.q(out[i]), .d(in[i]), .clk(clk), .en(en), .clr(clr));
        end
    endgenerate

endmodule