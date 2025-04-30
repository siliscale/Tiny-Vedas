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
`timescale 1ns / 1ps

`ifndef GLOBAL_SVH
`include "global.svh"
`endif

module core_top_tb;

  localparam string ICCM_INIT_FILE = `ICCM_INIT_FILE;
  localparam string DCCM_INIT_FILE = `DCCM_INIT_FILE;

  logic            clk = 0;
  logic            rst_n;
  logic [XLEN-1:0] reset_vector = `RESET_VECTOR;

  logic [    31:0] cycle_count = 0;

  int              fd;

  /* DUT Instantiation */
  core_top #(
      .ICCM_INIT_FILE(ICCM_INIT_FILE),
      .DCCM_INIT_FILE(DCCM_INIT_FILE)
  ) core_top_i (
      .*
  );

  always #5 clk = ~clk;  // 100 MHz clock

  initial begin
    /* Create a log file in the current directory */
    $timeformat(-9, 3, " ns", 10);
    fd = $fopen("rtl.log", "w");
    rst_n = 0;
    for (int i = 0; i < 10; i++) begin
      @(negedge clk);
    end
    rst_n = 1;
  end

  /* Finish Sequence Detector */
  logic finish_seq_detected;
  always_ff @(posedge clk) begin
    if (core_top_i.dccm_wen & core_top_i.dccm_waddr == 32'h10000000) begin
      finish_seq_detected <= 1;
    end
  end


  logic [31:0] cycle_count_last_retired;
  always_ff @(posedge clk) begin
    if (finish_seq_detected) begin
      $finish;
    end
    if (cycle_count_last_retired > 1000) begin
      $fdisplay(fd, "Nothing retired in 1000 cycles... Aborting");
      $finish;
    end
  end

  /* Cycle counter */
  always_ff @(posedge clk) begin
    if (rst_n) begin
      cycle_count <= cycle_count + 1;
      cycle_count_last_retired <= cycle_count + 1;
    end
    if (core_top_i.exu_wb_rd_wr_en | (core_top_i.exu_inst.lsu_inst.dc2_legal & core_top_i.exu_inst.lsu_inst.dc2_store) | (core_top_i.exu_inst.lsu_inst.dc3_legal & core_top_i.exu_inst.lsu_inst.dc3_store)) begin
      cycle_count_last_retired <= 'b0;
    end
  end

  /* Use the monitor to log the log file */
  always_ff @(posedge clk) begin
    /* Log everytime we touch the state of our core: Write to the register file, change the PC and store to memory */
    if (core_top_i.exu_wb_rd_wr_en & ~core_top_i.ifu_inst.pc_load) begin  /* Hierarchical naming */
      $fdisplay(fd, "%5d;0x%H;0x%H;x%0D=0x%H", cycle_count, core_top_i.exu_instr_tag_out,
                core_top_i.exu_instr_out, core_top_i.exu_wb_rd_addr, core_top_i.exu_wb_data);
    end
    if (core_top_i.exu_wb_rd_wr_en & core_top_i.ifu_inst.pc_load) begin  /* JAL/JALR */
      $fdisplay(fd, "%5d;0x%H;0x%H;x%0D=0x%H;pc=0x%H", cycle_count, core_top_i.exu_instr_tag_out,
                core_top_i.exu_instr_out, core_top_i.exu_wb_rd_addr, core_top_i.exu_wb_data,
                core_top_i.ifu_inst.pc_exu);
    end

    if (~core_top_i.exu_inst.alu_wb_rd_wr_en & core_top_i.ifu_inst.pc_load) begin  /* BEQ/BNE/BGE/BLT/BLTU/BGEU taken */
      $fdisplay(fd, "%5d;0x%H;0x%H;taken=true;pc=0x%H", cycle_count,
                core_top_i.exu_inst.alu_instr_tag_out, core_top_i.exu_inst.alu_instr_out,
                core_top_i.ifu_inst.pc_exu);
    end

    if (core_top_i.exu_inst.alu_inst.alu_ctrl.condbr & ~core_top_i.exu_inst.alu_inst.brn_taken) begin  /* BEQ/BNE/BGE/BLT/BLTU/BGEU not taken */
      $fdisplay(fd, "%5d;0x%H;0x%H;taken=false", cycle_count,
                core_top_i.exu_inst.alu_inst.alu_ctrl.instr_tag,
                core_top_i.exu_inst.alu_inst.alu_ctrl.instr);
    end

    if (core_top_i.exu_inst.lsu_inst.dc2_legal & core_top_i.exu_inst.lsu_inst.dc2_store) begin
      $fdisplay(
          fd, "%5d;0x%H;0x%H;mem[0x%8H]=0x%H", cycle_count,
          core_top_i.exu_inst.lsu_inst.dc2_lsu_instr_tag_out,
          core_top_i.exu_inst.lsu_inst.dc2_lsu_instr_out,
          core_top_i.exu_inst.lsu_inst.dc2_computed_addr,
          core_top_i.exu_inst.lsu_inst.dc2_store_buffer[XLEN-1:0] & core_top_i.exu_inst.lsu_inst.dc2_store_mask_base[XLEN-1:0]);
    end

    if (core_top_i.exu_inst.lsu_inst.dc3_legal & core_top_i.exu_inst.lsu_inst.dc3_store & core_top_i.exu_inst.lsu_inst.dc3_unaligned_addr) begin
      $fdisplay(
          fd, "%5d;0x%H;0x%H;mem[0x%8H]=0x%H", cycle_count,
          core_top_i.exu_inst.lsu_inst.dc3_lsu_instr_tag_out,
          core_top_i.exu_inst.lsu_inst.dc3_lsu_instr_out,
          core_top_i.exu_inst.lsu_inst.dc3_computed_addr,
          core_top_i.exu_inst.lsu_inst.dc3_store_buffer[XLEN-1:0] & core_top_i.exu_inst.lsu_inst.dc3_wb_data_mask[XLEN-1:0]);
    end
  end


endmodule
