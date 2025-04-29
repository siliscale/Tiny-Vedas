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

module flops_tb;

  logic clk = 0;
  logic rst_n = 0;
  logic en = 0;
  logic d = 0;
  logic q, q_rst, q_rst_en;

  d_ff d_ff_i (
      .clk  (clk),
      .d    (d),
      .q    (q)
  );

  d_ff_sync_reset d_ff_sync_reset_i (
      .clk  (clk),
      .rst_n(rst_n),
      .d    (d),
      .q    (q_rst)
  );

  d_ff_sync_reset_en d_ff_sync_reset_en_i (
      .clk  (clk),
      .rst_n(rst_n),
      .en   (en),
      .d    (d),
      .q    (q_rst_en)
  );

  always #5ns clk <= ~clk;  /* 100MHz clock, 50% duty cycle */

  initial begin
    rst_n = 0;
    @(posedge clk);
    rst_n = 1;
    @(negedge clk);
    d  = 1;
    en = 1;
    @(posedge clk);
    $display("rst_n = %d, d = %d, en = %d, q = %d, q_rst = %d, q_rst_en = %d", rst_n, d, en, q,
             q_rst, q_rst_en);
    @(negedge clk);
    d  = 0;
    en = 0;
    @(posedge clk);
    $display("rst_n = %d, d = %d, en = %d, q = %d, q_rst = %d, q_rst_en = %d", rst_n, d, en, q,
             q_rst, q_rst_en);
    @(negedge clk);
    d  = 1;
    en = 0;
    @(posedge clk);
    $display("rst_n = %d, d = %d, en = %d, q = %d, q_rst = %d, q_rst_en = %d", rst_n, d, en, q,
             q_rst, q_rst_en);
    @(negedge clk);
    d  = 0;
    en = 0;
    @(posedge clk);
    $display("rst_n = %d, d = %d, en = %d, q = %d, q_rst = %d, q_rst_en = %d", rst_n, d, en, q,
             q_rst, q_rst_en);
    @(negedge clk);
    d  = 1;
    en = 0;
    @(posedge clk);
    $display("rst_n = %d, d = %d, en = %d, q = %d, q_rst = %d, q_rst_en = %d", rst_n, d, en, q,
             q_rst, q_rst_en);
    @(negedge clk);
    d  = 0;
    en = 0;
    @(posedge clk);
    $display("rst_n = %d, d = %d, en = %d, q = %d, q_rst = %d, q_rst_en = %d", rst_n, d, en, q,
             q_rst, q_rst_en);
    @(negedge clk);
    d  = 1;
    en = 0;
    @(posedge clk);
    $display("rst_n = %d, d = %d, en = %d, q = %d, q_rst = %d, q_rst_en = %d", rst_n, d, en, q,
             q_rst, q_rst_en);
    $finish;
  end


endmodule

