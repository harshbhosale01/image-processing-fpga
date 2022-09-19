// Verilog netlist created by TD v4.6.14756
// Mon Sep 19 22:52:19 2022

`timescale 1ns / 1ps
module tb_encode  // ../OneDrive/Documents/Hoffman encoding/Analogic/src/tb_encoding.v(1)
  (
  );


  parameter Clock_period = 10;
  wire Clock;  // ../OneDrive/Documents/Hoffman encoding/Analogic/src/tb_encoding.v(5)
  wire Clock_keep;

  AL_BUFKEEP #(
    .KEEP("OUT"))
    _bufkeep_Clock (
    .i(Clock),
    .o(Clock_keep));  // ../OneDrive/Documents/Hoffman encoding/Analogic/src/tb_encoding.v(5)
  not u2 (Clock, Clock_keep);  // ../OneDrive/Documents/Hoffman encoding/Analogic/src/tb_encoding.v(42)

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

