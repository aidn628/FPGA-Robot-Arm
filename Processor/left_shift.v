module left_shift(shifted, toShift, amt);
    input [31:0] toShift;
    input [4:0] amt;

    output [31:0] shifted;

    wire [31:0] s16;
    wire [31:0] o16, o8, o4, o2;
    wire [31:0] s18, s8, s4, s2, s1;

    a2_1_mux shift16(o16, amt[4], toShift, s16);
    assign s16[31:16] = toShift[15:0];
    assign s16[15:0] = 16'b0;

    a2_1_mux shift8(o8, amt[3], o16, s8);
    assign s8[31:8] = o16[23:0];
    assign s8[7:0] = 8'b0;

    a2_1_mux shift4(o4, amt[2], o8, s4);
    assign s4[31:4] = o8[27:0];
    assign s4[3:0] = 4'b0;

    a2_1_mux shift2(o2, amt[1], o4, s2);
    assign s2[31:2] = o4[29:0];
    assign s2[1:0] = 2'b0;

    a2_1_mux shift1(shifted, amt[0], o2, s1);
    assign s1[31:1] = o2[30:0];
    assign s1[0] = 1'b0;


endmodule