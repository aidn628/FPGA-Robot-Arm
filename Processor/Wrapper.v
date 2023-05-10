`timescale 1ns / 1ps

module Wrapper (clock, reset, LED, btn_1, btn_2, srvo_1, srvo_2, srvo_3, base_a, shoulder_a, elbow_a, base_b, shoulder_b, elbow_b);
	input clock, reset, btn_1, btn_2, base_a, shoulder_a, elbow_a, base_b, shoulder_b, elbow_b;
	output[15:0] LED;
	output srvo_1, srvo_2, srvo_3;
	
	assign LED[0] = 1'b1;

	wire rwe, mwe;
	wire[4:0] rd, rs1, rs2;
	wire[31:0] instAddr, instData, 
		rData, regA, regB,
		memAddr, memDataIn, memDataOut;
		
		
		

	//FPGA CLOCK
	reg fpga_clock;
	always @(posedge clock) begin
	    fpga_clock <= ~fpga_clock;
	end
	
	//buttons
	
    assign LED[4] = btn_1;

	


    //Servo_1
    wire[31:0] desired_angle_1;
    wire [30:0] limit;
    reg [30:0] counter = 0;
    reg on_off = 1;
    reg servo_signal = 1;
    
    assign limit = on_off ? (75000+((desired_angle_1)*56)): 1000000 - (75000+((desired_angle_1)*56));
    
    always @(posedge fpga_clock) begin
        if (counter < limit)
            counter <= counter + 1;
        else begin 
            counter <= 0;
            servo_signal <= ~servo_signal;
            on_off <= ~on_off;
        end
    end
            
    assign srvo_1 = servo_signal;

	    //Servo_2
    wire[31:0] desired_angle_2;
    wire [30:0] limit_2;
    reg [30:0] counter_2 = 0;
    reg on_off_2 = 1;
    reg servo_signal_2 = 1;
    
    assign limit_2 = on_off_2 ? (75000+((desired_angle_2)*56)): 1000000 - (75000+((desired_angle_2)*56));
    
    always @(posedge fpga_clock) begin
        if (counter_2 < limit_2)
            counter_2 <= counter_2 + 1;
        else begin 
            counter_2 <= 0;
            servo_signal_2 <= ~servo_signal_2;
            on_off_2 <= ~on_off_2;
        end
    end
            
    assign srvo_2 = servo_signal_2;

	    //Servo_3
    wire[31:0] desired_angle_3;
    wire [30:0] limit_3;
    reg [30:0] counter_3 = 0;
    reg on_off_3 = 1;
    reg servo_signal_3 = 1;
    
    assign limit_3 = on_off_3 ? (75000+((desired_angle_3)*56)): 1000000 - (75000+((desired_angle_3)*56));
    
    always @(posedge fpga_clock) begin
        if (counter_3 < limit_3)
            counter_3 <= counter_3 + 1;
        else begin 
            counter_3 <= 0;
            servo_signal_3 <= ~servo_signal_3;
            on_off_3 <= ~on_off_3;
        end
    end
            
    assign srvo_3 = servo_signal_3;
            
    
	// ADD YOUR MEMORY FILE HERE
	localparam INSTR_FILE = "remember";
	
	// Main Processing Unit
	processor CPU(.clock(fpga_clock), .reset(reset), 
								
		// ROM
		.address_imem(instAddr), .q_imem(instData),
									
		// Regfile
		.ctrl_writeEnable(rwe),     .ctrl_writeReg(rd),
		.ctrl_readRegA(rs1),     .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
									
		// RAM
		.wren(mwe), .address_dmem(memAddr), 
		.data(memDataIn), .q_dmem(memDataOut)); 
	
	// Instruction Memory (ROM)
	ROM #(.MEMFILE({INSTR_FILE, ".mem"}))
	InstMem(.clk(fpga_clock), 
		.addr(instAddr[11:0]), 
		.dataOut(instData));
	
	// Register File
	regfile RegisterFile(.clock(fpga_clock), 
		.led(LED[1]),
		.btn(btn_1),
		.btn_2(btn_2),
		.signal_1(desired_angle_1),
		.signal_2(desired_angle_2),
		.signal_3(desired_angle_3),
		.in_1(~base_a),
		.in_2(~shoulder_a),
		.in_3(~elbow_a),
		.in_4(~base_b),
		.in_5(~shoulder_b),
		.in_6(~elbow_b),
		.ctrl_writeEnable(rwe), .ctrl_reset(reset), 
		.ctrl_writeReg(rd),
		.ctrl_readRegA(rs1), .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB));
						
	// Processor Memory (RAM)
	RAM ProcMem(.clk(fpga_clock), 
		.wEn(mwe), 
		.addr(memAddr[11:0]), 
		.dataIn(memDataIn), 
		.dataOut(memDataOut));

endmodule


