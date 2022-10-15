module top_module(input [511:0] Cb0,
                  input [511:0] Cr0,
                  input clock,
                  input reset,
                  input enable,
                  output [575:0] out,
                  output wire enable_output
                  );
wire [511:0] Cb_d_o;
wire [511:0] Cr_d_o;
wire [703:0] dct_o;
wire [511:0] quant_o;
wire [511:0] encoded;
wire enable_1;
wire enable_2;
wire enable_3;
wire enable_4;
wire enable_5;
wire enable_6;
wire [511:0] decode_wire1;
wire [703:0] decode_wire2;
chrominance_downsampling instance1(.Clock(clock), .reset(reset), .Enable0(enable), .Cb(Cb0), .Cr(Cr0), .Cb_d(Cb_d_o), .Cr_d(Cr_d_o), .enable1(enable_1));
dct instance2(.Clock(clock), .reset(reset), .enable1(enable_1), .A(Cb0), .C(dct_o), .enable2(enable_2));
quantization instance3(.Clock(clock), .reset(reset), .Enable(enable_2), .A(dct_o), .C(quant_o), .done(enable_3));
encode instance4(.Clock(clock), .reset(reset), .Enable(enable_3), .A(quant_o), .C(encoded), .done(enable_4));
decoding instance5(.Clock(clock),  .reset(reset), .Enable(enable_4), .A(encoded), .C(decode_wire1), .done(enable_5));
Dequantization instance6(.Clock(clock), .reset(reset), .Enable(enable_5), .A(decode_wire1), .C(decode_wire2), .done(enable_6));
idct instance7(.Clock(clock), .Enable(enable_6), .reset(reset), .A(decode_wire2), .C(out), .done(enable_output));
endmodule