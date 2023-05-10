module reg_tb;
    reg clk, en, clr;
    reg [31:0] in;
    wire [31:0] out;

    reg32 rtest(out, in, clk, en, clr);
    initial begin 
        clk = 0;
    end
    
    initial begin
        en = 0;
        clr = 0;
        in = 45;
        #15
            $display("in: %d out: %d clk: %b en: %b clr: %b", in, out, clk, en, clr);
        $finish;
    end

    always 
        #10 clk = ~clk;

    
endmodule