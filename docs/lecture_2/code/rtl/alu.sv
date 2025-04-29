
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

module alu (
    input  logic [31:0] src1,
    input  logic [31:0] src2,
    input  logic [ 3:0] alu_op,
    output logic [31:0] result
);

  always_comb begin
    casez (alu_op)
      4'b0000: result = $signed(src1) + $signed(src2);
      4'b0001: result = $signed(src1) - $signed(src2);
      4'b0010: result = src1 & src2;
      4'b0011: result = src1 | src2;
      4'b0100: result = src1 ^ src2;
      4'b0101: result = src1 << src2;
      4'b0110: result = src1 >> src2;
      4'b0111: result = $signed(src1) >>> src2;
      4'b1000: result = {31'b0, $signed(src1) < $signed(src2)};
      4'b1001: result = {31'b0, src1 < src2};
      4'b1010: result = ~(src1 ^ src2);
      default: result = 32'b0;
    endcase
  end

endmodule
;
