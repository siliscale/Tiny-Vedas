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

`timescale 1ns / 1ns

module bitwise_ops_tb;

  logic [3:0] x, y;
  logic [3:0] z_and, z_or, z_xor;

  bitwise_ops bitwise_ops_inst (
      .x    (x),
      .y    (y),
      .z_and(z_and),
      .z_or (z_or),
      .z_xor(z_xor)
  );

  initial begin
    x = 4'h0;
    y = 4'h0;
    #10;
    $display(
        "x = %b, y = %b, z_and = %b, z_or = %b, z_xor = %b",
        x, y, z_and, z_or, z_xor);
    x = 4'h1;
    y = 4'h1;
    #10;
    $display(
        "x = %b, y = %b, z_and = %b, z_or = %b, z_xor = %b",
        x, y, z_and, z_or, z_xor);
    x = 4'h2;
    y = 4'h2;
    #10;
    $display(
        "x = %b, y = %b, z_and = %b, z_or = %b, z_xor = %b",
        x, y, z_and, z_or, z_xor);
    x = 4'h3;
    y = 4'h3;
    #10;
    $display(
        "x = %b, y = %b, z_and = %b, z_or = %b, z_xor = %b",
        x, y, z_and, z_or, z_xor);
    x = 4'h4;
    y = 4'h4;
    #10;
    $display(
        "x = %b, y = %b, z_and = %b, z_or = %b, z_xor = %b",
        x, y, z_and, z_or, z_xor);
    x = 4'h5;
    y = 4'h5;
    #10;
    $display(
        "x = %b, y = %b, z_and = %b, z_or = %b, z_xor = %b",
        x, y, z_and, z_or, z_xor);
    x = 4'h6;
    y = 4'h6;
    #10;
    $display(
        "x = %b, y = %b, z_and = %b, z_or = %b, z_xor = %b",
        x, y, z_and, z_or, z_xor);
    x = 4'h7;
    y = 4'h7;
    #10;
    $display(
        "x = %b, y = %b, z_and = %b, z_or = %b, z_xor = %b",
        x, y, z_and, z_or, z_xor);
    x = 4'h8;
    y = 4'h8;
    #10;
    $display(
        "x = %b, y = %b, z_and = %b, z_or = %b, z_xor = %b",
        x, y, z_and, z_or, z_xor);
    #10;
    $finish;
  end
endmodule
