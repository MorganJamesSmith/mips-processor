// Copyright (C) 2020 Morgan Smith <Morgan.J.Smith@outlook.com>

module alu
  (
   input [3:0]   op,

   input [31:0]  busA,
   input [31:0]  busB,

   output [31:0] result,
   output        zero,

   input         clk,
   input         rst
   );

    reg [31:0]   result_reg;

    // TODO: Write out all the op codes
`define OP_ADD 6'b000000

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
              begin
                  result_reg <= busA + busB;
              end
            endcase // case (op)
        end
    end // always@ (posedge clk)
endmodule // alu
