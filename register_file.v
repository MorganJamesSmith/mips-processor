// Copyright (C) 2020 by Morgan Smith

module register_file
  (
   input         write_enable,
   input [4:0]   write_register,
   input [31:0]  busW,

   input [4:0]   RS,
   input [4:0]   RT,

   output [31:0] busA,
   output [31:0] busB,

   input         rst,
   input         clk
   );

    integer      i;

    reg [31:0]   registers[4:0];

    reg [31:0]   busA_reg;
    reg [31:0]   busB_reg;

    assign busA = busA_reg;
    assign busB = busB_reg;


    always @ (RS or RT or rst)
    begin
        if(rst)
        begin
            busA_reg <= 32'b0;
            busB_reg <= 32'b0;
        end
        else
        begin
            busA_reg = registers[RS];
            busB_reg = registers[RT];
        end
    end // always@ (RS or RT or rst)


    always@(posedge clk)
    begin
        if(rst)
        begin
            for(i = 0; i < 32; i++)
              registers[i] <= 32'b0;
        end
        else
        begin
            if(write_enable)
            begin
                // Register 0 should always contain 0
                if (write_register !== 0)
                  registers[write_register] <= busW;
            end
        end
    end // always@ (posedge clk)

endmodule // register_file
