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

module ifu (
    /* Clock and Reset */
    input logic            clk,
    input logic            rst_n,
    input logic [XLEN-1:0] reset_vector,

    /* Instruction Memory Interface */
    output logic [INSTR_MEM_ADDR_WIDTH-1:0] instr_mem_addr,
    output logic                            instr_mem_addr_valid,
    output logic [                XLEN-1:0] instr_mem_tag_out,
    input  logic [     INSTR_MEM_WIDTH-1:0] instr_mem_rdata,
    input  logic                            instr_mem_rdata_valid,
    input  logic [ INSTR_MEM_TAG_WIDTH-1:0] instr_mem_tag_in,

    /* Control Signals */
    input  logic                 pipe_stall,
    output logic [INSTR_LEN-1:0] instr,
    output logic                 instr_valid,
    output logic [     XLEN-1:0] instr_tag
);

  logic [XLEN-1:0] pc_out;

  assign instr_mem_addr = pc_out[INSTR_MEM_ADDR_WIDTH-1:0];  /* Crop the PC since the instr_mem_addr
                                                                is narrower than the PC */
  assign instr_mem_tag_out = pc_out;

  /* Instantiate the Program Counter */
  pc pc_inst (
      .clk         (clk),
      .rst_n       (rst_n),
      .reset_vector(reset_vector),
      .load        (1'b0),                 /* To be changed later */
      .inc         (1'b1),          /* To be changed later */
      .stall       (pipe_stall),           /* To be changed later */
      .pc_in       (32'h00000000),         /* To be changed later */
      .pc_out      (pc_out),
      .pc_out_valid(instr_mem_addr_valid)
  );

  /* Generate the outputs */
  dff_rst_en #(INSTR_LEN + 1 + XLEN) instr_dff_rst_inst (
      .clk  (clk),
      .rst_n(rst_n),
      .din  ({instr_mem_rdata_valid, instr_mem_rdata, instr_mem_tag_in}),
      .dout ({instr_valid, instr, instr_tag}),
      .en   (~pipe_stall)
  );
endmodule
