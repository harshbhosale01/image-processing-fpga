// Verilog netlist created by TD v4.6.14756
// Mon Sep 12 22:15:37 2022

`timescale 1ns / 1ps
module tb_chrominance_downsampling  // ../codes/tb_chrominance_down.v(1)
  (
  );


  parameter Clock_period = 10;
  wire Clock;  // ../codes/tb_chrominance_down.v(7)
  wire Clock_keep;

  AL_BUFKEEP #(
    .KEEP("OUT"))
    _bufkeep_Clock (
    .i(Clock),
    .o(Clock_keep));  // ../codes/tb_chrominance_down.v(7)
  not u2 (Clock, Clock_keep);  // ../codes/tb_chrominance_down.v(70)

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

