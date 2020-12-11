// Copyright (C) 2020 by Morgan Smith

`timescale  1 ns / 1 ns

`include "opcodes.v"

`define test(signal, value) \
        if (signal !== value) begin \
            $display("TEST FAILED in %m: signal != value"); \
        end

module mips_tb;

    // TODO: Make a mips module instead of putting everything together here

    reg         rst;
    reg         clk;

    // Program Counter
    reg [31:0] PC;

    wire [31:0] busA;
    wire [31:0] busB;


    wire [31:0] instruction;
    wire [5:0]  opcode = instruction[31:26];
    wire [4:0]  RS = instruction[25:21];
    wire [4:0]  RT = instruction[20:16];
    wire [31:0]  immediate = { {16{instruction[15]}}, instruction[15:0]};
    wire [5:0]  funct = instruction[5:0];

    instruction_memory imem(
                            .read_address(PC),
                            .instruction(instruction),
                            .clk(clk),
                            .rst(rst));


    wire        alu_zero;
    wire [31:0] alu_out;
    wire [31:0] alu_busB = (opcode == 6'b001000) ? immediate : busB;

    alu alu(
            .opcode(opcode),
            .funct(funct),
            .busA(busA),
            .busB(alu_busB),
            .result(alu_out),
            .zero(alu_zero),
            .clk(clk),
            .rst(rst));



    reg         reg_write_enable;
    reg [4:0]   reg_write_register;
    wire [31:0] reg_write_data;
    assign reg_write_data = (`IS_MEMORY_ACCESS(opcode)) ? dmem_out : alu_out;

    register_file reg_file(
                           .write_enable(reg_write_enable),
                           .write_register(reg_write_register),
                           .busW(reg_write_data),
                           .RS(RS),
                           .RT(RT),
                           .busA(busA),
                           .busB(busB),
                           .rst(rst),
                           .clk(clk));

    reg         dmem_write;
    wire [31:0] dmem_out;
    data_memory dmem(
                     .address(alu_out),
                     .write_enable(dmem_write),
                     .data_in(busB),
                     .data_out(dmem_out),
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
        reg_write_enable = 1'b0;
        reg_write_register = 5'b0;

        #20;
        @(posedge clk);
        `test(alu_out, 32'b0);
        rst = 1'b0;


        #20;
        @(posedge clk);

        #20;
        @(posedge clk);

        #10;
        `test(alu_out, 32'd5);

        $display("Test complete");
        $finish;

    end // initial begin
endmodule // mips_tb
