// Verilog netlist created by TD v4.6.14756
// Wed Sep 21 12:08:49 2022

`timescale 1ns / 1ps
module tb_dcode  // ../OneDrive/Documents/Hoffman decoding/analogic/src/tb_decoding.v(1)
  (
  );


  parameter Clock_period = 10;
  wire Clock;  // ../OneDrive/Documents/Hoffman decoding/analogic/src/tb_decoding.v(5)
  wire Clock_keep;

  AL_BUFKEEP #(
    .KEEP("OUT"))
    _bufkeep_Clock (
    .i(Clock),
    .o(Clock_keep));  // ../OneDrive/Documents/Hoffman decoding/analogic/src/tb_decoding.v(5)
  not u3 (Clock, Clock_keep);  // ../OneDrive/Documents/Hoffman decoding/analogic/src/tb_decoding.v(41)

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

