module decoder(out, select);
    output [31:0] out;
    input [4:0] select;

    assign out = 1'b1 << select;
endmodule


