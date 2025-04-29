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

module alu_tb;
  enum logic [3:0] {
    ALU_ADD,   /* Encoded as 0000 */
    ALU_SUB,   /* Encoded as 0001 */
    ALU_AND,   /* Encoded as 0010 */
    ALU_OR,    /* Encoded as 0011 */
    ALU_XOR,   /* Encoded as 0100 */
    ALU_SLL,   /* Encoded as 0101 */
    ALU_SRL,   /* Encoded as 0110 */
    ALU_SRA,   /* Encoded as 0111 */
    ALU_SLT,   /* Encoded as 1000 */
    ALU_SLTU,  /* Encoded as 1001 */
    ALU_XNOR   /* Encoded as 1010 */
  } alu_op;
  logic [31:0] src1, src2, result;

  alu alu_inst (
      .src1  (src1),
      .src2  (src2),
      .alu_op(alu_op),
      .result(result)
  );

  initial begin
    src1   = $random;
    src2   = $random;
    alu_op = ALU_ADD;
    #10;
    $display("src1 = %d, src2 = %d, alu_op = %d, result = %d", src1, src2, alu_op, result);
    src1   = $random;
    src2   = $random;
    alu_op = ALU_SUB;
    #10;
    $display("src1 = %d, src2 = %d, alu_op = %d, result = %d", src1, src2, alu_op, result);
    src1   = $random;
    src2   = $random;
    alu_op = ALU_AND;
    #10;
    $display("src1 = %d, src2 = %d, alu_op = %d, result = %d", src1, src2, alu_op, result);
    src1   = $random;
    src2   = $random;
    alu_op = ALU_OR;
    #10;
    $display("src1 = %d, src2 = %d, alu_op = %d, result = %d", src1, src2, alu_op, result);
    src1   = $random;
    src2   = $random;
    alu_op = ALU_XOR;
    #10;
    $display("src1 = %d, src2 = %d, alu_op = %d, result = %d", src1, src2, alu_op, result);
    src1   = $random;
    src2   = $random;
    alu_op = ALU_SLL;
    #10;
    $display("src1 = %d, src2 = %d, alu_op = %d, result = %d", src1, src2, alu_op, result);
    src1 = $random;
    src2 = $random;
    $finish;
  end
endmodule
