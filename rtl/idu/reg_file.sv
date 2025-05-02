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

`ifndef GLOBAL_SVH
`include "global.svh"
`endif

module reg_file #(
    parameter logic [XLEN-1:0] STACK_POINTER_INIT_VALUE = 32'h80000000
) (
    input logic clk,
    input logic rst_n,

    /* Read Ports */
    input logic [4:0] rs1_addr,
    input logic [4:0] rs2_addr,
    input logic rs1_rd_en,
    input logic rs2_rd_en,
    output logic [XLEN-1:0] rs1_data,
    output logic [XLEN-1:0] rs2_data,

    /* Write Ports */
    input logic [4:0] rd_addr,
    input logic [XLEN-1:0] rd_data,
    input logic rd_wr_en
);

  logic [XLEN-1:0] reg_file[32];

  genvar i;

  generate
    for (i = 0; i < 32; i++) begin : g_reg_file
      if (i == 0) begin : g_zero_reg
        assign reg_file[i] = 0;
      end else begin : g_reg_file_gen
        dff_rst_en #(
            .WIDTH(XLEN),
            .RESET_VAL((i == 2) ? STACK_POINTER_INIT_VALUE : 0)
        ) reg_i (
            .clk  (clk),
            .rst_n(rst_n),
            .en   (rd_wr_en & (rd_addr == i)),
            .din  (rd_data),
            .dout (reg_file[i])
        );
      end
    end
  endgenerate

  assign rs1_data = (rs1_rd_en) ? reg_file[rs1_addr] : {XLEN{1'b0}};
  assign rs2_data = (rs2_rd_en) ? reg_file[rs2_addr] : {XLEN{1'b0}};

endmodule
