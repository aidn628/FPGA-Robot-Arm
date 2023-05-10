module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	 
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;


    //----wires------

    //outputs for respective pipes INSTRUCTIONS (use the previous output for given stage)
    wire [31:0] fetchIns, decodeIns, decodeIns_final, executeIns, execute_Ins_In, memoryIns; 
    //outputs for pipes DATA
    wire[31:0] decodeAOut, decodeBOut, decodeB_final, executeAluOut, executeAluIn, executeDataOut, memoryAluOut, memoryDataOut;
    //enables for respective pipes (applies to all pipe regs)
    wire fetchEn, decodeEn, executeEn, memoryEn, multdivEn;
    //clears for respective pipes (applies to all pipe regs)
    wire fetchClr, decodeClr, executeClr, memoryClr, multdivClr;
    //program counters for the fetch and decode pipes
    wire [31:0] fetchPC, decodePC;
    //multdiv reg wires
    wire [31:0] multdivResult; //multdivIns, multdivAIn, multdivBIn;
    wire multdiv_Exception, multdiv_Ready;
    wire ALL_POWER_ENABLE, NO_POWER;
    
    //into ins register wires for adding noOps
    wire [31:0] fetchIns_In, decodeIns_In, executeIns_In;

    //Program Counter wires
    wire [31:0] pcIn, pcOut, pcAluOut;
    wire pcEn, pcClr;

    //Main ALU Wires
    wire [31:0] mainAluOut, mainAluOut_OG, mainAluBIn, mainAluAIn, mainAluANorm1, mainAluBNorm1, mainAluBNorm2; //BIn and AIn are what go in. BNorm is for non bypass in. 
    wire [4:0] mainAluOpcode;
    wire mainAluException, mainAluNot_equal, mainAluLess_than, bex_not_equal;
    //sign extend for addi
    wire [15:0] extendDigits;
    wire [31:0] extendedInmediate;
    //sign extend for Jumps
    wire [31:0] extended_Jump_Ins, jump_Alu_Out, extended_target;

    //MUX WIRES ---> CONTROL 
    wire writeEnable;

    //----PIPES----
        
    //fetch
    reg32 fetchInsReg(fetchIns, fetchIns_In, ~clock, fetchEn, fetchClr);
    reg32 fetchPCReg(fetchPC, pcOut, ~clock, fetchEn, fetchClr);
    //decode 
    reg32 decodeInsReg(decodeIns, decodeIns_In, ~clock, decodeEn, decodeClr);
    reg32 decodeRegA(decodeAOut, data_readRegA, ~clock, decodeEn, decodeClr);
    reg32 decodeRegB(decodeBOut, data_readRegB, ~clock, decodeEn, decodeClr);
    reg32 decodePCReg(decodePC, fetchPC, ~clock, decodeEn, decodeClr);
    //execute
    reg32 executeInsReg(executeIns, executeIns_In, ~clock, executeEn, executeClr);
    reg32 executeAluOutReg(executeAluOut, executeAluIn, ~clock, executeEn, executeClr);
    reg32 executeDataOutReg(executeDataOut, decodeB_final, ~clock, executeEn, executeClr);
    //memory
    reg32 memoryInsReg(memoryIns, executeIns, ~clock, memoryEn, memoryClr);
    reg32 memoryAluOutReg(memoryAluOut, executeAluOut, ~clock, memoryEn, memoryClr);
    reg32 memoryDataOutReg(memoryDataOut, q_dmem, ~clock, memoryEn, memoryClr);




    //-----Temporary clr and enable assignment
    assign fetchEn = ~NO_POWER;
    assign decodeEn = ~NO_POWER;
    assign executeEn = ~NO_POWER;
    assign memoryEn = ~NO_POWER;
    assign pcEn = ~NO_POWER;
    assign fetchClr = 1'b0;
    assign decodeClr = 1'b0;
    assign executeClr = 1'b0;
    assign memoryClr = 1'b0;
    assign pcClr = 1'b0;
    assign multdivClr = 1'b0;
    

    //------Program counter and jumping----------------.
    wire cALU_out, cALU_less, cALU_notequal;
    wire jump;
    wire [31:0] bneAlu1_out, helper_10, helper_11, helper_12, helper_13, helper_17;

    assign jump = (((decodeIns[31:27] == 5'b00010) && cALU_notequal) || ((decodeIns[31:27] == 5'b00110) && cALU_less) || (decodeIns[31:27] == 5'b00001) || (decodeIns[31:27] == 5'b00011) || (decodeIns[31:27] == 5'b00100) || ((decodeIns[31:27] == 5'b10110) && bex_not_equal));

    reg32 programCounter(pcOut, pcIn, clock, pcEn, pcClr); 
    alu PCalu(.data_operandA(pcOut), .data_operandB(32'b1), .ctrl_ALUopcode(5'b0), .data_result(pcAluOut));
    assign helper_10 = ((decodeIns[31:27] == 5'b00011) || (decodeIns[31:27] == 5'b00001)) ? extended_Jump_Ins : pcAluOut;
    assign helper_13 = ((decodeIns[31:27] == 5'b00010) && cALU_notequal) || ((decodeIns[31:27] == 5'b00110) && cALU_less) ? bneAlu1_out : helper_10;
    assign helper_17 = (decodeIns[31:27] == 5'b00100) ? mainAluBIn : helper_13;
    assign pcIn = ((decodeIns[31:27] == 5'b10110) && bex_not_equal) ? extended_Jump_Ins : helper_17;

    assign address_imem = pcOut;

    alu jumpALU(.data_operandA(32'd1), .data_operandB(decodePC), .ctrl_ALUopcode(5'b00000), .data_result(jump_Alu_Out));
    alu bneALU1(.data_operandA(extendedInmediate), .data_operandB(decodePC), .ctrl_ALUopcode(5'b00000), .data_result(bneAlu1_out));


    alu compareALU(.data_operandA(mainAluBIn), .data_operandB(mainAluAIn), .ctrl_ALUopcode(5'b00001), .isLessThan(cALU_less), .isNotEqual(cALU_notequal));
    alu milo_is_stupid(.data_operandA(mainAluBIn), .data_operandB(32'b0), .ctrl_ALUopcode(5'b00001), .isNotEqual(bex_not_equal));

    // ---------------NoOp Stuff ------------------

    assign fetchIns_In = (jump) ? 32'b0 : q_imem;
    assign decodeIns_In = (jump) ? 32'b0 : fetchIns;

    //-----Register Shit----------
    wire [31:0] helper_9, helper_16;

    assign ctrl_readRegA = fetchIns[21:17];
    assign helper_16 = ((fetchIns[31:27] == 5'b00111) || (fetchIns[31:27] == 5'b01000) || (fetchIns[31:27] == 5'b00010) || (fetchIns[31:27] == 5'b00110) || (fetchIns[31:27] == 5'b00100)) ? fetchIns[26:22] : fetchIns[16:12];
    assign ctrl_readRegB = fetchIns[31:27] == 5'b10110 ? 5'd30 : helper_16; 
    assign ctrl_writeReg = memoryIns[26:22];
    assign data_writeReg = (memoryIns[31:27] == 5'b01000) ? memoryDataOut : memoryAluOut; // 1 is alu 2 is data
    assign ctrl_writeEnable = (memoryIns[31:27] == 5'b00000) || (memoryIns[31:27] == 5'b00101) || (memoryIns[31:27] == 5'b01000) ? 1'b1 : 1'b0; //disable reg write for sw

    //-----Main ALU------------

    alu mainALU(.data_operandA(mainAluAIn), .data_operandB(mainAluBIn), .ctrl_ALUopcode(mainAluOpcode), .ctrl_shiftamt(decodeIns[11:7]), .data_result(mainAluOut_OG), .overflow(mainAluException), .isNotEqual(mainAluNot_equal), .isLessThan(mainAluLess_than));
    wire [31:0] helper_5, helper_6;
    assign mainAluBNorm1 = ((decodeIns[31:27] == 5'b00101) || (decodeIns[31:27] == 5'b00111) || (decodeIns[31:27] == 5'b01000)) ? extendedInmediate : decodeBOut;
    assign mainAluBNorm2 = ((((decodeIns[26:22] == memoryIns[26:22]) && ((decodeIns[31:27] == 5'b00100) || (decodeIns[31:27] == 5'b00010) || (decodeIns[31:27] == 5'b00110))) || ((decodeIns[31:27] == 5'b00000) && (decodeIns[16:12] == memoryIns[26:22]))) && (memoryIns[26:22] != 5'b00000) && ((memoryIns[31:27] == 5'b00000) || (memoryIns[31:27] == 5'b00101))) ? memoryAluOut : mainAluBNorm1;
    assign helper_6 = ((((decodeIns[26:22] == executeIns[26:22]) && ((decodeIns[31:27] == 5'b00100) || (decodeIns[31:27] == 5'b00010) || (decodeIns[31:27] == 5'b00110))) || ((decodeIns[31:27] == 5'b00000) && (decodeIns[16:12] == executeIns[26:22]))) && (executeIns[26:22] != 5'b00000) && ((executeIns[31:27] == 5'b00000) || (executeIns[31:27] == 5'b00101))) ? executeAluOut : mainAluBNorm2;
    assign mainAluBIn = ((decodeIns[31:27] == 5'b00000) && (decodeIns[16:12] == executeIns[26:22]) && (executeIns[31:27] == 5'b01000) && (executeIns[26:22] != 5'b00000)) ? q_dmem : helper_6;

    assign mainAluANorm1 = ((decodeIns[21:17] == memoryIns[26:22]) && (memoryIns[26:22] != 5'b00000) && ((memoryIns[31:27] == 5'b00000) || (memoryIns[31:27] == 5'b00101))) ? memoryAluOut : decodeAOut;
    assign helper_5 = ((decodeIns[21:17] == executeIns[26:22]) && (executeIns[26:22] != 5'b00000) && ((executeIns[31:27] == 5'b00000) || (executeIns[31:27] == 5'b00101))) ? executeAluOut : mainAluANorm1;
    assign mainAluAIn = ((decodeIns[21:17] == executeIns[26:22]) && ((decodeIns[31:27] == 5'b00000) || (decodeIns[31:27] == 5'b00101)) && (executeIns[31:27] == 5'b01000) && (executeIns[26:22] != 5'b00000)) ? q_dmem : helper_5;

    assign mainAluOpcode = (decodeIns[31:27] == 5'b00000) ? decodeIns[6:2] : 5'b00000;

    wire [31:0] helper_1, helper_2, helper_3, helper_14;
    a8_1_mux choseException1(.R(helper_1), .S(mainAluOpcode[2:0]), .in0(32'd1), .in1(32'd3), .in6(32'd4), .in7(32'd5));
    assign helper_2 = (decodeIns[31:27] == 5'b00000) ? helper_1 : 32'd2;
    assign mainAluOut = mainAluException ? helper_2 : mainAluOut_OG;

    assign helper_14 = ((mainAluException && ((decodeIns[31:27] == 5'b00000) || (decodeIns[31:27] == 5'b00101))) || (decodeIns[31:27] == 5'b10101) || ((decodeIns[31:27] == 5'b00000) && ((decodeIns[6:2] == 5'b00110) || (decodeIns[6:2] == 5'b00111)) && multdiv_Exception && multdiv_Ready)) ? {5'b0, 5'd30, 22'b0} : decodeIns;
    assign executeIns_In = (decodeIns[31:27] == 5'b00011) ? {5'b0, 5'd31, 22'b0} : helper_14;

    //--------signExtend-----------------

    assign extendDigits = decodeIns[16] ? 15'b111111111111111 : 15'b0;
    assign extendedInmediate = {extendDigits, decodeIns[16:0]};

    assign extended_Jump_Ins = {5'b0, decodeIns[26:0]};

    //---------Data Mem-----------------

    assign wren = (executeIns[31:27] == 5'b00111) ? 1'b1 : 1'b0; //enable data read for store word
    assign address_dmem = executeAluOut;
    //bypassing from memory
    assign data = (memoryIns[31:27] == 5'b01000) && (executeIns[31:27] == 5'b00111) && (memoryIns[26:22] == executeIns[26:22]) ? memoryDataOut : executeDataOut;

    //bypassing to memory
    wire [31:0] helper_4;
    assign helper_4 = ((decodeIns[31:27] == 5'b00111) && ((memoryIns[31:27] == 5'b00000) || (memoryIns[31:27] == 5'b00101)) && (decodeIns[26:22] == memoryIns[26:22])) ? memoryAluOut : decodeBOut;
    assign decodeB_final = ((decodeIns[31:27] == 5'b00111) && ((executeIns[31:27] == 5'b00000) || (executeIns[31:27] == 5'b00101)) && (decodeIns[26:22] == executeIns[26:22])) ? executeAluOut : helper_4;


    //---------------Mult Div------------------
    wire cmult, cdiv, suupa_signal;
    wire [31:0] multdivInA, multdivInB, multdivInA_Lat, multdivInB_Lat;

    reg32 mdlatchA(multdivInA_Lat, mainAluAIn, ~multdiv_Ready, 1'b1, 1'b0);
    reg32 mdlatchB(multdivInB_Lat, mainAluBIn, ~multdiv_Ready, 1'b1, 1'b0);

    assign multdivInA = multdiv_Ready ? multdivInA_Lat : mainAluAIn;
    assign multdivInB = multdiv_Ready ? multdivInB_Lat : mainAluBIn;

    multdiv multiplier_divider(.data_operandA(multdivInA), .data_operandB(multdivInB), .ctrl_MULT(cmult), .ctrl_DIV(cdiv), .clock(clock), .data_result(multdivResult), .data_exception(multdiv_Exception), .data_resultRDY(multdiv_Ready));

    dffe_ref All_Power_reg(ALL_POWER_ENABLE, (((decodeIns[6:2] == 5'b00110) || (decodeIns[6:2] == 5'b00111)) && (decodeIns[31:27] == 5'b00000) && (!multdiv_Ready)), clock, 1'b1, 1'b0);
    dffe_ref Ashley_is_smart(suupa_signal, ALL_POWER_ENABLE, ~clock,  1'b1, ~ALL_POWER_ENABLE);

    assign cmult = ((decodeIns[31:27] == 5'b00000) && (decodeIns[6:2] == 5'b00110) && (!suupa_signal) && (decodeIns[31:27] == 5'b00000)) ? 1'b1 : 1'b0;
    assign cdiv = ((decodeIns[31:27] == 5'b00000) && (decodeIns[6:2] == 5'b00111) && (!suupa_signal) && (decodeIns[31:27] == 5'b00000)) ? 1'b1 : 1'b0;

    assign NO_POWER = (((decodeIns[6:2] == 5'b00110) || (decodeIns[6:2] == 5'b00111)) && (!multdiv_Ready) && (decodeIns[31:27] == 5'b00000)) || wait_stall;

    //-----------------Wait-------------
    wire wait_stall, clock_done, start;
    wire [30:0] clock_out, wait_time;

    dffe_ref waitFlop(wait_stall, (decodeIns[31:27] == 5'b11111) && (!clock_done), clock, 1'b1, 1'b0);
    assign clock_out = {tw60, tw58, tw56, tw54, tw52, tw50, tw48, tw46, tw44, tw42, tw40, tw38, tw36, tw34, tw32, tw30, tw28, tw26, tw24, tw22, tw20, tw18, tw16, tw14, tw12, tw10, tw8, tw6, tw4, tw2, tw1};
    assign clock_done = (wait_time  == clock_out); 
    assign wait_time = {decodeIns[26:0], 4'b0};

    assign start = !wait_stall;

    wire tw1, tw2, tw3, tw4, tw5, tw6, tw7, tw8, tw9, tw10, tw11, tw12, tw13, tw14, tw15, tw16, tw17, tw18, tw19, tw20, tw21, tw22, tw23, tw24, tw25, tw26, tw27, tw28, tw29, tw30, tw31, tw32, tw33, tw34, tw35, tw36, tw37, tw38, tw39, tw40, tw41, tw42, tw43, tw44, tw45, tw46, tw47, tw48, tw49, tw50, tw51, tw52, tw53, tw54, tw55, tw56, tw57, tw58, tw59, tw60;
    
    tff tf1(tw1, 1'b1, ~clock, start); 
    tff tf2(tw2, tw1, ~clock, start);
    and tfa1(tw3, tw1, tw2);
    tff tf3(tw4, tw3, ~clock, start);
    and tfa2(tw5, tw1, tw2, tw4);
    tff tf4(tw6, tw5, ~clock, start);
    and tfa3(tw7, tw1, tw2, tw4, tw6);
    tff tf5(tw8, tw7, ~clock, start);
    and tfa4(tw9, tw1, tw2, tw4, tw6, tw8);
    tff tf6(tw10, tw9, ~clock, start);
    and tfa5(tw11, tw1, tw2, tw4, tw6, tw8, tw10);
    tff tf7(tw12, tw11, ~clock, start);
    and rfa6(tw13, tw1, tw2, tw4, tw6, tw8, tw10, tw12);
    tff tf8(tw14, tw13, ~clock, start);
    and rfa7(tw15, tw1, tw2, tw4, tw6, tw8, tw10, tw12, tw14);
    tff tf9(tw16, tw15, ~clock, start);
    and rfa8(tw17, tw1, tw2, tw4, tw6, tw8, tw10, tw12, tw14, tw16);
    tff tf10(tw18, tw17, ~clock, start);
    and fra9(tw19, tw1, tw2, tw4, tw6, tw8, tw10, tw12, tw14, tw16, tw18);
    tff tf11(tw20, tw19, ~clock, start);
    and fra10(tw21, tw1, tw2, tw4, tw6, tw8, tw10, tw12, tw14, tw16, tw18, tw20);
    tff tf12(tw22, tw21, ~clock, start);
    and fra11(tw23, tw1, tw2, tw4, tw6, tw8, tw10, tw12, tw14, tw16, tw18, tw20, tw22);
    tff tf13(tw24, tw23, ~clock, start);
    and fra12(tw25, tw1, tw2, tw4, tw6, tw8, tw10, tw12, tw14, tw16, tw18, tw20, tw22, tw24);
    tff tf14(tw26, tw25, ~clock, start);
    and fra13(tw27, tw1, tw2, tw4, tw6, tw8, tw10, tw12, tw14, tw16, tw18, tw20, tw22, tw24, tw26);
    tff tf15(tw28, tw27, ~clock, start);
    and fra14(tw29, tw1, tw2, tw4, tw6, tw8, tw10, tw12, tw14, tw16, tw18, tw20, tw22, tw24, tw26, tw28);
    tff tf16(tw30, tw29, ~clock, start);
    and fra15(tw31, tw1, tw2, tw4, tw6, tw8, tw10, tw12, tw14, tw16, tw18, tw20, tw22, tw24, tw26, tw28, tw30);
    tff tf17(tw32, tw31, ~clock, start);
    and fra16(tw33, tw1, tw2, tw4, tw6, tw8, tw10, tw12, tw14, tw16, tw18, tw20, tw22, tw24, tw26, tw28, tw30, tw32);
    tff tf18(tw34, tw33, ~clock, start);
    and fra17(tw35, tw1, tw2, tw4, tw6, tw8, tw10, tw12, tw14, tw16, tw18, tw20, tw22, tw24, tw26, tw28, tw30, tw32, tw34);
    tff tf19(tw36, tw35, ~clock, start);
    and fra18(tw37, tw1, tw2, tw4, tw6, tw8, tw10, tw12, tw14, tw16, tw18, tw20, tw22, tw24, tw26, tw28, tw30, tw32, tw34, tw36);
    tff tf20(tw38, tw37, ~clock, start);
    and fra19(tw39, tw1, tw2, tw4, tw6, tw8, tw10, tw12, tw14, tw16, tw18, tw20, tw22, tw24, tw26, tw28, tw30, tw32, tw34, tw36, tw38);
    tff tf21(tw40, tw39, ~clock, start);
    and fra20(tw41, tw1, tw2, tw4, tw6, tw8, tw10, tw12, tw14, tw16, tw18, tw20, tw22, tw24, tw26, tw28, tw30, tw32, tw34, tw36, tw38, tw40);
    tff tf22(tw42, tw41, ~clock, start);
    and fra21(tw43, tw1, tw2, tw4, tw6, tw8, tw10, tw12, tw14, tw16, tw18, tw20, tw22, tw24, tw26, tw28, tw30, tw32, tw34, tw36, tw38, tw40, tw42);
    tff tf23(tw44, tw43, ~clock, start);
    and fra22(tw45, tw1, tw2, tw4, tw6, tw8, tw10, tw12, tw14, tw16, tw18, tw20, tw22, tw24, tw26, tw28, tw30, tw32, tw34, tw36, tw38, tw40, tw42, tw44);
    tff tf24(tw46, tw45, ~clock, start);
    and fra23(tw47, tw1, tw2, tw4, tw6, tw8, tw10, tw12, tw14, tw16, tw18, tw20, tw22, tw24, tw26, tw28, tw30, tw32, tw34, tw36, tw38, tw40, tw42, tw44, tw46);
    tff tf25(tw48, tw47, ~clock, start);
    and fra24(tw49, tw1, tw2, tw4, tw6, tw8, tw10, tw12, tw14, tw16, tw18, tw20, tw22, tw24, tw26, tw28, tw30, tw32, tw34, tw36, tw38, tw40, tw42, tw44, tw46, tw48);
    tff tf26(tw50, tw49, ~clock, start);
    and fra25(tw51, tw1, tw2, tw4, tw6, tw8, tw10, tw12, tw14, tw16, tw18, tw20, tw22, tw24, tw26, tw28, tw30, tw32, tw34, tw36, tw38, tw40, tw42, tw44, tw46, tw48, tw50);
    tff tf27(tw52, tw51, ~clock, start);
    and fra26(tw53, tw1, tw2, tw4, tw6, tw8, tw10, tw12, tw14, tw16, tw18, tw20, tw22, tw24, tw26, tw28, tw30, tw32, tw34, tw36, tw38, tw40, tw42, tw44, tw46, tw48, tw50, tw52);
    tff tf28(tw54, tw53, ~clock, start);
    and fra27(tw55, tw1, tw2, tw4, tw6, tw8, tw10, tw12, tw14, tw16, tw18, tw20, tw22, tw24, tw26, tw28, tw30, tw32, tw34, tw36, tw38, tw40, tw42, tw44, tw46, tw48, tw50, tw52, tw54);
    tff tf29(tw56, tw55, ~clock, start);
    and fra28(tw57, tw1, tw2, tw4, tw6, tw8, tw10, tw12, tw14, tw16, tw18, tw20, tw22, tw24, tw26, tw28, tw30, tw32, tw34, tw36, tw38, tw40, tw42, tw44, tw46, tw48, tw50, tw52, tw54, tw56);
    tff tf30(tw58, tw57, ~clock, start);
    and fra29(tw59, tw1, tw2, tw4, tw6, tw8, tw10, tw12, tw14, tw16, tw18, tw20, tw22, tw24, tw26, tw28, tw30, tw32, tw34, tw36, tw38, tw40, tw42, tw44, tw46, tw48, tw50, tw52, tw54, tw56, tw58);
    tff tf31(tw60, tw59, ~clock, start);


    //EXECUTE ALU IN 
    wire [31:0] helper_8, helper_15;

    assign helper_8 = (decodeIns[31:27] == 5'b00011) ? decodePC : mainAluOut;
    assign helper_15 = ((decodeIns[31:27] == 5'b00000) && ((decodeIns[6:2] == 5'b00110) || (decodeIns[6:2] == 5'b00111))) ? multdivResult : helper_8;
    assign executeAluIn = (decodeIns[31:27] == 5'b10101) ? extended_Jump_Ins : helper_15;


endmodule
