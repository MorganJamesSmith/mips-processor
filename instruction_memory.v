// Copyright (C) 2020 by Morgan Smith

module instruction_memory
  (
   input [31:0]  read_address,
   output [31:0] instruction,

   input         clk,
   input         rst
   );

    reg [7:0]   memory[31:0];

    initial begin
        $readmemb("binary-instructions.txt", memory, 0, 23);
    end

    reg [31:0] instruction_reg;
    assign instruction = instruction_reg;

    always @ (read_address or rst)
    begin
        if(rst)
        begin
            instruction_reg <= 32'b0;
        end
        else
        begin
            instruction_reg <= {memory[read_address],
                                memory[read_address + 1],
                                memory[read_address + 2],
                                memory[read_address + 3]};
        end
    end // always@ (posedge clk)
endmodule // instruction_memory
