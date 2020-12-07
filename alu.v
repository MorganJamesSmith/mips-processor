// Copyright (C) 2020 Morgan Smith <Morgan.J.Smith@outlook.com>

`include "opcodes.v"

// These opcodes are internal to the ALU and should not be used anywhere else
`define ALU_OP_NOP  4'b0000
`define ALU_OP_ADD  4'b0001
`define ALU_OP_SUB  4'b0010
`define ALU_OP_MUL  4'b0011
`define ALU_OP_DIV  4'b0100

module alu_control
  (
   input [5:0] opcode,
   input [5:0] funct,
   output [3:0] op
   );

    reg [3:0]   opreg;
    assign op = opreg;

    always @ (opcode or funct)
    begin
        case(opcode)
          6'b000000:
            begin
                case(funct)
                `FUNCT_ADD:
                  opreg = `ALU_OP_ADD;
                `FUNCT_SUB:
                  opreg = `ALU_OP_SUB ;
                `FUNCT_MUL:
                  opreg = `ALU_OP_MUL ;
                `FUNCT_DIV:
                  opreg = `ALU_OP_DIV;
                endcase // case (funct)
            end
        6'b001000:
          opreg = `ALU_OP_ADD;
        default:
          opreg = `ALU_OP_NOP;
        endcase // case (opcode)
    end // always @ (opcode or funct)
endmodule // alu_control


module alu
  (
   input [5:0] opcode,
   input [5:0] funct,

   input [31:0]  busA,
   input [31:0]  busB,

   output [31:0] result,
   output        zero,

   input         clk,
   input         rst
   );

    wire [3:0]   op;

    alu_control alu_control(
                            .opcode(opcode),
                            .funct(funct),
                            .op(op));

    reg [31:0]   result_reg;
    assign result = result_reg;


    always@(posedge clk)
    begin
        if(rst)
        begin
            result_reg <= 32'd0;
        end
        else
        begin
            case(op)
            `ALU_OP_ADD:
                  result_reg <= busA + busB;
            `ALU_OP_SUB:
                  result_reg <= busA - busB;
            `ALU_OP_MUL:
                  result_reg <= busA * busB;
            `ALU_OP_DIV:
                  result_reg <= busA / busB;
            endcase // case (op)
        end
    end // always@ (posedge clk)
endmodule // alu
