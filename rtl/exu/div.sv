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
//   ___\:::\   \:::\    \          Description : Tiny Vedas - Divide Unit
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

`ifndef GLOBAL_SVH
`include "global.svh"
`endif

`ifndef TYPES_SVH
`include "types.svh"
`endif


module div (
    input logic clk,  // Top level clock
    input logic rstn, // Reset

    input logic dec_tlu_fast_div_disable,  // Disable small number optimization

    input idu1_out_t dp,  // valid, sign, rem

    input logic flush_lower,  // Flush pipeline


    output logic valid_ff_e1,   // Valid E1 stage
    output logic finish_early,  // Finish smallnum
    output logic finish,        // Finish smallnum or normal divide
    output logic div_stall,     // Divide is running

    output logic [    31:0] out,            // Result
    output logic [     4:0] out_addr,
    output logic            out_valid,
    output logic [XLEN-1:0] instr_tag_out,
    output logic [    31:0] instr_out
);


  logic run_in, run_state;
  logic [5:0] count_in, count;
  logic [32:0] m_ff;
  logic        qff_enable;
  logic        aff_enable;
  logic [32:0] q_in, q_ff;
  logic [32:0] a_in, a_ff;
  logic [32:0] m_eff;
  logic [32:0] a_shift;
  logic dividend_neg_ff, divisor_neg_ff;
  logic [31:0] dividend_comp;
  logic [31:0] dividend_eff;
  logic [31:0] q_ff_comp;
  logic [31:0] q_ff_eff;
  logic [31:0] a_ff_comp;
  logic [31:0] a_ff_eff;
  logic sign_ff, sign_eff;
  logic        rem_ff;
  logic        add;
  logic [32:0] a_eff;
  logic [64:0] a_eff_shift;
  logic        rem_correct;
  logic        flush_lower_ff;
  logic        valid_e1;

  logic smallnum_case, smallnum_case_ff;
  logic [3:0] smallnum, smallnum_ff;
  logic m_already_comp;

  logic [31:0] dividend;
  logic [31:0] divisor;

  assign dividend = dp.rs1_data;
  assign divisor  = dp.rs2_data;

  register_sync_rstn #(
      .WIDTH(1)
  ) flush_any_ff (
      .clk (clk),
      .rstn(rstn),
      .din (flush_lower),
      .dout(flush_lower_ff)
  );
  register_sync_rstn #(
      .WIDTH(1)
  ) e1val_ff (
      .clk (clk),
      .rstn(rstn),
      .din (dp.legal & dp.div & ~flush_lower_ff),
      .dout(valid_ff_e1)
  );
  register_sync_rstn #(
      .WIDTH(1)
  ) runff (
      .clk (clk),
      .rstn(rstn),
      .din (run_in),
      .dout(run_state)
  );
  register_sync_rstn #(
      .WIDTH(6)
  ) countff (
      .clk (clk),
      .rstn(rstn),
      .din (count_in[5:0]),
      .dout(count[5:0])
  );
  register_en_sync_rstn #(
      .WIDTH(4)
  ) miscf (
      .clk (clk),
      .rstn(rstn),
      .din ({dividend[31], divisor[31], sign_eff, dp.rem}),
      .dout({dividend_neg_ff, divisor_neg_ff, sign_ff, rem_ff}),
      .en  (dp.legal & dp.div)
  );
  register_sync_rstn #(
      .WIDTH(5)
  ) smallnumff (
      .clk (clk),
      .rstn(rstn),
      .din ({smallnum_case, smallnum[3:0]}),
      .dout({smallnum_case_ff, smallnum_ff[3:0]})
  );
  register_en_sync_rstn #(
      .WIDTH(33)
  ) mff (
      .clk (clk),
      .rstn(rstn),
      .en  (dp.legal & dp.div),
      .din ({~dp.unsign & divisor[31], divisor[31:0]}),
      .dout(m_ff[32:0])
  );
  register_en_sync_rstn #(
      .WIDTH(33)
  ) qff (
      .clk (clk),
      .rstn(rstn),
      .en  (qff_enable),
      .din (q_in[32:0]),
      .dout(q_ff[32:0])
  );
  register_en_sync_rstn #(
      .WIDTH(33)
  ) aff (
      .clk (clk),
      .rstn(rstn),
      .en  (aff_enable),
      .din (a_in[32:0]),
      .dout(a_ff[32:0])
  );

  twoscomp #(32) dividend_c (
      .din (q_ff[31:0]),
      .dout(dividend_comp[31:0])
  );
  twoscomp #(32) q_ff_c (
      .din (q_ff[31:0]),
      .dout(q_ff_comp[31:0])
  );
  twoscomp #(32) a_ff_c (
      .din (a_ff[31:0]),
      .dout(a_ff_comp[31:0])
  );

  register_en_sync_rstn #(
      .WIDTH(5)
  ) out_addr_ff (
      .clk (clk),
      .rstn(rstn),
      .en  (dp.legal & dp.div),
      .din (dp.rd_addr),
      .dout(out_addr)
  );

  register_en_sync_rstn #(
      .WIDTH(XLEN + INSTR_LEN)
  ) instr_tag_ff (
      .clk (clk),
      .rstn(rstn),
      .en  (dp.legal & dp.div),
      .din ({dp.instr_tag, dp.instr}),
      .dout({instr_tag_out, instr_out})
  );


  assign valid_e1 = valid_ff_e1 & ~flush_lower_ff;


  // START - short circuit logic for small numbers {{

  // small number divides - any 4b / 4b is done in 1 cycle (divisor != 0)
  // to generate espresso equations:
  // 1)  smalldiv > smalldiv.e
  // 2)  espresso -Dso -oeqntott smalldiv.e | addassign > smalldiv

  // smallnum case does not cover divide by 0
  assign smallnum_case           = ((q_ff[31:4] == 28'b0) & (m_ff[31:4] == 28'b0) & (m_ff[31:0] != 32'b0) & ~rem_ff & valid_e1 & ~dec_tlu_fast_div_disable) |
                                    ((q_ff[31:0] == 32'b0) &                         (m_ff[31:0] != 32'b0) & ~rem_ff & valid_e1 & ~dec_tlu_fast_div_disable);


  assign smallnum[3] = (q_ff[3] & ~m_ff[3] & ~m_ff[2] & ~m_ff[1]);


  assign smallnum[2]             = ( q_ff[3] &                                  ~m_ff[3] & ~m_ff[2] &            ~m_ff[0]) |
                                    ( q_ff[2] &                                  ~m_ff[3] & ~m_ff[2] & ~m_ff[1]           ) |
                                    ( q_ff[3] &  q_ff[2] &                       ~m_ff[3] & ~m_ff[2]                      );


  assign smallnum[1]             = ( q_ff[2] &                                  ~m_ff[3] & ~m_ff[2] &            ~m_ff[0]) |
                                    (                       q_ff[1] &            ~m_ff[3] & ~m_ff[2] & ~m_ff[1]           ) |
                                    ( q_ff[3] &                                  ~m_ff[3] &            ~m_ff[1] & ~m_ff[0]) |
                                    ( q_ff[3] & ~q_ff[2] &                       ~m_ff[3] & ~m_ff[2] &  m_ff[1] &  m_ff[0]) |
                                    (~q_ff[3] &  q_ff[2] &  q_ff[1] &            ~m_ff[3] & ~m_ff[2]                      ) |
                                    ( q_ff[3] &  q_ff[2] &                       ~m_ff[3] &                       ~m_ff[0]) |
                                    ( q_ff[3] &  q_ff[2] &                       ~m_ff[3] &  m_ff[2] & ~m_ff[1]           ) |
                                    ( q_ff[3] &             q_ff[1] & ~m_ff[3] &                       ~m_ff[1]           ) |
                                    ( q_ff[3] &  q_ff[2] &  q_ff[1] &            ~m_ff[3] &  m_ff[2]                      );


  assign smallnum[0]             = (            q_ff[2] &  q_ff[1] &  q_ff[0] & ~m_ff[3] &            ~m_ff[1]           ) |
                                    ( q_ff[3] & ~q_ff[2] &  q_ff[0] &            ~m_ff[3] &             m_ff[1] &  m_ff[0]) |
                                    (            q_ff[2] &                       ~m_ff[3] &            ~m_ff[1] & ~m_ff[0]) |
                                    (                       q_ff[1] &            ~m_ff[3] & ~m_ff[2] &            ~m_ff[0]) |
                                    (                                  q_ff[0] & ~m_ff[3] & ~m_ff[2] & ~m_ff[1]           ) |
                                    (~q_ff[3] &  q_ff[2] & ~q_ff[1] &            ~m_ff[3] & ~m_ff[2] &  m_ff[1] &  m_ff[0]) |
                                    (~q_ff[3] &  q_ff[2] &  q_ff[1] &            ~m_ff[3] &                       ~m_ff[0]) |
                                    ( q_ff[3] &                                             ~m_ff[2] & ~m_ff[1] & ~m_ff[0]) |
                                    ( q_ff[3] & ~q_ff[2] &                       ~m_ff[3] &  m_ff[2] &  m_ff[1]           ) |
                                    (~q_ff[3] &  q_ff[2] &  q_ff[1] &            ~m_ff[3] &  m_ff[2] & ~m_ff[1]           ) |
                                    (~q_ff[3] &  q_ff[2] &             q_ff[0] & ~m_ff[3] &            ~m_ff[1]           ) |
                                    ( q_ff[3] & ~q_ff[2] & ~q_ff[1] &            ~m_ff[3] &  m_ff[2] &             m_ff[0]) |
                                    (           ~q_ff[2] &  q_ff[1] &  q_ff[0] & ~m_ff[3] & ~m_ff[2]                      ) |
                                    ( q_ff[3] &  q_ff[2] &                                             ~m_ff[1] & ~m_ff[0]) |
                                    ( q_ff[3] &             q_ff[1] &                       ~m_ff[2] &            ~m_ff[0]) |
                                    (~q_ff[3] &  q_ff[2] &  q_ff[1] &  q_ff[0] & ~m_ff[3] &  m_ff[2]                      ) |
                                    ( q_ff[3] &  q_ff[2] &                        m_ff[3] & ~m_ff[2]                      ) |
                                    ( q_ff[3] &             q_ff[1] &             m_ff[3] & ~m_ff[2] & ~m_ff[1]           ) |
                                    ( q_ff[3] &                        q_ff[0] &            ~m_ff[2] & ~m_ff[1]           ) |
                                    ( q_ff[3] &            ~q_ff[1] &            ~m_ff[3] &  m_ff[2] &  m_ff[1] &  m_ff[0]) |
                                    ( q_ff[3] &  q_ff[2] &  q_ff[1] &             m_ff[3] &                       ~m_ff[0]) |
                                    ( q_ff[3] &  q_ff[2] &  q_ff[1] &             m_ff[3] &            ~m_ff[1]           ) |
                                    ( q_ff[3] &  q_ff[2] &             q_ff[0] &  m_ff[3] &            ~m_ff[1]           ) |
                                    ( q_ff[3] & ~q_ff[2] &  q_ff[1] &            ~m_ff[3] &             m_ff[1]           ) |
                                    ( q_ff[3] &             q_ff[1] &  q_ff[0] &            ~m_ff[2]                      ) |
                                    ( q_ff[3] &  q_ff[2] &  q_ff[1] &  q_ff[0] &  m_ff[3]                                 );



  // END   - short circuit logic for small numbers }}


  // *** Start Short Q *** {{

  logic [ 4:0] a_cls;
  logic [ 4:0] b_cls;
  logic [ 5:0] shortq;
  logic [ 5:0] shortq_shift;
  logic [ 5:0] shortq_shift_ff;
  logic        shortq_enable;
  logic        shortq_enable_ff;
  logic [32:0] short_dividend;

  assign short_dividend[31:0] = q_ff[31:0];
  assign short_dividend[32]   = sign_ff & q_ff[31];


  //    A       B
  //   210     210    SH
  //   ---     ---    --
  //   1xx     000     0
  //   1xx     001     8
  //   1xx     01x    16
  //   1xx     1xx    24
  //   01x     000     8
  //   01x     001    16
  //   01x     01x    24
  //   01x     1xx    32
  //   001     000    16
  //   001     001    24
  //   001     01x    32
  //   001     1xx    32
  //   000     000    24
  //   000     001    32
  //   000     01x    32
  //   000     1xx    32

  logic [3:0] shortq_raw;
  logic [3:0] shortq_shift_xx;

  assign a_cls[4:3] = 2'b0;
  assign a_cls[2]                =  (~short_dividend[32] & (short_dividend[31:24] != {8{1'b0}})) | ( short_dividend[32] & (short_dividend[31:23] != {9{1'b1}}));
  assign a_cls[1]                =  (~short_dividend[32] & (short_dividend[23:16] != {8{1'b0}})) | ( short_dividend[32] & (short_dividend[22:15] != {8{1'b1}}));
  assign a_cls[0]                =  (~short_dividend[32] & (short_dividend[15:08] != {8{1'b0}})) | ( short_dividend[32] & (short_dividend[14:07] != {8{1'b1}}));

  assign b_cls[4:3] = 2'b0;
  assign b_cls[2]                =  (~m_ff[32]           & (          m_ff[31:24] != {8{1'b0}})) | ( m_ff[32]           & (          m_ff[31:24] != {8{1'b1}}));
  assign b_cls[1]                =  (~m_ff[32]           & (          m_ff[23:16] != {8{1'b0}})) | ( m_ff[32]           & (          m_ff[23:16] != {8{1'b1}}));
  assign b_cls[0]                =  (~m_ff[32]           & (          m_ff[15:08] != {8{1'b0}})) | ( m_ff[32]           & (          m_ff[15:08] != {8{1'b1}}));

  assign shortq_raw[3] = ((a_cls[2:1] == 2'b01) & (b_cls[2] == 1'b1)) |  // Shift by 32
      ( (a_cls[2:0] == 3'b001) & (b_cls[2]   == 1'b1  ) ) |
                                    ( (a_cls[2:0] == 3'b000) & (b_cls[2]   == 1'b1  ) ) |
                                    ( (a_cls[2:0] == 3'b001) & (b_cls[2:1] == 2'b01 ) ) |
                                    ( (a_cls[2:0] == 3'b000) & (b_cls[2:1] == 2'b01 ) ) |
                                    ( (a_cls[2:0] == 3'b000) & (b_cls[2:0] == 3'b001) );

  assign shortq_raw[2] = ((a_cls[2] == 1'b1) & (b_cls[2] == 1'b1)) |  // Shift by 24
      ( (a_cls[2:1] == 2'b01 ) & (b_cls[2:1] == 2'b01 ) ) |
                                    ( (a_cls[2:0] == 3'b001) & (b_cls[2:0] == 3'b001) ) |
                                    ( (a_cls[2:0] == 3'b000) & (b_cls[2:0] == 3'b000) );

  assign shortq_raw[1] = ((a_cls[2] == 1'b1) & (b_cls[2:1] == 2'b01)) |  // Shift by 16
      ( (a_cls[2:1] == 2'b01 ) & (b_cls[2:0] == 3'b001) ) |
                                    ( (a_cls[2:0] == 3'b001) & (b_cls[2:0] == 3'b000) );

  assign shortq_raw[0] = ((a_cls[2] == 1'b1) & (b_cls[2:0] == 3'b001)) |  // Shift by  8
      ((a_cls[2:1] == 2'b01) & (b_cls[2:0] == 3'b000));


  assign shortq_enable = valid_ff_e1 & (m_ff[31:0] != 32'b0) & (shortq_raw[3:0] != 4'b0);

  assign shortq_shift[3:0] = ({4{shortq_enable}} & shortq_raw[3:0]);

  register #(
      .WIDTH(5)
  ) i_shortq_ff (
      .clk (clk),
      .din ({shortq_enable, shortq_shift[3:0]}),
      .dout({shortq_enable_ff, shortq_shift_xx[3:0]})
  );

  assign shortq_shift_ff[5:0] = ({6{shortq_shift_xx[3]}} & 6'b01_1111) |  // 31
      ({6{shortq_shift_xx[2]}} & 6'b01_1000) |  // 24
      ({6{shortq_shift_xx[1]}} & 6'b01_0000) |  // 16
      ({6{shortq_shift_xx[0]}} & 6'b00_1000);  //  8

`ifdef ASSERT_ON

  logic div_assert_fail;

  assign div_assert_fail         =  (shortq_shift_xx[3] & shortq_shift_xx[2]) |
                                     (shortq_shift_xx[3] & shortq_shift_xx[1]) |
                                     (shortq_shift_xx[3] & shortq_shift_xx[0]) |
                                     (shortq_shift_xx[2] & shortq_shift_xx[1]) |
                                     (shortq_shift_xx[2] & shortq_shift_xx[0]) |
                                     (shortq_shift_xx[1] & shortq_shift_xx[0]);

  assert_exu_div_shortq_shift_error :
  assert #0 (~div_assert_fail)
  else $display("ERROR: SHORTQ_SHIFT_XX with multiple shifts ON!");

`endif

  // *** End   Short Q *** }}


  register #(
      .WIDTH(1)
  ) out_valid_ff (
      .clk (clk),
      .din (finish),
      .dout(out_valid)
  );

  assign div_stall = run_state;

  assign run_in = (dp.legal & dp.div | run_state) & ~finish & ~flush_lower_ff;

  assign count_in[5:0]           = {6{run_state & ~finish & ~flush_lower_ff & ~shortq_enable}} & (count[5:0] + shortq_shift_ff[5:0] + 6'd1);


  assign finish_early = smallnum_case;

  assign finish                  = (smallnum_case | ((~rem_ff) ? (count[5:0] == 6'd32) : (count[5:0] == 6'd33))) & ~flush_lower & ~flush_lower_ff;

  assign sign_eff = ~dp.unsign & (divisor[31:0] != 32'b0);


  assign q_in[32:0]              = ({33{~run_state                                   }} &  {1'b0,dividend[31:0]}) |
                                    ({33{ run_state &  (valid_ff_e1 | shortq_enable_ff)}} &  ({dividend_eff[31:0], ~a_in[32]} << shortq_shift_ff[5:0])) |
                                    ({33{ run_state & ~(valid_ff_e1 | shortq_enable_ff)}} &  {q_ff[31:0], ~a_in[32]});

  assign qff_enable = dp.legal & dp.div | (run_state & ~shortq_enable);




  assign dividend_eff[31:0] = (sign_ff & dividend_neg_ff) ? dividend_comp[31:0] : q_ff[31:0];


  assign m_eff[32:0] = (add) ? m_ff[32:0] : ~m_ff[32:0];

  assign a_eff_shift[64:0] = {33'b0, dividend_eff[31:0]} << shortq_shift_ff[5:0];

  assign a_eff[32:0]             = ({33{ rem_correct                    }} &  a_ff[32:0]           ) |
                                    ({33{~rem_correct & ~shortq_enable_ff}} & {a_ff[31:0], q_ff[32]}) |
                                    ({33{~rem_correct &  shortq_enable_ff}} &  a_eff_shift[64:32]   );

  assign a_shift[32:0] = {33{run_state}} & a_eff[32:0];

  assign a_in[32:0] = {33{run_state}} & (a_shift[32:0] + m_eff[32:0] + {32'b0, ~add});

  assign aff_enable = dp.legal & dp.div | (run_state & ~shortq_enable & (count[5:0] != 6'd33)) | rem_correct;


  assign m_already_comp = (divisor_neg_ff & sign_ff);

  // if m already complemented, then invert operation add->sub, sub->add
  assign add = (a_ff[32] | rem_correct) ^ m_already_comp;

  assign rem_correct = (count[5:0] == 6'd33) & rem_ff & a_ff[32];



  assign q_ff_eff[31:0]          = (sign_ff & (dividend_neg_ff ^ divisor_neg_ff)) ? q_ff_comp[31:0] : q_ff[31:0];

  assign a_ff_eff[31:0] = (sign_ff & dividend_neg_ff) ? a_ff_comp[31:0] : a_ff[31:0];

  assign out[31:0]               = ({32{ smallnum_case_ff          }} & {28'b0, smallnum_ff[3:0]}) |
                                    ({32{                     rem_ff}} &  a_ff_eff[31:0]          ) |
                                    ({32{~smallnum_case_ff & ~rem_ff}} &  q_ff_eff[31:0]          );


endmodule
