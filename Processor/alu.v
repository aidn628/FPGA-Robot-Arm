module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;

    wire Cin;
    wire [31:0] notB, yesB, claOUT, rightOUT, leftOUT, andOUT, orOUT;

    mux_32 chooser(data_result, ctrl_ALUopcode, claOUT, claOUT, andOUT, orOUT, leftOUT, rightOUT, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0);
    and carryIn(Cin, ~ctrl_ALUopcode[4], ~ctrl_ALUopcode[3], ~ctrl_ALUopcode[2], ~ctrl_ALUopcode[1], ctrl_ALUopcode[0]);
    a2_1_mux whichB(yesB, Cin, data_operandB, notB);

    CLA32 adder(claOUT, overflow, data_operandA, yesB, Cin);
    right_shift rShift(rightOUT, data_operandA, ctrl_shiftamt);
    left_shift lShift(leftOUT, data_operandA, ctrl_shiftamt);
    bit_and bAnd(andOUT, data_operandA, data_operandB);
    bit_or bOr(orOUT, data_operandA, data_operandB);
    or neq(isNotEqual, claOUT[0], claOUT[1], claOUT[2], claOUT[3], claOUT[4], claOUT[5], claOUT[6], claOUT[7], claOUT[8], claOUT[9], claOUT[10], claOUT[11], claOUT[12], claOUT[13], claOUT[14], claOUT[15], claOUT[16], claOUT[17], claOUT[18], claOUT[19], claOUT[20], claOUT[21], claOUT[22], claOUT[23], claOUT[24], claOUT[25], claOUT[26], claOUT[27], claOUT[28], claOUT[29], claOUT[30], claOUT[31]);
    xor aless(isLessThan, claOUT[31], overflow);

    not n0(notB[0], data_operandB[0]);    
    not n1(notB[1], data_operandB[1]); 
    not n2(notB[2], data_operandB[2]);
    not n3(notB[3], data_operandB[3]);
    not n4(notB[4], data_operandB[4]);
    not n5(notB[5], data_operandB[5]);
    not n6(notB[6], data_operandB[6]);
    not n7(notB[7], data_operandB[7]); 
    not n8(notB[8], data_operandB[8]);
    not n9(notB[9], data_operandB[9]); 
    not n10(notB[10], data_operandB[10]);
    not n11(notB[11], data_operandB[11]);
    not n12(notB[12], data_operandB[12]);
    not n13(notB[13], data_operandB[13]);
    not n14(notB[14], data_operandB[14]);
    not n15(notB[15], data_operandB[15]);
    not n16(notB[16], data_operandB[16]);
    not n17(notB[17], data_operandB[17]);
    not n18(notB[18], data_operandB[18]);
    not n19(notB[19], data_operandB[19]);
    not n20(notB[20], data_operandB[20]);
    not n21(notB[21], data_operandB[21]);
    not n22(notB[22], data_operandB[22]);
    not n23(notB[23], data_operandB[23]);
    not n24(notB[24], data_operandB[24]);
    not n25(notB[25], data_operandB[25]);
    not n26(notB[26], data_operandB[26]);
    not n27(notB[27], data_operandB[27]);
    not n28(notB[28], data_operandB[28]);
    not n29(notB[29], data_operandB[29]);
    not n30(notB[30], data_operandB[30]);
    not n31(notB[31], data_operandB[31]);

endmodule