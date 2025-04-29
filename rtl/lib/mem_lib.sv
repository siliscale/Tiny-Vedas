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

/* ************** Memory Library ************** */

/**** Instruction Closely Coupled Memory ************** */

/* Only read port, we assume initialized by TB */
module iccm #(
    parameter int DEPTH = 1024,
    parameter int WIDTH = 32,
    parameter string INIT_FILE = ""
) (

    input logic clk,
    input logic rst_n,

    /* Read Port */
    input  logic [($clog2(DEPTH*WIDTH/8))-1:0] raddr,      /* Byte address */
    input  logic                               rvalid_in,
    input  logic [INSTR_MEM_TAG_WIDTH-1:0]     rtag_in,
    output logic [                  WIDTH-1:0] rdata,
    output logic                               rvalid_out,
    output logic [INSTR_MEM_TAG_WIDTH-1:0]     rtag_out
);

  logic [WIDTH-1:0] mem[DEPTH];

  logic [$clog2(DEPTH)-1:0] line_idx;

  logic [WIDTH*2-1:0] line_data, line_data_shift;

  assign line_idx = raddr[$clog2(DEPTH*WIDTH/8)-1:$clog2(WIDTH/8)];

  /* Initialize memory */
  initial begin
    $readmemh(INIT_FILE, mem);
  end

  /*

  | B3 | B2 | B1 | B0 | 0x000
  | B7 | B6 | B5 | B4 | 0x004

  32 bits from address 0x002

  Output should be | B5 | B4 | B3 | B2 |

  */


  /* Read Port */
  always_ff @(posedge clk) begin
    if (!rst_n) begin
      rvalid_out <= 0;
      line_data  <= 0;
      rtag_out   <= 0;
    end else begin
      if (rvalid_in) begin
        rvalid_out <= 1;
        line_data  <= {mem[line_idx+1], mem[line_idx]};
        rtag_out   <= rtag_in;
      end
    end
  end

  assign line_data_shift = line_data >> (raddr[$clog2(WIDTH/8)-1:0]);
  assign rdata = line_data_shift[WIDTH-1:0];

endmodule

/**** Data Closely Coupled Memory ************** */

/* Only read and write ports */
module dccm #(
    parameter int DEPTH = 1024,
    parameter int WIDTH = 32,
    parameter string INIT_FILE = ""
) (
    input logic clk,
    input logic rst_n,

    /* Read Port */
    input  logic [$clog2(DEPTH)-1:0] raddr,
    input  logic                     rvalid_in,
    output logic [        WIDTH-1:0] rdata,
    output logic                     rvalid_out,

    /* Write Port */
    input logic [$clog2(DEPTH)-1:0] waddr,
    input logic                     wen,
    input logic [        WIDTH-1:0] wdata
);

  logic [WIDTH-1:0] mem[DEPTH];

  /* Initialize memory */
  initial begin
    $readmemh(INIT_FILE, mem);
  end

  /* Read Port */
  always_ff @(posedge clk) begin
    if (!rst_n) begin
      rvalid_out <= 0;
      rdata <= 0;
    end else begin
      rvalid_out <= rvalid_in;
      rdata <= mem[raddr];
    end
  end

  /* Write Port */
  always_ff @(posedge clk) begin
    if (wen) begin
      mem[waddr] <= wdata;
    end
  end
endmodule
