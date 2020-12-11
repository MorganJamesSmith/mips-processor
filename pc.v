// Copyright (C) 2020 by Morgan Smith

module pc
  (
   output [31:0] pc,
   input         clk,
   input         rst
   );

    reg [31:0]   pc_reg;
    assign pc = pc_reg;

    always@(posedge clk)
    begin
        if(rst)
        begin
            pc_reg <= 32'd0;
        end
        else
        begin
            pc_reg <= pc_reg + 32'd4;
        end
    end // always@ (posedge clk)
endmodule // pc
