module tri32(out, in, on);
    input [31:0] in;
    input on;
    output [31:0] out;

    assign out = on ? in : 32'bz;

endmodule