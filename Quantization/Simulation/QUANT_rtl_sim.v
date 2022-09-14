// Verilog netlist created by TD v4.6.14756
// Wed Sep 14 01:03:47 2022

`timescale 1ns / 1ps
module tb_quantization  // ../Analogic/src/tb_quantization.v(1)
  (
  );


  parameter Clock_period = 10;
  wire Clock;  // ../Analogic/src/tb_quantization.v(6)
  wire Clock_keep;

  AL_BUFKEEP #(
    .KEEP("OUT"))
    _bufkeep_Clock (
    .i(Clock),
    .o(Clock_keep));  // ../Analogic/src/tb_quantization.v(6)
  not u2 (Clock, Clock_keep);  // ../Analogic/src/tb_quantization.v(62)

endmodule 

module AL_BUFKEEP
  (
  i,
  o
  );

  input i;
  output o;

  parameter KEEP = "OUT";

  buf u1 (o, i);

endmodule 

