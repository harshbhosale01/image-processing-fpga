module tb_quantization;  //testbench module is always empty. No input or output ports.

reg signed [1023:0] A;
reg signed [1023:0] B;
wire signed [1023:0] C;
reg Clock,reset, Enable;
wire done;
reg signed [15:0] matC [7:0][7:0];
integer i,j;
parameter Clock_period = 10;    //Change clock period here. 

initial
begin
    Clock = 1;
    reset = 1;
    #100;   //Apply reset for 100 ns before applying inputs.
    reset = 0;
    #Clock_period;
    //input matrices are set and Enable input is set High
    A = {16'd154,16'd42,16'd19,16'd72,16'd30,16'd14,-16'd66,-16'd9,
         16'd30,16'd103,16'd10,16'd33,16'd26,-16'd16,-16'd15,-16'd4,
         -16'd91,-16'd54,16'd7,-16'd42,-16'd33,16'd7,16'd29,16'd8,
         -16'd38,-16'd77,-16'd9,-16'd22,-16'd16,16'd17,16'd29,16'd8,
         -16'd28,16'd18,-16'd7,-16'd11,16'd12,-16'd7,16'd10,-16'd3,
         16'd1,-16'd11,16'd10,16'd1,16'd23,16'd13,16'd2,16'd4,
         16'd4,-16'd3,16'd4,16'd4,-16'd20,-16'd14,16'd10,16'd12,
         -16'd10,16'd11,16'd6,-16'd14,16'd18,-16'd2,16'd1,16'd8};
    B = {16'd16,16'd11,16'd10,16'd16,16'd24,16'd40,16'd51,16'd61,
         16'd12,16'd12,16'd14,16'd19,16'd26,16'd58,16'd60,16'd55,
         16'd14,16'd13,16'd16,16'd24,16'd40,16'd57,16'd69,16'd56,
         16'd14,16'd17,16'd22,16'd29,16'd51,16'd87,16'd80,16'd62,
         16'd18,16'd22,16'd37,16'd56,16'd68,16'd109,16'd103,16'd77,
         16'd24,16'd35,16'd55,16'd64,16'd81,16'd104,16'd113,16'd92,
         16'd49,16'd64,16'd78,16'd87,16'd103,16'd121,16'd120,16'd101,
         16'd72,16'd92,16'd95,16'd98,16'd112,16'd100,16'd103,16'd99};
    Enable = 1; // Here the process will start in verilog file
    wait(done); //wait until 'done' output goes High.
    
    #(Clock_period/2);  //wait for half a clock cycle.
    //convert the 1-D matrix into 2-D format to easily verify the results.
    for(i=7;i>=0;i=i-1) begin
        for(j=7;j>=0;j=j-1) begin
            matC[i][j] = C[(i*8+j)*16+:16];
        end
    end

    display;   //task calling 
    #Clock_period;  //wait for one clock cycle.
    Enable = 0; //reset Enable.
    #Clock_period;
    $stop;  //Stop the simulation, as we have finished testing the design.
end

task display;    //Task to display the output matrix
    for(i=0;i<=7;i=i+1) begin
             #10 $display("%d %d %d %d %d %d %d %d", matC[i][0], matC[i][1], matC[i][2], matC[i][3], matC[i][4], matC[i][5], matC[i][6],matC[i][7]);
    end
   
endtask

//generate a 50Mhz clock for testing the design.
always #(Clock_period/2) Clock <= ~Clock;

//Instantiate the division
quantization tb_q 
        (.Clock(Clock), 
        .reset(reset), 
        .Enable(Enable), 
        .A(A),
        .B(B), 
        .C(C),
        .done(done));


endmodule   //End of testbench.