module CLA32(SUM, ovf, A, B, Cin);
    input [31:0] A, B;
    input Cin;

    output [31:0] SUM;
    output ovf;

    wire g0, g1, g2, g3;
    wire p0, p1, p2, p3;
    wire c0, c1, c2, c3;
    wire wp00;
    wire wp10, wp11;
    wire wp20, wp21, wp22;
    wire wp30, wp31, wp32, wp33;

    CLA8 woka0(SUM[7:0], g0,  p0, A[7:0], B[7:0], Cin);
    and pa0(wp00, p0, Cin);
    or pr0(c0, g0, wp00);

    CLA8 woka1(SUM[15:8], g1,  p1, A[15:8], B[15:8], c0);
    and pa10(wp10, p1, g0);
    and pa11(wp11, p1, p0, Cin);
    or pr1(c1, g1, wp10, wp11);

    CLA8 woka2(SUM[23:16], g2, p2, A[23:16], B[23:16], c1);
    and pa20(wp20, p2, g1);
    and pa21(wp21, p2, p1, g0);
    and pa22(wp22, p2, p1, p0, Cin);
    or pr2(c2, g2, wp20, wp21, wp22);

    CLA8 woka3(SUM[31:24], g3, p3, A[31:24], B[31:24], c2);
    and pa30(wp30, p3, g2);
    and pa31(wp31, p3, p2, g1);
    and pa32(wp32, p3, p2, p1, g0);
    and pa33(wp33, p3, p2, p1, p0, Cin);
    or pr3(c3, g3, wp30, wp31, wp32, wp33);

    wire cat, dog, donkey;
    xor ov1(cat, c3, SUM[31]);
    xnor ov5(dog, c3, A[31]);
    xnor ov4(donkey, A[31], B[31]);
    and ov3(ovf, cat, dog, donkey);


endmodule