/*
MIT License

Copyright (c) 2025 Siliscale Consulting LLC

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

module half_adder_tb;

  logic x, y, sum, cout;

  half_adder half_adder_inst (
      x,
      y,
      sum,
      cout
  );

  initial begin
    x = 0;
    y = 0;
    #10;
    $display("x = %b, y = %b, sum = %b, cout = %b", x, y, sum, cout);
    x = 0;
    y = 1;
    #10;
    $display("x = %b, y = %b, sum = %b, cout = %b", x, y, sum, cout);
    x = 1;
    y = 0;
    #10;
    $display("x = %b, y = %b, sum = %b, cout = %b", x, y, sum, cout);
    x = 1;
    y = 1;
    #10;
    $display("x = %b, y = %b, sum = %b, cout = %b", x, y, sum, cout);
    #10;
    $finish;
  end
endmodule
