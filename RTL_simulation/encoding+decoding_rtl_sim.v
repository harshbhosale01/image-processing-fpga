// Verilog netlist created by TD v4.6.14756
// Fri Oct 14 12:10:44 2022

`timescale 1ns / 1ps
module tb_chrominance_downsampling  // ../OneDrive/Desktop/all_modules/tb_chrominance_down.v(1)
  (
  );


  parameter Clock_period = 10;
  wire Clock;  // ../OneDrive/Desktop/all_modules/tb_chrominance_down.v(6)
  wire Clock_keep;

  AL_BUFKEEP #(
    .KEEP("OUT"))
    _bufkeep_Clock (
    .i(Clock),
    .o(Clock_keep));  // ../OneDrive/Desktop/all_modules/tb_chrominance_down.v(6)
  not u2 (Clock, Clock_keep);  // ../OneDrive/Desktop/all_modules/tb_chrominance_down.v(63)

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

