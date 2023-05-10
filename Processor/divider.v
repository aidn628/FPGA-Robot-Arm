module divider(out, rdy, ovf, divisor, dividend, start, clock);
    input [31:0] divisor, dividend;
    input start, clock;

    output [31:0] out;
    output rdy, ovf;

    wire [31:0] qShiftOut, qShiftOutMod, qIn;
    wire [31:0] remOut, remIn, remShiftOut;
    wire [31:0] remShiftIn, aluOut;
    wire [31:0] sor;
    wire [31:0] actualDivisor, negatedDivisor;
    wire [31:0] actualDividend, negatedDividend;
    wire [31:0] negatedOut, normalOut;
    wire [31:0] regularOut;
    wire [31:0] oogaOut;
    wire [31:0] baka, wowo;
    wire divideByZero;
    wire isLess, notEqual;

    assign remIn = start ? baka : wowo;
    assign baka = {31'b0, actualDividend[31]};
    assign wowo = {remShiftOut[31:1], regularOut[31]};//qShiftOut[31]

    //negative
    
    invert insor(negatedDivisor, divisor);
    invert indiv(negatedDividend, dividend);
    invert ooga(negatedOut, regularOut);
    assign actualDivisor = (divisor[31]&(~dividend[31])) | (divisor[31]&dividend[31]) ? negatedDivisor : divisor;
    assign actualDividend = (dividend[31]&(~divisor[31])) | (divisor[31]&dividend[31]) ? negatedDividend : dividend;
    assign oogaOut = (divisor[31]^dividend[31]) ? negatedOut : regularOut;
    assign out = divideByZero ? oogaOut : 32'b0;
    or dbz(divideByZero, divisor[0], divisor[1], divisor[2], divisor[3], divisor[4], divisor[5], divisor[6], divisor[7], divisor[8], divisor[9], divisor[10], divisor[11], divisor[12], divisor[13], divisor[14], divisor[15], divisor[16], divisor[17], divisor[18], divisor[19], divisor[20], divisor[21], divisor[22], divisor[23], divisor[24], divisor[25], divisor[26], divisor[27], divisor[28], divisor[29], divisor[30], divisor[31]);
    //ovf

    nor dbzero(ovf, sor[0], sor[1], sor[2], sor[3], sor[4], sor[4], sor[5], sor[6], sor[7], sor[8], sor[9], sor[10], sor[11], sor[12], sor[13], sor[14], sor[14], sor[15], sor[16], sor[17], sor[18], sor[19], sor[20], sor[21], sor[22], sor[23], sor[24], sor[24], sor[25], sor[26], sor[27], sor[28], sor[29], sor[30], sor[31]);

    //clock

    wire tw1, tw2, tw3, tw4, tw5, tw6, tw7, tw8, tw9;
    tff tf1(tw1, 1'b1, clock, start); //might have to add ctrl_div if this works
    tff tf2(tw2, tw1, clock, start);
    and tfa1(tw3, tw1, tw2);
    tff tf3(tw4, tw3, clock, start);
    and tfa2(tw5, tw1, tw2, tw4);
    tff tf4(tw6, tw5, clock, start);
    and tfa3(tw7, tw1, tw2, tw4, tw6);
    tff tf5(tw8, tw7, clock, start);
    and tfa4(tw9, tw1, tw2, tw4, tw6, tw8);
    tff tf6(rdy, tw9, clock, start);

    //registers
    wire [31:0] urMOM;

    reg32 divisorReg(sor, actualDivisor, clock, start, 1'b0); // still have to figure out whether not clock
    reg32 remainderReg(remOut, remIn, clock, 1'b1, 1'b0);

    assign urMOM = {actualDividend[30:0], 1'b0};
    assign qIn = start ? urMOM : qShiftOutMod;
    assign qShiftOutMod = {qShiftOut[31:1], ~(isLess)};
    reg32 toQuotientReg(regularOut, qIn, clock, 1'b1, 1'b0);

    //ALU
    alu sub(.data_operandA(remOut), .data_operandB(sor), .ctrl_ALUopcode(5'b1), .data_result(aluOut), .isLessThan(isLess), .isNotEqual(notEqual));
    alu sQ(.data_operandA(regularOut), .ctrl_ALUopcode(5'b00100), .ctrl_shiftamt(5'b1), .data_result(qShiftOut));
    alu sR(.data_operandA(remShiftIn), .ctrl_ALUopcode(5'b00100), .data_result(remShiftOut), .ctrl_shiftamt(5'b1));

    //mux

    assign remShiftIn = isLess ? remOut : aluOut;



endmodule