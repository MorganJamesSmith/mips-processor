// Copyright (C) 2020 Morgan Smith <Morgan.J.Smith@outlook.com>

`define OP_NOP  4'b0000
`define OP_ADD  4'b0001
`define OP_SUB  4'b0010
`define OP_MUL  4'b0011
`define OP_DIV  4'b0100

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
                6'b100000:
                  opreg = `OP_ADD;
                6'b100010:
                  opreg = `OP_SUB ;
                6'b011000:
                  opreg = `OP_MUL ;
                6'b011010:
                  opreg = `OP_DIV;
                endcase // case (funct)
            end
        6'b001000:
          opreg = `OP_ADD;
        default:
          opreg = `OP_NOP;
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
            `OP_ADD:
                  result_reg <= busA + busB;
            `OP_SUB:
                  result_reg <= busA - busB;
            `OP_MUL:
                  result_reg <= busA * busB;
            `OP_DIV:
                  result_reg <= busA / busB;
            endcase // case (op)
        end
    end // always@ (posedge clk)
endmodule // alu
