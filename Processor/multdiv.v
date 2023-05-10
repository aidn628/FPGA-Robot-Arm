module multdiv(
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    wire [31:0] divOUT;
    wire mReady, dReady;

    //mult or div   
    wire choosewire;
    dffe_ref choose(choosewire, 1'b1, ctrl_MULT, 1'b1, ctrl_DIV);
    assign data_result = choosewire ? outOG[31:0] : divOUT;

    //ovf 
    wire allSame, allZero, allOne;
    wire dovf;
    assign data_exception = ((~allSame)&choosewire) | (dovf&(~choosewire));

    wire tw1, tw2, tw3;
    tff tf1(tw1, 1'b1, clock, ctrl_MULT); //might have to add ctrl_div if this works
    tff tf2(mReady, tw1, clock, ctrl_MULT);
    //and tfa(tw3, tw2, tw1);
   // tff tf3(data_resultRDY, tw3, clock, ctrl_MULT);

//ready

    assign data_resultRDY = (mReady&choosewire) | (dReady&(~choosewire));

//division
    divider div(divOUT, dReady, dovf, data_operandB, data_operandA, ctrl_DIV, clock);

//latching a and b
    wire [31:0] Asaved, Bsaved;
    reg32 regA(Asaved, data_operandA, ~clock, ctrl_MULT, 1'b0);
    reg32 regB(Bsaved, data_operandB, ~clock, ctrl_MULT, 1'b0);

//random mult shitf
    wire [1023:0] layer;
    wire [63:0] outOG;

    assign outOG[63:32] = layer[1023:992];
//regular rows
    genvar k;
    generate 
        for (k=1; k < 31; k = k + 1) begin: loop3
            row r(outOG[k], layer[32*k+31:32*k], Asaved, Bsaved[k], layer[32*k-1:32*(k-1)]);
        end
    endgenerate
//last row
    wire [30:0] lastRowNand;
    genvar v;
    generate 
        for (v=0; v < 31; v = v + 1) begin: loop5
            nand combine(lastRowNand[v], Asaved[v], Bsaved[31]);
        end
    endgenerate
    
    wire [32:0] lastRowCarry;

    genvar b;
    generate 
        for (b=0; b < 30; b = b + 1) begin: loop6
            full_adder add(layer[992+b], lastRowCarry[b+1], lastRowNand[b+1], layer[961+b], lastRowCarry[b]);
        end
    endgenerate

    full_adder woka3(outOG[31], lastRowCarry[0], lastRowNand[0], layer[960], 1'b0);

    wire asdf;
    wire whoCares;
    and (asdf, Asaved[31], Bsaved[31]);
    full_adder woka1(layer[1022], lastRowCarry[31], asdf, layer[991], lastRowCarry[30]);
    full_adder woka2(layer[1023], whoCares, 1'b1, 1'b0, lastRowCarry[31]);
//first row
    genvar l;
    generate 
        for (l=1; l < 31; l = l + 1) begin: loop4
            and firstRow(layer[l-1], Asaved[l], Bsaved[0]);
        end
    endgenerate
    nand uppercorner(layer[30], Asaved[31], Bsaved[0]);
    and bitONE(outOG[0], Asaved[0], Bsaved[0]);
    assign layer[31] = 1;

// overflow stuff wired defined at top
    or aaz(allZero, outOG[63], outOG[62], outOG[61], outOG[60], outOG[59], outOG[58], outOG[57], outOG[56], outOG[55], outOG[54], outOG[53], outOG[52], outOG[51], outOG[50], outOG[49], outOG[48], outOG[47], outOG[46], outOG[45], outOG[44], outOG[43], outOG[42], outOG[41], outOG[40], outOG[39], outOG[38], outOG[37], outOG[36], outOG[35], outOG[34], outOG[33], outOG[32], outOG[31]);
    and aa0(allOne, outOG[63], outOG[62], outOG[61], outOG[60], outOG[59], outOG[58], outOG[57], outOG[56], outOG[55], outOG[54], outOG[53], outOG[52], outOG[51], outOG[50], outOG[49], outOG[48], outOG[47], outOG[46], outOG[45], outOG[44], outOG[43], outOG[42], outOG[41], outOG[40], outOG[39], outOG[38], outOG[37], outOG[36], outOG[35], outOG[34], outOG[33], outOG[32], outOG[31]);
    or good(allSame, ~allZero, allOne);

endmodule

module row(rBit, prop, Afull, Bbit, above);
    input [31:0] Afull, above;
    input Bbit;

    output [31:0] prop;
    output rBit;

    wire [31:0] andOUT;
    wire [31:0] carry;

    nand endNand(andOUT[31], Afull[31], Bbit);

    genvar i;
    generate 
        for (i=0; i < 31; i = i + 1) begin: loop1
            and combine(andOUT[i], Afull[i], Bbit);
        end
    endgenerate

    genvar j;
    generate 
        for (j=1; j < 31; j = j + 1) begin: loop2
            full_adder add(prop[j-1], carry[j], andOUT[j], above[j], carry[j-1]);
        end
    endgenerate

    full_adder addLast(prop[30], prop[31], andOUT[31], above[31], carry[30]);
    full_adder addFirst(rBit, carry[0], andOUT[0], above[0], 1'b0);

endmodule   