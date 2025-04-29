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

/* ***** Tiny Vedas Core Top ***** */

`ifndef GLOBAL_SVH
`include "global.svh"
`endif

`ifndef TYPES_SVH
`include "types.svh"
`endif

module core_top #(
    parameter string ICCM_INIT_FILE = "",
    parameter string DCCM_INIT_FILE = ""
) (

    /* Clock and Reset */
    input logic            clk,
    input logic            rst_n,
    input logic [XLEN-1:0] reset_vector

);

  /* Signals Definitions */

  /* Instruction Memory <-> IFU Interface */
  logic      [INSTR_MEM_ADDR_WIDTH-1:0] instr_mem_addr;
  logic                                 instr_mem_addr_valid;
  logic      [ INSTR_MEM_TAG_WIDTH-1:0] instr_mem_tag_out;
  logic      [     INSTR_MEM_WIDTH-1:0] instr_mem_rdata;
  logic                                 instr_mem_rdata_valid;
  logic      [ INSTR_MEM_TAG_WIDTH-1:0] instr_mem_tag_in;

  /* IFU -> IDU0 Interface */
  logic      [           INSTR_LEN-1:0] instr;
  logic                                 instr_valid;

  /* IDU0 -> IDU1 Interface */
  idu0_out_t                            idu0_out;

  /* IDU1 -> EXU Interface */
  idu1_out_t                            idu1_out;
  logic                                 pipe_stall;

  /* EXU -> IDU1 (WB) Interface */
  logic      [                XLEN-1:0] exu_wb_data = '0;
  logic      [                     4:0] exu_wb_rd_addr = '0;
  logic                                 exu_wb_rd_wr_en = '0;
  logic                                 exu_mul_busy;
  logic                                 exu_div_busy;
  logic                                 exu_lsu_busy;
  logic                                 exu_lsu_stall;

  /* Data Memory */
  logic      [                XLEN-1:0] dccm_raddr;
  logic                                 dccm_rvalid_in;
  logic      [                XLEN-1:0] dccm_rdata;
  logic                                 dccm_rvalid_out;
  logic      [                XLEN-1:0] dccm_waddr;
  logic                                 dccm_wen;
  logic      [                XLEN-1:0] dccm_wdata;
  /* ONLY FOR DEBUG */
  logic      [                XLEN-1:0] exu_instr_tag_out;
  logic      [                XLEN-1:0] exu_instr_out;
  logic      [                XLEN-1:0] instr_tag;

  /* Modules Instantiations */

  /* Instruction Memory */
  iccm #(
      .DEPTH(INSTR_MEM_DEPTH),
      .WIDTH(INSTR_MEM_WIDTH),
      .INIT_FILE(ICCM_INIT_FILE)
  ) iccm_inst (
      .clk       (clk),
      .rst_n     (rst_n),
      .raddr     (instr_mem_addr),
      .rtag_in   (instr_mem_tag_out),
      .rvalid_in (instr_mem_addr_valid),
      .rdata     (instr_mem_rdata),
      .rtag_out  (instr_mem_tag_in),
      .rvalid_out(instr_mem_rdata_valid)
  );

  /* Instruction Fetch Unit */
  ifu ifu_inst (
      .clk                  (clk),
      .rst_n                (rst_n),
      .reset_vector         (reset_vector),
      .instr_mem_addr       (instr_mem_addr),
      .instr_mem_addr_valid (instr_mem_addr_valid),
      .instr_mem_rdata      (instr_mem_rdata),
      .instr_mem_rdata_valid(instr_mem_rdata_valid),
      .instr_mem_tag_out    (instr_mem_tag_out),
      .instr_mem_tag_in     (instr_mem_tag_in),
      .instr                (instr),
      .instr_valid          (instr_valid),
      .instr_tag            (instr_tag),
      .pipe_stall           (pipe_stall)
  );

  /* Instruction Decode Unit - Stage 0 */
  idu0 idu0_inst (
      .clk        (clk),
      .rst_n      (rst_n),
      .instr      (instr),
      .instr_valid(instr_valid),
      .instr_tag  (instr_tag),
      .pipe_stall (pipe_stall),
      .idu0_out   (idu0_out)
  );

  /* Instruction Decode Unit - Stage 1 */
  idu1 idu1_inst (
      .clk            (clk),
      .rst_n          (rst_n),
      .idu0_out       (idu0_out),
      .idu1_out       (idu1_out),
      .exu_wb_data    (exu_wb_data),
      .exu_wb_rd_addr (exu_wb_rd_addr),
      .exu_wb_rd_wr_en(exu_wb_rd_wr_en),
      .exu_mul_busy   (exu_mul_busy),
      .exu_div_busy   (exu_div_busy),
      .exu_lsu_busy   (exu_lsu_busy),
      .exu_lsu_stall  (exu_lsu_stall),
      .pipe_stall     (pipe_stall)
  );

  /* Execute Unit */
  exu exu_inst (
      .clk            (clk),
      .rst_n          (rst_n),
      .idu1_out       (idu1_out),
      /* ONLY FOR DEBUG */
      .instr_tag_out  (exu_instr_tag_out),
      .instr_out      (exu_instr_out),
      .exu_wb_data    (exu_wb_data),
      .exu_wb_rd_addr (exu_wb_rd_addr),
      .exu_wb_rd_wr_en(exu_wb_rd_wr_en),
      .exu_mul_busy   (exu_mul_busy),
      .exu_div_busy   (exu_div_busy),
      .exu_lsu_busy   (exu_lsu_busy),
      .exu_lsu_stall  (exu_lsu_stall),
      .dccm_raddr     (dccm_raddr),
      .dccm_rvalid_in (dccm_rvalid_in),
      .dccm_rdata     (dccm_rdata),
      .dccm_rvalid_out(dccm_rvalid_out),
      .dccm_waddr     (dccm_waddr),
      .dccm_wen       (dccm_wen),
      .dccm_wdata     (dccm_wdata)
  );

  dccm #(
      .DEPTH    (DATA_MEM_DEPTH),
      .WIDTH    (DATA_MEM_WIDTH),
      .INIT_FILE(DCCM_INIT_FILE)
  ) dccm_inst (
      .clk       (clk),
      .rst_n     (rst_n),
      .raddr     ({dccm_raddr[DATA_MEM_ADDR_WIDTH-3:2], 2'b00}),
      .rvalid_in (dccm_rvalid_in),
      .rdata     (dccm_rdata),
      .rvalid_out(dccm_rvalid_out),
      .waddr     ({dccm_waddr[DATA_MEM_ADDR_WIDTH-3:2], 2'b00}),
      .wen       (dccm_wen),
      .wdata     (dccm_wdata)
  );

endmodule
