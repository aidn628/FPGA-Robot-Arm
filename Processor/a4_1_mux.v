module a4_1_mux(R, S, in0, in1, in2, in3);
    input [31:0] in0, in1, in2, in3;
    input [1:0] S;
    output [31:0] R;

    wire [31:0] w0, w1;

    a2_1_mux mux_1(R, S[1], w0, w1);
    a2_1_mux mux_2(w0, S[0], in0, in1);
    a2_1_mux mux_3(w1, S[0], in2, in3);
endmodule