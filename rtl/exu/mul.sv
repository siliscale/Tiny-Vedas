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

module mul (
    input  logic                 clk,
    input  logic                 rstn,
    input  logic                 freeze,
    input  idu1_out_t            mul_ctrl,
    output logic      [XLEN-1:0] out,
    output logic      [     4:0] out_rd_addr,
    output logic                 out_rd_wr_en,
    output logic      [XLEN-1:0] instr_tag_out,
    output logic      [    31:0] instr_out,
    output logic                 mul_busy

);


  logic valid_e1, valid_e2;
  logic mul_c1_e1_clken, mul_c1_e2_clken, mul_c1_e3_clken;
  logic exu_mul_c1_e1_clk, exu_mul_c1_e2_clk, exu_mul_c1_e3_clk;

  logic [XLEN-1:0] a_ff_e1, a_e1;
  logic [XLEN-1:0] b_ff_e1, b_e1;
  logic rs1_sign_e1, rs1_neg_e1;
  logic rs2_sign_e1, rs2_neg_e1;
  logic signed [XLEN:0] a_ff_e2, b_ff_e2;
  logic signed [2*XLEN:0] prod_e3;
  logic low_e1, low_e2, low_e3;

  logic [XLEN-1:0] a, b;
  logic [4:0] out_rd_addr_e1, out_rd_addr_e2, out_rd_addr_e3;
  logic out_rd_wr_en_e1, out_rd_wr_en_e2, out_rd_wr_en_e3;

  logic [XLEN-1:0] instr_tag_e1, instr_tag_e2, instr_tag_e3;
  logic [31:0] instr_e1, instr_e2, instr_e3;

  assign a = mul_ctrl.rs1_data;
  assign b = mul_ctrl.rs2_data;

  // --------------------------- Input flops    ----------------------------------

  register_en_sync_rstn #(
      .WIDTH(1)
  ) valid_e1_ff (
      .clk (clk),
      .rstn(rstn),
      .din (mul_ctrl.legal & mul_ctrl.mul),
      .dout(valid_e1),
      .en  (~freeze)
  );
  register_sync_rstn #(
      .WIDTH(1)
  ) rs1_sign_e1_ff (
      .clk (clk),
      .rstn(rstn),
      .din (mul_ctrl.rs1_sign),
      .dout(rs1_sign_e1)
  );
  register_sync_rstn #(
      .WIDTH(1)
  ) rs2_sign_e1_ff (
      .clk (clk),
      .rstn(rstn),
      .din (mul_ctrl.rs2_sign),
      .dout(rs2_sign_e1)
  );
  register_sync_rstn #(
      .WIDTH(1)
  ) low_e1_ff (
      .clk (clk),
      .rstn(rstn),
      .din (mul_ctrl.low),
      .dout(low_e1)
  );

  register_sync_rstn #(
      .WIDTH(XLEN)
  ) a_e1_ff (
      .clk (clk),
      .rstn(rstn),
      .din (a[XLEN-1:0]),
      .dout(a_ff_e1[XLEN-1:0])
  );
  register_sync_rstn #(
      .WIDTH(XLEN)
  ) b_e1_ff (
      .clk (clk),
      .rstn(rstn),
      .din (b[XLEN-1:0]),
      .dout(b_ff_e1[XLEN-1:0])
  );

  register_sync_rstn #(
      .WIDTH(5)
  ) out_rd_addr_ff (
      .clk (clk),
      .rstn(rstn),
      .din (mul_ctrl.rd_addr),
      .dout(out_rd_addr_e1)
  );

  register_sync_rstn #(
      .WIDTH(1)
  ) out_rd_wr_en_ff (
      .clk (clk),
      .rstn(rstn),
      .din (mul_ctrl.legal & mul_ctrl.mul),
      .dout(out_rd_wr_en_e1)
  );

  register_sync_rstn #(
      .WIDTH(XLEN + 32)
  ) instr_tag_ff (
      .clk (clk),
      .rstn(rstn),
      .din ({mul_ctrl.instr_tag, mul_ctrl.instr}),
      .dout({instr_tag_e1, instr_e1})
  );


  // --------------------------- E1 Logic Stage ----------------------------------

  assign a_e1[XLEN-1:0] = a_ff_e1[XLEN-1:0];
  assign b_e1[XLEN-1:0] = b_ff_e1[XLEN-1:0];

  assign rs1_neg_e1 = rs1_sign_e1 & a_e1[XLEN-1];
  assign rs2_neg_e1 = rs2_sign_e1 & b_e1[XLEN-1];


  register_en_sync_rstn #(
      .WIDTH(1)
  ) valid_e2_ff (
      .clk (clk),
      .rstn(rstn),
      .din (valid_e1),
      .dout(valid_e2),
      .en  (~freeze)
  );
  register_sync_rstn #(
      .WIDTH(1)
  ) low_e2_ff (
      .clk (clk),
      .rstn(rstn),
      .din (low_e1),
      .dout(low_e2)
  );

  register_sync_rstn #(
      .WIDTH(XLEN + 1)
  ) a_e2_ff (
      .clk (clk),
      .rstn(rstn),
      .din ({rs1_neg_e1, a_e1[XLEN-1:0]}),
      .dout(a_ff_e2[XLEN:0])
  );
  register_sync_rstn #(
      .WIDTH(XLEN + 1)
  ) b_e2_ff (
      .clk (clk),
      .rstn(rstn),
      .din ({rs2_neg_e1, b_e1[XLEN-1:0]}),
      .dout(b_ff_e2[XLEN:0])
  );
  register_sync_rstn #(
      .WIDTH(5)
  ) out_rd_addr_e2_ff (
      .clk (clk),
      .rstn(rstn),
      .din (out_rd_addr_e1),
      .dout(out_rd_addr_e2)
  );

  register_sync_rstn #(
      .WIDTH(1)
  ) out_rd_wr_en_e2_ff (
      .clk (clk),
      .rstn(rstn),
      .din (out_rd_wr_en_e1),
      .dout(out_rd_wr_en_e2)
  );

  register_sync_rstn #(
      .WIDTH(XLEN + 32)
  ) instr_tag_e2_ff (
      .clk (clk),
      .rstn(rstn),
      .din ({instr_tag_e1, instr_e1}),
      .dout({instr_tag_e2, instr_e2})
  );


  // ---------------------- E2 Logic Stage --------------------------


  logic signed [2*XLEN+1:0] prod_e2;

  assign prod_e2[2*XLEN+1:0] = a_ff_e2 * b_ff_e2;

  register_sync_rstn #(
      .WIDTH(1)
  ) low_e3_ff (
      .clk (clk),
      .rstn(rstn),
      .din (low_e2),
      .dout(low_e3)
  );
  register_sync_rstn #(
      .WIDTH(2 * XLEN + 1)
  ) prod_e3_ff (
      .clk (clk),
      .rstn(rstn),
      .din (prod_e2[2*XLEN:0]),
      .dout(prod_e3[2*XLEN:0])
  );

  register_sync_rstn #(
      .WIDTH(5)
  ) out_rd_addr_e3_ff (
      .clk (clk),
      .rstn(rstn),
      .din (out_rd_addr_e2),
      .dout(out_rd_addr_e3)
  );

  register_sync_rstn #(
      .WIDTH(1)
  ) out_rd_wr_en_e3_ff (
      .clk (clk),
      .rstn(rstn),
      .din (out_rd_wr_en_e2),
      .dout(out_rd_wr_en_e3)
  );

  register_sync_rstn #(
      .WIDTH(XLEN + 32)
  ) instr_tag_e3_ff (
      .clk (clk),
      .rstn(rstn),
      .din ({instr_tag_e2, instr_e2}),
      .dout({instr_tag_e3, instr_e3})
  );
  // ----------------------- E3 Logic Stage -------------------------

  assign out[XLEN-1:0] = low_e3 ? prod_e3[XLEN-1:0] : prod_e3[2*XLEN-1:XLEN];
  assign out_rd_wr_en = out_rd_wr_en_e3;
  assign out_rd_addr = out_rd_addr_e3;

  assign instr_tag_out = instr_tag_e3;
  assign instr_out = instr_e3;
  assign mul_busy = out_rd_wr_en_e2 | out_rd_wr_en_e1;


endmodule  // exu_mul_ctl
