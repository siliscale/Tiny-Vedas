///////////////////////////////////////////////////////////////////////////////
//     Copyright (c) 2025 Siliscale Consulting, LLC
// 
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
// 
//        http://www.apache.org/licenses/LICENSE-2.0
// 
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.
///////////////////////////////////////////////////////////////////////////////
//           _____          
//          /\    \         
//         /::\    \        
//        /::::\    \       
//       /::::::\    \      
//      /:::/\:::\    \     
//     /:::/__\:::\    \            Vendor      : Siliscale
//     \:::\   \:::\    \           Version     : 2025.1
//   ___\:::\   \:::\    \          Description : Tiny Vedas - Memory Library
//  /\   \:::\   \:::\    \ 
// /::\   \:::\   \:::\____\
// \:::\   \:::\   \::/    /
//  \:::\   \:::\   \/____/ 
//   \:::\   \:::\    \     
//    \:::\   \:::\____\    
//     \:::\  /:::/    /    
//      \:::\/:::/    /     
//       \::::::/    /      
//        \::::/    /       
//         \::/    /        
//          \/____/         
///////////////////////////////////////////////////////////////////////////////

/* ************** Memory Library ************** */

/**** Instruction Closely Coupled Memory ************** */

/* Only read port, we assume initialized by TB */
module iccm #(
    parameter int DEPTH = 1024,
    parameter int WIDTH = 32,
    parameter string INIT_FILE = ""
) (

    input logic clk,
    input logic rstn,

    /* Read Port */
    input  logic [($clog2(DEPTH*WIDTH/8))-1:0] raddr,       /* Byte address */
    input  logic                               rvalid_in,
    input  logic [    INSTR_MEM_TAG_WIDTH-1:0] rtag_in,
    output logic [                  WIDTH-1:0] rdata,
    output logic                               rvalid_out,
    output logic [    INSTR_MEM_TAG_WIDTH-1:0] rtag_out
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
    if (!rstn) begin
      rvalid_out <= 0;
      line_data  <= 0;
      rtag_out   <= 0;
    end else begin
      rvalid_out <= rvalid_in;
      line_data  <= rvalid_in ? {mem[line_idx+1], mem[line_idx]} : 0;
      rtag_out   <= rvalid_in ? rtag_in : 0;
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
    input logic rstn,

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
    if (!rstn) begin
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
