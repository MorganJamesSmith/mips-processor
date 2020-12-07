// Copyright (C) 2020 by Morgan Smith

module data_memory
  (
   input [31:0]  address,
   input         write_enable,
   input [31:0]  data_in,

   output [31:0] data_out,

   input         clk,
   input         rst
   );

    integer      i;

    reg [31:0]   data_memory[31:0];

    reg [31:0]   data_out_reg;
    assign data_out = data_out_reg;

    always@(posedge clk)
    begin
        if(rst)
        begin
            for(i = 0; i < 4294967296; i++)
              data_memory[i] <= 32'b0;
        end
        else
        begin
            if(write_enable)
              data_memory[address] <= data_in;
            else
              data_out_reg <= data_memory[address];
        end
    end // always@ (posedge clk)

endmodule // data_memory
