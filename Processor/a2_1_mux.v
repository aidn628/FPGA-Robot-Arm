module a2_1_mux(R, S, in0, in1);
    input [31:0] in0, in1;
    input S;
    output [31:0] R;
    assign R = S ? in1 : in0;
endmodule