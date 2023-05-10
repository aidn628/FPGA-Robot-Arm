module mux_32(R, S, in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31);

    input [31:0] in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31;
    input[4:0] S;
    output [31:0] R;

    wire [31:0] w0, w1, w2, w3;

    a4_1_mux mux_1(R, S[4:3], w0, w1, w2, w3);
    a8_1_mux mux_2(w0, S[2:0], in0, in1, in2, in3, in4, in5, in6, in7);
    a8_1_mux mux_3(w1, S[2:0], in8, in9, in10, in11, in12, in13, in14, in15);
    a8_1_mux mux_4(w2, S[2:0], in16, in17, in18, in19, in20, in21, in22, in23);
    a8_1_mux mux_5(w3, S[2:0], in24, in25, in26, in27, in28, in29, in30, in31);
endmodule
