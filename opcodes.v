`ifndef OPCODES_V
`define OPCODES_V

`ifndef true
`define true 1
`endif

`ifndef false
`define false 0
`endif

`define FUNCT_ADD  6'b100000
`define FUNCT_SUB  6'b100010
`define FUNCT_MUL  6'b011000
`define FUNCT_DIV  6'b011010


// Memory Access
`define OP_LB   6'b100000
`define OP_LBU  6'b100100
`define OP_LH   6'b100001
`define OP_LBU  6'b100101
`define OP_LW   6'b100011
`define OP_SB   6'b101000
`define OP_SH   6'b101001
`define OP_SW   6'b101011

`define IS_MEMORY_ACCESS(opcode) \
        ((opcode == `OP_LB ) ? `true : \
         (opcode == `OP_LBU) ? `true : \
         (opcode == `OP_LH ) ? `true : \
         (opcode == `OP_LBU) ? `true : \
         (opcode == `OP_LW ) ? `true : \
         (opcode == `OP_SB ) ? `true : \
         (opcode == `OP_SH ) ? `true : \
         (opcode == `OP_SW ) ? `true : \
         `false)

`endif
