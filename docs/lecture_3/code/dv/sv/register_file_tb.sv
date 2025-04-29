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

module register_file_tb;

  localparam integer WIDTH = 32;
  localparam integer N = 4;

  logic clk = 0;
  logic rst_n = 0;
  logic read_en = 0;
  logic write_en = 0;
  logic [$clog2(N)-1:0] read_addr = 0;
  logic [$clog2(N)-1:0] write_addr = 0;
  logic [WIDTH-1:0] data_in = 0;
  logic [WIDTH-1:0] data_out;

  register_file #(
      .WIDTH(WIDTH),
      .N(N)
  ) register_file_i (
      .clk       (clk),
      .rst_n     (rst_n),
      .read_en   (read_en),
      .write_en  (write_en),
      .read_addr (read_addr),
      .write_addr(write_addr),
      .data_in   (data_in),
      .data_out  (data_out)
  );

  always #5ns clk <= ~clk;  /* 100MHz clock, 50% duty cycle */

  initial begin
    rst_n = 0;

    /* Write to register 0 */
    @(posedge clk);
    rst_n = 1;
    @(negedge clk);
    write_en = 1;
    write_addr = 0;
    data_in = $urandom;
    @(posedge clk);
    $display("rst_n = %d, write_en = %d, write_addr = %d, data_in = %d, data_out = %d", rst_n,
             write_en, write_addr, data_in, data_out);
    @(negedge clk);
    write_en = 0;
    @(posedge clk);

    /* Write to register 1 */
    @(negedge clk);
    write_en = 1;
    write_addr = 1;
    data_in = $urandom;
    @(posedge clk);
    $display("rst_n = %d, write_en = %d, write_addr = %d, data_in = %d, data_out = %d", rst_n,
             write_en, write_addr, data_in, data_out);

    @(negedge clk);
    write_en = 0;
    @(posedge clk);

    /* Read from register 0 */
    @(negedge clk);
    read_en   = 1;
    read_addr = 0;
    @(posedge clk);
    $display("rst_n = %d, read_en = %d, read_addr = %d, data_out = %d", rst_n, read_en, read_addr,
             data_out);

    read_en = 0;

    /* Read from register 1 */
    @(negedge clk);
    read_en   = 1;
    read_addr = 1;
    @(posedge clk);
    $display("rst_n = %d, read_en = %d, read_addr = %d, data_out = %d", rst_n, read_en, read_addr,
             data_out);
    @(negedge clk);
    read_en = 0;

    $finish;
  end

endmodule
