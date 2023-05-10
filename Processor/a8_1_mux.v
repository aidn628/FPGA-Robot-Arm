module a8_1_mux(R, S, in0, in1, in2, in3, in4, in5, in6, in7);
    input [31:0] in0, in1, in2, in3, in4, in5, in6, in7;
    input [2:0] S;
    output [31:0] R;

    wire [31:0] w0, w1;

    a2_1_mux mux_1(R, S[2], w0, w1);
    a4_1_mux mux_2(w0, S[1:0], in0, in1, in2, in3);
    a4_1_mux mux_3(w1, S[1:0], in4, in5, in6, in7);
endmodule