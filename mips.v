// Copyright (C) 2020 by Morgan Smith

`timescale  1 ns / 1 ns

module mips
  (
   input         clk,
   input         rst
   );

    reg [31:0] PC;

    reg        reg_write;
    reg [4:0]  write_register;
    wire [31:0] busW;

    reg [4:0]   RA;
    reg [4:0]   RB;

    wire [31:0] busA;
    wire [31:0] busB;

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

endmodule // mips
