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

module exu (
    input logic clk,
    input logic rst_n,

    /* IDU1 -> EXU Interface */
    input idu1_out_t idu1_out,

    /* ONLY FOR DEBUG */
    output logic [XLEN-1:0] instr_tag_out,
    output logic [    31:0] instr_out,

    /* EXU -> IDU1 (WB) Interface */
    output logic [XLEN-1:0] exu_wb_data,
    output logic [     4:0] exu_wb_rd_addr,
    output logic            exu_wb_rd_wr_en,
    output logic            exu_mul_busy,
    output logic            exu_div_busy,
    output logic            exu_lsu_busy,
    output logic            exu_lsu_stall,

    /* DCCM Interface */
    output logic [XLEN-1:0] dccm_raddr,
    output logic            dccm_rvalid_in,
    input  logic [XLEN-1:0] dccm_rdata,
    input  logic            dccm_rvalid_out,
    output logic [XLEN-1:0] dccm_waddr,
    output logic            dccm_wen,
    output logic [XLEN-1:0] dccm_wdata
);

  logic [XLEN-1:0] alu_wb_data;
  logic [     4:0] alu_wb_rd_addr;
  logic            alu_wb_rd_wr_en;

  logic [XLEN-1:0] mul_wb_data;
  logic [     4:0] mul_wb_rd_addr;
  logic            mul_wb_rd_wr_en;

  logic [XLEN-1:0] div_wb_data;
  logic [     4:0] div_wb_rd_addr;
  logic            div_wb_rd_wr_en;

  logic [XLEN-1:0] lsu_wb_data;
  logic [     4:0] lsu_wb_rd_addr;
  logic            lsu_wb_rd_wr_en;

  /* ONLY FOR DEBUG */
  logic [XLEN-1:0] alu_instr_tag_out;
  logic [    31:0] alu_instr_out;
  logic [XLEN-1:0] mul_instr_tag_out;
  logic [    31:0] mul_instr_out;
  logic [XLEN-1:0] div_instr_tag_out;
  logic [    31:0] div_instr_out;
  logic [XLEN-1:0] lsu_instr_tag_out;
  logic [    31:0] lsu_instr_out;

  alu alu_inst (
      .clk            (clk),
      .rst_n          (rst_n),
      .alu_ctrl       (idu1_out),
      .alu_wb_data    (alu_wb_data),
      .alu_wb_rd_addr (alu_wb_rd_addr),
      .alu_wb_rd_wr_en(alu_wb_rd_wr_en),
      .instr_tag_out  (alu_instr_tag_out),
      .instr_out      (alu_instr_out)
  );

  mul mul_inst (
      .clk          (clk),
      .rst_n        (rst_n),
      .freeze       (1'b0),
      .mul_ctrl     (idu1_out),
      .out          (mul_wb_data),
      .out_rd_addr  (mul_wb_rd_addr),
      .out_rd_wr_en (mul_wb_rd_wr_en),
      .instr_tag_out(mul_instr_tag_out),
      .instr_out    (mul_instr_out),
      .mul_busy     (exu_mul_busy)
  );

  div div_inst (
      .clk                     (clk),
      .rst_n                   (rst_n),
      .dp                      (idu1_out),
      .dec_tlu_fast_div_disable(1'b0),
      .flush_lower             (1'b0),
      .out                     (div_wb_data),
      .out_addr                (div_wb_rd_addr),
      .out_valid               (div_wb_rd_wr_en),
      .finish                  (),
      .finish_early            (),
      .valid_ff_e1             (),
      .instr_out               (div_instr_out),
      .instr_tag_out           (div_instr_tag_out),
      .div_stall               (exu_div_busy)
  );

  lsu lsu_inst (
      .clk                (clk),
      .rst_n              (rst_n),
      .lsu_ctrl           (idu1_out),
      .lsu_wb_data        (lsu_wb_data),
      .lsu_wb_rd_addr     (lsu_wb_rd_addr),
      .lsu_wb_rd_wr_en    (lsu_wb_rd_wr_en),
      .instr_tag_out      (lsu_instr_tag_out),
      .instr_out          (lsu_instr_out),
      .lsu_busy           (exu_lsu_busy),
      .lsu_stall          (exu_lsu_stall),
      .lsu_dccm_raddr     (dccm_raddr),
      .lsu_dccm_rvalid_in (dccm_rvalid_in),
      .lsu_dccm_rdata     (dccm_rdata),
      .lsu_dccm_rvalid_out(dccm_rvalid_out),
      .lsu_dccm_waddr     (dccm_waddr),
      .lsu_dccm_wen       (dccm_wen),
      .lsu_dccm_wdata     (dccm_wdata)
  );

  assign exu_wb_data = ({XLEN{alu_wb_rd_wr_en}} & alu_wb_data) | 
                       ({XLEN{mul_wb_rd_wr_en}} & mul_wb_data) | 
                       ({XLEN{div_wb_rd_wr_en}} & div_wb_data) |
                       ({XLEN{lsu_wb_rd_wr_en}} & lsu_wb_data);

  assign exu_wb_rd_addr = ({5{alu_wb_rd_wr_en}} & alu_wb_rd_addr) | 
                          ({5{mul_wb_rd_wr_en}} & mul_wb_rd_addr) | 
                          ({5{div_wb_rd_wr_en}} & div_wb_rd_addr) |
                          ({5{lsu_wb_rd_wr_en}} & lsu_wb_rd_addr);

  assign exu_wb_rd_wr_en = alu_wb_rd_wr_en | mul_wb_rd_wr_en | div_wb_rd_wr_en | lsu_wb_rd_wr_en;

  /* ONLY FOR DEBUG */
  assign instr_tag_out = ({XLEN{alu_wb_rd_wr_en}} & alu_instr_tag_out) | 
                         ({XLEN{mul_wb_rd_wr_en}} & mul_instr_tag_out) | 
                         ({XLEN{div_wb_rd_wr_en}} & div_instr_tag_out) |
                         ({XLEN{lsu_wb_rd_wr_en}} & lsu_instr_tag_out);

  assign instr_out = ({32{alu_wb_rd_wr_en}} & alu_instr_out) | 
                     ({32{mul_wb_rd_wr_en}} & mul_instr_out) | 
                     ({32{div_wb_rd_wr_en}} & div_instr_out) |
                     ({32{lsu_wb_rd_wr_en}} & lsu_instr_out);

endmodule
