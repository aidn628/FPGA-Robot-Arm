module right_shift(shifted, toShift, amt);
    input [31:0] toShift;
    input [4:0] amt;

    output [31:0] shifted;

    wire [31:0] s16;
    wire [31:0] o16, o8, o4, o2;
    wire [31:0] s18, s8, s4, s2, s1;
    wire [31:0] f;
    a2_1_mux fill16(f, toShift[31], 32'b0, -1);

    a2_1_mux shift16(o16, amt[4], toShift, s16);
    assign s16[15:0] = toShift[31:16];
    assign s16[31:16] = f[15:0];

    a2_1_mux shift8(o8, amt[3], o16, s8);
    assign s8[23:0] = o16[31:8];
    assign s8[31:24] = f[7:0];

    a2_1_mux shift4(o4, amt[2], o8, s4);
    assign s4[27:0] = o8[31:4];
    assign s4[31:28] = f[3:0];

    a2_1_mux shift2(o2, amt[1], o4, s2);
    assign s2[29:0] = o4[31:2];
    assign s2[31:30] = f[1:0];

    a2_1_mux shift1(shifted, amt[0], o2, s1);
    assign s1[30:0] = o2[31:1];
    assign s1[31] = f[0];


endmodule