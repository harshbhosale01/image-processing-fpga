// Verilog netlist created by TD v4.6.14756
// Thu Sep  8 19:03:22 2022

`timescale 1ns / 1ps
module tb_matrix_mult  // ../OneDrive/Desktop/dct_final/tb_trial_matrix_multiplication.v(1)
  (
  );


  parameter Clock_period = 10;
  wire Clock;  // ../OneDrive/Desktop/dct_final/tb_trial_matrix_multiplication.v(6)
  wire Clock_keep;

  AL_BUFKEEP #(
    .KEEP("OUT"))
    _bufkeep_Clock (
    .i(Clock),
    .o(Clock_keep));  // ../OneDrive/Desktop/dct_final/tb_trial_matrix_multiplication.v(6)
  not u2 (Clock, Clock_keep);  // ../OneDrive/Desktop/dct_final/tb_trial_matrix_multiplication.v(62)

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

