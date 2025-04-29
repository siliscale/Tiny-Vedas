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

`ifndef GLOBAL_SVH
`define GLOBAL_SVH

localparam XLEN = 32;
localparam XLEN_BYTES = XLEN / 8;

localparam RESET_VECTOR = 32'h00000000;

localparam INSTR_LEN = 32;
localparam INSTR_LEN_BYTES = INSTR_LEN / 8;

localparam DATA_LEN = XLEN;
localparam DATA_LEN_BYTES = DATA_LEN / 8;

localparam INSTR_MEM_WIDTH = XLEN;
localparam INSTR_MEM_DEPTH = 1024;
localparam INSTR_MEM_ADDR_WIDTH = $clog2(INSTR_MEM_DEPTH * INSTR_MEM_WIDTH / 8);
localparam INSTR_MEM_TAG_WIDTH = XLEN;

localparam DATA_MEM_WIDTH = XLEN;
localparam DATA_MEM_DEPTH = 1024;
localparam DATA_MEM_ADDR_WIDTH = $clog2(DATA_MEM_DEPTH * DATA_MEM_WIDTH / 8);

localparam REG_FILE_DEPTH = 32;
localparam REG_FILE_ADDR_WIDTH = $clog2(REG_FILE_DEPTH);

`endif
