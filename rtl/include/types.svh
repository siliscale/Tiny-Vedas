/*

MIT License

Copyright (c) 2025 Siliscale Consulting LLC

https://siliscale.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without 
limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of 
the Software, and to permit persons to whom the Software is furnished to do so, subject to the following 
conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions 
of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED 
TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
DEALINGS IN THE SOFTWARE.

*/

`ifndef TYPES_SVH
`define TYPES_SVH

typedef struct packed {

  logic [31:0]             instr;
  logic [XLEN-1:0]         instr_tag;
  logic [4:0]              rs1_addr;
  logic [4:0]              rs2_addr;
  logic [XLEN-1:0]         imm;
  logic                    imm_valid;
  logic [4:0]              rd_addr;
  logic [$clog2(XLEN)-1:0] shamt;

  /* Automatically generated */
  logic alu;
  logic rs1;
  logic rs2;
  logic imm12;
  logic rd;
  logic shimm5;
  logic imm20;
  logic pc;
  logic load;
  logic store;
  logic lsu;
  logic add;
  logic sub;
  logic land;
  logic lor;
  logic lxor;
  logic sll;
  logic sra;
  logic srl;
  logic slt;
  logic unsign;
  logic condbr;
  logic beq;
  logic bne;
  logic bge;
  logic blt;
  logic jal;
  logic by;
  logic half;
  logic word;
  logic mul;
  logic rs1_sign;
  logic rs2_sign;
  logic low;
  logic div;
  logic rem;
  logic nop;
  logic legal;
} idu0_out_t;

typedef struct packed {

  logic alu;
  logic rs1;
  logic rs2;
  logic imm12;
  logic rd;
  logic shimm5;
  logic imm20;
  logic pc;
  logic load;
  logic store;
  logic lsu;
  logic add;
  logic sub;
  logic land;
  logic lor;
  logic lxor;
  logic sll;
  logic sra;
  logic srl;
  logic slt;
  logic unsign;
  logic condbr;
  logic beq;
  logic bne;
  logic bge;
  logic blt;
  logic jal;
  logic by;
  logic half;
  logic word;
  logic mul;
  logic rs1_sign;
  logic rs2_sign;
  logic low;
  logic div;
  logic rem;
  logic nop;
  logic legal;
} decode_out_t;

typedef struct packed {

  logic [31:0]             instr;
  logic [XLEN-1:0]         instr_tag;
  logic [XLEN-1:0]         rs1_data;
  logic [XLEN-1:0]         rs2_data;
  logic [4:0]              rs1_addr;
  logic [4:0]              rs2_addr;
  logic [XLEN-1:0]         imm;
  logic                    imm_valid;
  logic [4:0]              rd_addr;
  logic [$clog2(XLEN)-1:0] shamt;

  /* Automatically generated */
  logic alu;
  logic rs1;
  logic rs2;
  logic imm12;
  logic rd;
  logic shimm5;
  logic imm20;
  logic pc;
  logic load;
  logic store;
  logic lsu;
  logic add;
  logic sub;
  logic land;
  logic lor;
  logic lxor;
  logic sll;
  logic sra;
  logic srl;
  logic slt;
  logic unsign;
  logic condbr;
  logic beq;
  logic bne;
  logic bge;
  logic blt;
  logic jal;
  logic by;
  logic half;
  logic word;
  logic mul;
  logic rs1_sign;
  logic rs2_sign;
  logic low;
  logic div;
  logic rem;
  logic nop;
  logic legal;
} idu1_out_t;

typedef struct packed {
  logic [31:0] instr;
  logic [XLEN-1:0] instr_tag;
  logic [4:0] rs1_addr;
  logic [4:0] rs2_addr;
  logic [4:0] rd_addr;
  logic mul;
  logic alu;
  logic div;
  logic lsu;
} last_issued_instr_t;

typedef enum logic [2:0] {
  LSU_IDLE,
  LSU_LOAD_1,
  LSU_LOAD_2,
  LSU_DONE
} lsu_state_t;

`endif
