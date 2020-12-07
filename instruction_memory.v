// Copyright (C) 2020 by Morgan Smith

module instruction_memory
  (
   input [31:0]  read_address,
   output [31:0] instruction,

   input         clk,
   input         rst
   );

    reg [31:0]   memory[31:0];

    initial begin
        $readmemh("instructions.hex", memory, 0, 15);
    end

    reg [31:0] instruction_reg;
    assign instruction = instruction_reg;

    always@(posedge clk)
    begin
        if(rst)
        begin
            instruction_reg <= 32'b0;
        end
        else
        begin
            instruction_reg <= memory[read_address];
        end
    end // always@ (posedge clk)
endmodule // instruction_memory
