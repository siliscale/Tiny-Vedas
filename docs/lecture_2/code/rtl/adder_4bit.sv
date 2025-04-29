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

module adder_4bit (
    input  logic [3:0] x,
    input  logic [3:0] y,
    output logic [4:0] z
);

  logic [3:0] sum;
  logic [3:0] carry;

  half_adder ha0 (
      x[0],
      y[0],
      sum[0],
      carry[0]
  );
  full_adder fa1 (
      x[1],
      y[1],
      carry[0],
      sum[1],
      carry[1]
  );
  full_adder fa2 (
      x[2],
      y[2],
      carry[1],
      sum[2],
      carry[2]
  );
  full_adder fa3 (
      x[3],
      y[3],
      carry[2],
      sum[3],
      carry[3]
  );

  assign z = {carry[3], sum};

endmodule;
