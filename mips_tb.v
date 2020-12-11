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

    wire [31:0] pc;

    pc pc_module(
                 .pc(pc),
                 .clk(clk),
                 .rst(rst));

    wire [31:0] busA;
    wire [31:0] busB;


    wire [31:0] instruction;
    wire [5:0]  opcode = instruction[31:26];
    wire [4:0]  RS = instruction[25:21];
    wire [4:0]  RT = instruction[20:16];
    wire [4:0]  RD = instruction[15:10];
    wire [31:0]  immediate = { {16{instruction[15]}}, instruction[15:0]};
    wire [5:0]  funct = instruction[5:0];

    instruction_memory imem(
                            .read_address(pc),
                            .instruction(instruction),
                            .clk(clk),
                            .rst(rst));


    wire        alu_zero;
    wire [31:0] alu_out;
    wire [31:0] alu_busB = (`I_TYPE_INSTRUCTION(opcode)) ? immediate : busB;

    alu alu(
            .opcode(opcode),
            .funct(funct),
            .busA(busA),
            .busB(alu_busB),
            .result(alu_out),
            .zero(alu_zero),
            .clk(clk),
            .rst(rst));



    wire reg_write_enable = ((opcode == `OP_LUI) ? 1'b1 :
                             (opcode == `OP_ADDI) ? 1'b1 :
                             1'b0);
    wire [4:0] reg_write_register = (`I_TYPE_INSTRUCTION(opcode)) ? RT : RD;
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

        rst = 1'b1;
        clk = 1'b0;
        @(posedge clk);

        $dumpfile("mips_tb.vcd");
        $dumpvars(0, mips_tb);

        @(posedge clk);
        rst = 1'b0;

        @(posedge clk);
        // lui $s1, 7
        `test(reg_write_register, 5'b1)
        `test(reg_write_data, 32'd7)
        `test(reg_write_enable, 1'b1)

        @(posedge clk);
        // addi $s2, $s1, 5
        `test(reg_write_register, 5'd2)
        `test(reg_write_data, 32'd12)
        `test(reg_write_enable, 1'b1)

        $display("Test complete");
        $finish;

    end // initial begin
endmodule // mips_tb
