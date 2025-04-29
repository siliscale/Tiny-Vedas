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

module register_file_multiport #(  /* Multi-Port */
    parameter integer WIDTH = 32,
    integer N = 4,
    integer N_READ_PORTS = 1,
    integer N_WRITE_PORTS = 1
) (
    input  logic                     clk,
    input  logic [ N_READ_PORTS-1:0] read_en   [ N_READ_PORTS],
    input  logic [N_WRITE_PORTS-1:0] write_en  [N_WRITE_PORTS],
    input  logic [    $clog2(N)-1:0] read_addr [ N_READ_PORTS],
    input  logic [    $clog2(N)-1:0] write_addr[N_WRITE_PORTS],
    input  logic [        WIDTH-1:0] data_in   [N_WRITE_PORTS],
    output logic [        WIDTH-1:0] data_out  [ N_READ_PORTS]
);

  logic [WIDTH-1:0] registers[N];

  always_ff @(posedge clk) begin
    if (!rst_n) begin
      for (int i = 0; i < N; i++) begin
        registers[i] <= 0;
      end
      for (int i = 0; i < N_WRITE_PORTS; i++) begin
        if (write_en[i]) begin
          registers[write_addr[i]] <= data_in[i];
        end
      end
    end
  end

  always_comb begin
    for (int i = 0; i < N_READ_PORTS; i++) begin
      if (read_en[i]) begin
        data_out[i] = registers[read_addr[i]];
      end
    end
  end

endmodule
;
