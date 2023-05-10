module regfile (
	btn, 
	btn_2,
	led,
	signal_1,
	signal_2,
	signal_3,
	in_1,
	in_2,
	in_3,
	in_4, 
	in_5,
	in_6,
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB
);

	input btn, btn_2;
	input clock, ctrl_writeEnable, ctrl_reset, in_1, in_2, in_3, in_4, in_5, in_6;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;
	output led;
	output [31:0] data_readRegA, data_readRegB, signal_1, signal_2, signal_3;

	wire [1023:0] regOUT;
	wire [31:0] andOUT;
	wire [31:0] toWrite, toReadA, toReadB;
	

	decoder toWriteDecoder(toWrite, ctrl_writeReg);
	decoder toReadDecoderA(toReadA, ctrl_readRegA);
	decoder toReadDecoderB(toReadB, ctrl_readRegB);

	genvar j;
	generate 
        for (j=0; j < 32; j = j + 1) begin: loop1
            and a(andOUT[j], ctrl_writeEnable, toWrite[j]);
        end
    endgenerate

	genvar i;
	generate 
        for (i=9; i < 32; i = i + 1) begin: loop2
            reg32 r(regOUT[32*(i+1) - 1 : 32 * i], data_writeReg, clock, andOUT[i], ctrl_reset);
        end
    endgenerate

	assign regOUT[31:0] = 32'b0;  
	assign regOUT[63:32] = {31'b0, btn};  //reg1 gives button state             //reg 2 outputs to led on board (1's bit)
	assign regOUT[95:64] = {31'b0, btn_2}; //2
	assign regOUT[127:96] = {31'b0, in_1}; //3
	assign regOUT[159:128] = {31'b0, in_2}; //4
	assign regOUT[191:160] = {31'b0, in_3}; //5
	assign regOUT[223:192] = {31'b0, in_4};; //6
	assign regOUT[255:224] = {31'b0, in_5};; //7
	assign regOUT[287:256] = {31'b0, in_6};; //8
	assign signal_1 = regOUT[319:288]; //9
	assign signal_2 = regOUT[351:320]; //10
	assign signal_3 = regOUT[383:352];  //11
	assign led = regOUT[384];  

	genvar h;
	generate 
        for (h=0; h < 32; h = h + 1) begin: loop3
            tri32 t1(data_readRegA, regOUT[32*(h+1) - 1 : 32 * h], toReadA[h]);
        end
    endgenerate

	genvar k;
	generate 
        for (k=0; k < 32; k = k + 1) begin: loop4
            tri32 t2(data_readRegB, regOUT[32*(k+1) - 1 : 32 * k], toReadB[k]);
        end
    endgenerate


	// add your code here

endmodule
