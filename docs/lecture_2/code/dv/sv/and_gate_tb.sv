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

module and_gate_tb;

  logic x, y, z;

  and_gate and_gate_inst (
	  .x(x),
	  .y(y),
	  .z(z)
  );

  initial begin
    x = 1'b0;
    y = 1'b0;
    #10;
    $display("x = %b, y = %b, z = %b", x, y, z);
    x = 1'b0;
    y = 1'b1;
    #10;
    $display("x = %b, y = %b, z = %b", x, y, z);
    x = 1'b1;
    y = 1'b0;
    #10;
    $display("x = %b, y = %b, z = %b", x, y, z);
    x = 1'b1;
    y = 1'b1;
    #10;
    $display("x = %b, y = %b, z = %b", x, y, z);
    #10;
    $finish;
  end

endmodule
