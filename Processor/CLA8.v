module CLA8(SUM, Gout, Pout, A, B, Cin);
    input [7:0] A, B;
    input Cin;

    output [7:0] SUM;
    output Pout, Gout;

    wire g0, g1, g2, g3, g4, g5, g6, g7;
    wire p0, p1, p2, p3, p4, p5, p6, p7;
    wire b0, b10, b11;
    wire b20, b21, b22;
    wire b30, b31, b32, b33;
    wire b40, b41, b42, b43, b44;
    wire b50, b51, b52, b53, b54, b55;
    wire b60, b61, b62, b63, b64, b65, b66;
    wire b70, b71, b72, b73, b74, b75, b76, b77;
    wire b81, b82, b83, b84, b85, b86, b87;
    wire c0, c1, c2, c3, c4, c5, c6, c7;

    and gen0(g0, A[0], B[0]);
    or prop0(p0, A[0], B[0]);
    and Pand0(b0, p0, Cin);
    or Cor0(c0, g0, b0);
    xor sum0(SUM[0], A[0], B[0], Cin);

    and gen1(g1, A[1], B[1]);
    or prop1(p1, A[1], B[1]);
    and Pand10(b10, p1, g0);
    and Pand11(b11, p1, p0, Cin);
    or Cor1(c1, g1, b10, b11);
    xor sum1(SUM[1], A[1], B[1], c0);

    and gen2(g2, A[2], B[2]);
    or prop2(p2, A[2], B[2]);
    and Pand20(b20, p2, g1);
    and Pand21(b21, p2, p1, g0);
    and Pand22(b22, p2, p1, p0, Cin);
    or Cor2(c2, g2, b20, b21, b22);
    xor sum2(SUM[2], A[2], B[2], c1);

    and gen3(g3, A[3], B[3]);
    or prop3(p3, A[3], B[3]);
    and Pand30(b30, p3, g2);
    and Pand31(b31, p3, p2, g1);
    and Pand32(b32, p3, p2, p1, g0);
    and Pand33(b33, p3, p2, p1, p0, Cin);
    or Cor3(c3, g3, b30, b31, b32, b33);
    xor sum3(SUM[3], A[3], B[3], c2);

    and gen4(g4, A[4], B[4]);
    or prop4(p4, A[4], B[4]);
    and Pand40(b40, p4, g3);
    and Pand41(b41, p4, p3, g2);
    and Pand42(b42, p4, p3, p2, g1);
    and Pand43(b43, p4, p3, p2, p1, g0);
    and Pand44(b44, p4, p3, p2, p1, p0, Cin);
    or Cor4(c4, g4, b40, b41, b42, b43, b44); 
    xor sum4(SUM[4], A[4], B[4], c3);

    and gen5(g5, A[5], B[5]);
    or prop5(p5, A[5], B[5]);
    and Pand50(b50, p5, g4);
    and Pand51(b51, p5, p4, g3);
    and Pand52(b52, p5, p4, p3, g2);
    and Pand53(b53, p5, p4, p3, p2, g1);
    and Pand54(b54, p5, p4, p3, p2, p1, g0);
    and Pand55(b55, p5, p4, p3, p2, p1, p0, Cin);
    or Cor5(c5, g5, b50, b51, b52, b53, b54, b55);
    xor sum5(SUM[5], A[5], B[5], c4);

    and gen6(g6, A[6], B[6]);
    or prop6(p6, A[6], B[6]);
    and Pand60(b60, p6, g5);
    and Pand61(b61, p6, p5, g4);
    and Pand62(b62, p6, p5, p4, g3);
    and Pand63(b63, p6, p5, p4, p3, g2);
    and Pand64(b64, p6, p5, p4, p3, p2, g1);
    and Pand65(b65, p6, p5, p4, p3, p2, p1, g0);
    and Pand66(b66, p6, p5, p4, p3, p2, p1, p0, Cin);
    or Cor6(c6, g6, b60, b61, b62, b63, b64, b65, b66);
    xor sum6(SUM[6], A[6], B[6], c5);

    and gen7(g7, A[7], B[7]);
    or prop7(p7, A[7], B[7]);
    and Pand70(b70, p7, g6);
    and Pand71(b71, p7, p6, g5);
    and Pand72(b72, p7, p6, p5, g4);
    and Pand73(b73, p7, p6, p5, p4, g3);
    and Pand74(b74, p7, p6, p5, p4, p3, g2);
    and Pand75(b75, p7, p6, p5, p4, p3, p2, g1);
    and Pand76(b76, p7, p6, p5, p4, p3, p2, p1, g0);
    and Pand77(b77, p7, p6, p5, p4, p3, p2, p1, p0, Cin);
    or Cor7(c7, g7, b70, b71, b72, b73, b74, b75, b76, b77);
    xor sum7(SUM[7], A[7], B[7], c6);

    and ooga(Pout, p0, p1, p2, p3, p4, p5, p6, p7);
    
    and booga1(b81, p7, g6);
    and booga2(b82, p7, p6, g5);
    and booga3(b83, p7, p6, p5, g4);
    and booga4(b84, p7, p6, p5, p4, g3);
    and booga5(b85, p7, p6, p5, p4, p3, g2);
    and booga6(b86, p7, p6, p5, p4, p3, p2, g1);
    and booga7(b87, p7, p6, p5, p4, p3, p2, p1, g0);
    or booga(Gout, g7, b81, b82, b83, b84, b85, b86, b87);



    
endmodule