module full_adder(S, Cout, A, B, Cin);
    input A, B, Cin;
    output S, Cout;
    wire W1, W2, W3;

    xor gate_1(S, A, B, Cin);
    and and_1(W1, A, B);
    and and_2(W2, A, Cin);
    and and_3(W3, B, Cin);
    or gate_2(Cout, W1, W2, W3);
endmodule