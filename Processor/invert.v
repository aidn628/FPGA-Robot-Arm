module invert(out, in);
    input [31:0] in;
    output [31:0] out;

    wire [31:0] w1;

    assign w1 = ~in;
    alu aalu(.data_operandA(w1), .data_operandB(32'b1), .ctrl_ALUopcode(5'b0), .data_result(out));
endmodule