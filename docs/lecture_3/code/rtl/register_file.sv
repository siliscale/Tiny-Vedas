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

module register_file #(  /* Separate Read and Write Ports, single port */
    parameter integer WIDTH = 32,
    integer N = 4
) (
    input  logic                 clk,
    input  logic                 rstn,
    input  logic                 read_en,
    input  logic                 write_en,
    input  logic [$clog2(N)-1:0] read_addr,
    input  logic [$clog2(N)-1:0] write_addr,
    input  logic [    WIDTH-1:0] data_in,
    output logic [    WIDTH-1:0] data_out
);

  logic [WIDTH-1:0] registers[N];

  always_ff @(posedge clk) begin
    if (!rstn) begin
      for (int i = 0; i < N; i++) begin
        registers[i] <= 0;
      end
    end else if (write_en) begin
      registers[write_addr] <= data_in;
    end
  end

  assign data_out = read_en ? registers[read_addr] : 0;
endmodule
;
