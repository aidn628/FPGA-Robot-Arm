module tff(Out, In, Clock, clr);
    input In, Clock, clr;
    output Out;

    wire outA1, outA2, outO;

    and a1(outA1, ~In, Out);
    and a2(outA2, In, ~Out);
    or (outO, outA1, outA2);

    dffe_ref dflopt(Out, outO, Clock, 1'b1, clr);
endmodule
