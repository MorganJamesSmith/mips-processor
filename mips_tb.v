// Copyright (C) 2020 by Morgan Smith

`timescale  1 ns / 1 ns

`define test(signal, value) \
        if (signal !== value) begin \
            $display("TEST FAILED in %m: signal != value"); \
        end

module mips_tb;

    // TODO: Use the mips module instead of putting everything together here

    reg [31:0] PC;

    reg        reg_write;
    reg [4:0]  write_register;
    wire [31:0] busW;

    reg [4:0]   RA;
    reg [4:0]   RB;

    wire [31:0] busA;
    wire [31:0] busB;

    reg         rst;
    reg         clk;

    wire [31:0] instruction;

    wire [3:0]  alu_op = instruction[31:26];
    wire        alu_zero;

    alu alu(
            .op(alu_op),
            .busA(busA),
            .busB(busB),
            .result(busW),
            .zero(alu_zero),
            .clk(clk),
            .rst(rst));

    instruction_memory imem(
                            .read_address(PC),
                            .instruction(instruction),
                            .clk(clk),
                            .rst(rst));


    register_file reg_file(
                           .write_enable(reg_write),
                           .write_register(write_register),
                           .busW(busW),
                           .RA(RA),
                           .RB(RB),
                           .busA(busA),
                           .busB(busB),
                           .rst(rst),
                           .clk(clk));

    always #10 clk = ~clk;

    initial begin

        $dumpfile("mips_tb.vcd");
        $dumpvars(0, mips_tb);

        // reset conditions
        rst = 1'b1;
        clk = 1'b0;

        PC = 32'd0;
        reg_write = 1'b0;
        write_register = 5'b0;

        RA = 5'b0;
        RB = 5'b0;

        #20;
        @(posedge clk);
        rst = 1'b0;
        `test(busA, 32'b0);
        `test(busB, 32'b0);


        #20;
        @(posedge clk);

        #20;
        @(posedge clk);

        #10;
        `test(busA, 32'd0);
        `test(busB, 32'd0);

        $display("Test complete");
        $finish;

    end // initial begin
endmodule // mips_tb
