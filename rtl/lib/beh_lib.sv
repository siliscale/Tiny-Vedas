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

/* ************** Behavioral Library ************** */

/* ***** D Flip-Flop ***** */
module dff #(
    parameter int WIDTH = 1
) (
    input logic [WIDTH-1:0] din,
    input logic             clk,

    output logic [WIDTH-1:0] dout
);

  always_ff @(posedge clk) begin
    dout[WIDTH-1:0] <= din[WIDTH-1:0];
  end

endmodule

/* ***** D Flip-Flop w/ Reset ***** */
module dff_rst #(
    parameter int WIDTH = 1,
    parameter logic [WIDTH-1:0] RESET_VAL = 0
) (
    input logic [WIDTH-1:0] din,
    input logic             clk,
    input logic             rst_n,

    output logic [WIDTH-1:0] dout
);

  always_ff @(posedge clk) begin
    if (!rst_n) dout[WIDTH-1:0] <= RESET_VAL[WIDTH-1:0];
    else dout[WIDTH-1:0] <= din[WIDTH-1:0];
  end

endmodule

/* ***** D Flip-Flop w/ Reset & Reset Vector ***** */
module dff_rst_vector #(
    parameter int WIDTH = 1,
    parameter logic [WIDTH-1:0] RESET_VAL = 0
) (
    input  logic [WIDTH-1:0] din,
    input  logic             clk,
    input  logic             rst_n,
    input  logic [WIDTH-1:0] reset_val,
    output logic [WIDTH-1:0] dout
);

  always_ff @(posedge clk) begin
    if (!rst_n) dout[WIDTH-1:0] <= reset_val[WIDTH-1:0];
    else dout[WIDTH-1:0] <= din[WIDTH-1:0];
  end

endmodule

/* ***** D Flip-Flop w/ Reset & Enable ***** */
module dff_rst_en #(
    parameter int WIDTH = 1,
    parameter logic [WIDTH-1:0] RESET_VAL = 0
) (
    input logic [WIDTH-1:0] din,
    input logic             clk,
    input logic             rst_n,
    input logic             en,

    output logic [WIDTH-1:0] dout
);

  dff_rst #(WIDTH, RESET_VAL) dff_rst_inst (
      .din((en) ? din[WIDTH-1:0] : dout[WIDTH-1:0]),
      .*
  );

endmodule

/* ***** D Flip-Flop w/ Reset & Enable & Reset Vector ***** */
module dff_rst_en_vector #(
    parameter int WIDTH = 1,
    parameter logic [WIDTH-1:0] RESET_VAL = 0
) (
    input logic [WIDTH-1:0] din,
    input logic             clk,
    input logic             rst_n,
    input logic [WIDTH-1:0] reset_val,
    input logic             en,

    output logic [WIDTH-1:0] dout
);

  dff_rst_vector #(WIDTH, RESET_VAL) dff_rst_inst (
      .din((en) ? din[WIDTH-1:0] : dout[WIDTH-1:0]),
      .*
  );

endmodule

/* ***** Program Counter ***** */
module pc #(
    parameter int PC_WIDTH = 32,
    parameter logic [PC_WIDTH-1:0] INC_AMOUNT = 4
) (
    input logic                clk,
    input logic                rst_n,
    input logic [PC_WIDTH-1:0] reset_vector,

    /* Control Signals */
    input logic load,
    input logic inc,
    input logic stall,

    /* Data Signals */
    input  logic [PC_WIDTH-1:0] pc_in,
    output logic [PC_WIDTH-1:0] pc_out,
    output logic                pc_out_valid
);

  logic [PC_WIDTH-1:0] pc_d, pc_q;
  logic update_pc;
  dff_rst_en_vector #(PC_WIDTH) pc_dff (
      .clk      (clk),
      .rst_n    (rst_n),
      .reset_val(reset_vector[PC_WIDTH-1:0]),
      .en       (update_pc),
      .din      (pc_d[PC_WIDTH-1:0]),
      .dout     (pc_q[PC_WIDTH-1:0])
  );

  always_comb begin
    unique casez ({
      load, inc, stall
    })
      3'b1?0: begin  // Load
        update_pc = 1'b1;
        pc_d = pc_in;
        pc_out_valid = 1'b1;
      end
      3'b??1: begin  // Stall
        update_pc = 1'b0;
        pc_d = 'b0;
        pc_out_valid = 1'b0;
      end
      3'b010: begin  // Inc
        update_pc = 1'b1;
        pc_d = pc_q + INC_AMOUNT;
        pc_out_valid = 1'b1;
      end
      default: begin
        pc_d = 'b0;
        update_pc = 1'b0;
        pc_out_valid = 1'b0;
      end
    endcase
  end

  assign pc_out[PC_WIDTH-1:0] = pc_q[PC_WIDTH-1:0];

endmodule

module twoscomp #(
    parameter WIDTH = 32
) (
    input logic [WIDTH-1:0] din,

    output logic [WIDTH-1:0] dout
);

  logic [WIDTH-1:1] dout_temp;  // holding for all other bits except for the lsb. LSB is always din

  genvar i;

  for (i = 1; i < WIDTH; i++) begin : flip_after_first_one
    assign dout_temp[i] = (|din[i-1:0]) ? ~din[i] : din[i];
  end : flip_after_first_one

  assign dout[WIDTH-1:0] = {dout_temp[WIDTH-1:1], din[0]};

endmodule  // 2'scomp
