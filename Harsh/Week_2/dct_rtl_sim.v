// Verilog netlist created by TD v4.6.14756
// Sun Sep  4 18:12:40 2022

`timescale 1ns / 1ps
module tb_matrix_mult  // ../OneDrive/Desktop/image-processing-fpga/Harsh/Week_2/tb_matrix_multiplication.v(2)
  (
  );


  parameter Clock_period = 10;
  wire Clock;  // ../OneDrive/Desktop/image-processing-fpga/Harsh/Week_2/tb_matrix_multiplication.v(7)
  wire Clock_keep;

  AL_BUFKEEP #(
    .KEEP("OUT"))
    _bufkeep_Clock (
    .i(Clock),
    .o(Clock_keep));  // ../OneDrive/Desktop/image-processing-fpga/Harsh/Week_2/tb_matrix_multiplication.v(7)
  not u2 (Clock, Clock_keep);  // ../OneDrive/Desktop/image-processing-fpga/Harsh/Week_2/tb_matrix_multiplication.v(66)

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

