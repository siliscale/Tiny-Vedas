`timescale 1ns / 1ps

`ifndef GLOBAL_SVH
`include "global.svh"
`endif

`ifndef TYPES_SVH
`include "types.svh"
`endif

module lsu_tb;

  logic clk = 0;
  logic rstn = 0;

  /* LSU Control */
  idu1_out_t lsu_ctrl, lsu_ctrl_d;
  logic            lsu_busy;

  /* LSU WB Data */
  logic [XLEN-1:0] lsu_wb_data;
  logic [     4:0] lsu_wb_rd_addr;
  logic            lsu_wb_rd_wr_en;

  /* LSU DCCM Interface */
  logic [XLEN-1:0] lsu_dccm_raddr;
  logic            lsu_dccm_rvalid_in;
  logic [XLEN-1:0] lsu_dccm_rdata;
  logic            lsu_dccm_rvalid_out;
  logic [XLEN-1:0] lsu_dccm_waddr;
  logic            lsu_dccm_wen;
  logic [XLEN-1:0] lsu_dccm_wdata;

  always #5 clk = ~clk;  // 100 MHz clock

  lsu DUT (
      .clk                (clk),
      .rstn              (rstn),
      .lsu_ctrl           (lsu_ctrl),
      .lsu_busy           (lsu_busy),
      .lsu_wb_data        (lsu_wb_data),
      .lsu_wb_rd_addr     (lsu_wb_rd_addr),
      .lsu_wb_rd_wr_en    (lsu_wb_rd_wr_en),
      .lsu_dccm_raddr     (lsu_dccm_raddr),
      .lsu_dccm_rvalid_in (lsu_dccm_rvalid_in),
      .lsu_dccm_rdata     (lsu_dccm_rdata),
      .lsu_dccm_rvalid_out(lsu_dccm_rvalid_out),
      .lsu_dccm_waddr     (lsu_dccm_waddr),
      .lsu_dccm_wen       (lsu_dccm_wen),
      .lsu_dccm_wdata     (lsu_dccm_wdata)
  );

  always_ff @(posedge clk) begin
    lsu_ctrl <= lsu_ctrl_d;
  end

  initial begin
    $timeformat(-9, 3, " ns", 10);
    lsu_ctrl_d = 0;
    for (int i = 0; i < 10; i++) begin
      @(negedge clk);
    end
    rstn = 1;
    for (int i = 0; i < 10; i++) begin
      @(negedge clk);
    end
    /* Aligned Byte Load (byte loads are always aligned) */
    lsu_ctrl_d.rd_addr = 5;
    lsu_ctrl_d.by = 1;
    lsu_ctrl_d.load = 1;
    lsu_ctrl_d.legal = 1;
    lsu_ctrl_d.rs1_data = 32'h00000FF0;
    @(negedge clk);
    /* Aligned Halfword Load */
    lsu_ctrl_d.rd_addr = 3;
    lsu_ctrl_d.by = 0;
    lsu_ctrl_d.half = 1;
    lsu_ctrl_d.load = 1;
    lsu_ctrl_d.legal = 1;
    lsu_ctrl_d.rs1_data = 32'h00001FF0;
    @(negedge clk);
    /* Aligned Word Load */
    lsu_ctrl_d.rd_addr = 7;
    lsu_ctrl_d.half = 0;
    lsu_ctrl_d.word = 1;
    lsu_ctrl_d.load = 1;
    lsu_ctrl_d.legal = 1;
    lsu_ctrl_d.rs1_data = 32'h00002FF0;
    @(negedge clk);
    lsu_ctrl_d = 0;
    @(negedge clk);
    /* Aligned byte load, but at a base address =! 0 */
    lsu_ctrl_d.rd_addr = 5;
    lsu_ctrl_d.by = 1;
    lsu_ctrl_d.load = 1;
    lsu_ctrl_d.legal = 1;
    lsu_ctrl_d.rs1_data = 32'h00003FF1;
    @(negedge clk);
    /* Aligned halfword load, but at a base address =! 0 */
    lsu_ctrl_d = 0;
    lsu_ctrl_d.rd_addr = 3;
    lsu_ctrl_d.half = 1;
    lsu_ctrl_d.load = 1;
    lsu_ctrl_d.legal = 1;
    lsu_ctrl_d.rs1_data = 32'h00004F2;
    @(negedge clk);
    /* Unaligned halfword load */
    lsu_ctrl_d = 0;
    lsu_ctrl_d.rd_addr = 10;
    lsu_ctrl_d.half = 1;
    lsu_ctrl_d.load = 1;
    lsu_ctrl_d.legal = 1;
    lsu_ctrl_d.rs1_data = 32'h00005F3;
    @(negedge clk);
    lsu_ctrl_d = 0;
    @(negedge clk);
    /* Unaligned halfword load */
    lsu_ctrl_d = 0;
    lsu_ctrl_d.rd_addr = 12;
    lsu_ctrl_d.half = 1;
    lsu_ctrl_d.load = 1;
    lsu_ctrl_d.legal = 1;
    lsu_ctrl_d.rs1_data = 32'h000056F3;
    @(negedge clk);
    lsu_ctrl_d = 0;
    for (int i = 0; i < 100; i++) begin
      @(negedge clk);
    end
    $finish;
  end

  /* Memory Stub */
  always_ff @(posedge clk) begin
    lsu_dccm_rdata <= 0;
    lsu_dccm_rvalid_out <= 0;
    if (lsu_dccm_rvalid_in) begin
      lsu_dccm_rdata <= $urandom;
      lsu_dccm_rvalid_out <= 1;
    end
  end

endmodule
