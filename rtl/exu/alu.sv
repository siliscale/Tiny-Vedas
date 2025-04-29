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

`ifndef GLOBAL_SVH
`include "global.svh"
`endif

`ifndef TYPES_SVH
`include "types.svh"
`endif

module alu (

    input logic clk,
    input logic rst_n,

    input idu1_out_t alu_ctrl,

    output logic [XLEN-1:0] instr_tag_out,
    output logic [    31:0] instr_out,

    output logic [XLEN-1:0] alu_wb_data,
    output logic [     4:0] alu_wb_rd_addr,
    output logic            alu_wb_rd_wr_en
);

  logic [XLEN-1:0] alu_wb_data_i;
  logic [     4:0] alu_wb_rd_addr_i;
  logic            alu_wb_rd_wr_en_i;

  logic [XLEN-1:0] a, b;

  logic [XLEN-1:0] aout, bm;
  logic cout, ov, neg;
  logic [3:1] logic_sel;
  logic [XLEN-1:0] lout;
  logic [XLEN-1:0] sout;

  logic sel_logic, sel_shift, sel_adder;
  logic            slt_one;
  logic [XLEN-1:0] pcout;
  logic [XLEN-1:0] ashift;
  logic eq, ne, lt, ge;

  assign a = alu_ctrl.rs1_data;
  assign b = (alu_ctrl.imm_valid) ? alu_ctrl.imm : (alu_ctrl.shimm5) ? {{(XLEN-5){1'b0}}, alu_ctrl.shamt[$clog2(
      XLEN
  )-1:0]} : alu_ctrl.rs2_data;

  assign bm[XLEN-1:0] = (alu_ctrl.sub) ? ~b[XLEN-1:0] : b[XLEN-1:0];

  assign {cout, aout[31:0]} = {1'b0, a[31:0]} + {1'b0, bm[31:0]} + {32'b0, alu_ctrl.sub};

  assign ov = (~a[31] & ~b[31] & aout[31]) | (a[31] & b[31] & ~aout[31]);

  assign neg = aout[XLEN-1];

  assign eq = a == b;

  assign ne = ~eq;

  assign logic_sel[3] = alu_ctrl.land | alu_ctrl.lor;
  assign logic_sel[2] = alu_ctrl.lor | alu_ctrl.lxor;
  assign logic_sel[1] = alu_ctrl.lor | alu_ctrl.lxor;

  assign lout[XLEN-1:0] =  (  a[XLEN-1:0] &  b[XLEN-1:0] & {XLEN{logic_sel[3]}} ) |
                        (  a[XLEN-1:0] & ~b[XLEN-1:0] & {XLEN{logic_sel[2]}} ) |
                        ( ~a[XLEN-1:0] &  b[XLEN-1:0] & {XLEN{logic_sel[1]}} );


  assign ashift[XLEN-1:0] = $signed(a) >>> b[$clog2(XLEN)-1:0];

  assign sout[XLEN-1:0] = ({XLEN{alu_ctrl.sll}} & (a[XLEN-1:0] << b[$clog2(
      XLEN
  )-1:0])) | ({XLEN{alu_ctrl.srl}} & (a[XLEN-1:0] >> b[$clog2(
      XLEN
  )-1:0])) | ({XLEN{alu_ctrl.sra}} & ashift[XLEN-1:0]);

  assign sel_logic = |{alu_ctrl.land, alu_ctrl.lor, alu_ctrl.lxor};

  assign sel_shift = |{alu_ctrl.sll, alu_ctrl.srl, alu_ctrl.sra};

  assign sel_adder = (alu_ctrl.add | alu_ctrl.sub) & ~alu_ctrl.slt;

  assign lt = (~alu_ctrl.unsign & (neg ^ ov)) | (alu_ctrl.unsign & ~cout);

  assign ge = ~lt;

  assign slt_one = (alu_ctrl.slt & lt);

  assign alu_wb_data_i[XLEN-1:0] = ({XLEN{sel_logic}} & lout[XLEN-1:0]) |
                                    ({XLEN{sel_shift}} & sout[XLEN-1:0]) |
                                    ({XLEN{sel_adder}} & aout[XLEN-1:0]) |
                                    ({XLEN{slt_one}} & {{(XLEN-1){1'b0}}, 1'b1});

  assign alu_wb_rd_addr_i = alu_ctrl.rd_addr;
  assign alu_wb_rd_wr_en_i = alu_ctrl.rd & alu_ctrl.legal & alu_ctrl.alu & ~alu_ctrl.nop;

  dff_rst #(
      .WIDTH($bits({alu_wb_data_i, alu_wb_rd_addr_i, alu_wb_rd_wr_en_i}))
  ) alu_wb_data_ff (
      .clk  (clk),
      .rst_n(rst_n),
      .din  ({alu_wb_data_i, alu_wb_rd_addr_i, alu_wb_rd_wr_en_i}),
      .dout ({alu_wb_data, alu_wb_rd_addr, alu_wb_rd_wr_en})
  );

  dff_rst #(XLEN + 32) instr_tag_ff (
      .clk  (clk),
      .rst_n(rst_n),
      .din  ({alu_ctrl.instr_tag, alu_ctrl.instr}),
      .dout ({instr_tag_out, instr_out})
  );



endmodule


