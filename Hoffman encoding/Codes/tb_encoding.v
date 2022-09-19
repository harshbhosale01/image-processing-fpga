module tb_encode();
reg signed [511:0] A;
wire signed [511:0] C;
wire done;
reg Clock,reset, Enable;
parameter Clock_period = 10;
integer i;

initial begin
    Clock <= 1;
    reset <= 1;
    #100;   //Apply reset for 100 ns before applying inputs.
    reset <= 0;
    #Clock_period;

    A <={8'd9,8'd3,8'd1,8'd4,8'd1,8'd0,-8'd1,8'd0,
         8'd2,8'd8,8'd0,8'd1,8'd1,8'd0,8'd0,8'd0,
         -8'd6,-8'd4,8'd0,-8'd1,8'd0,8'd0,8'd0,8'd0,
         -8'd2,-8'd4,8'd0,8'd0,8'd0,8'd0,8'd0,8'd0,
         -8'd1,8'd0,8'd0,8'd0,8'd0,8'd0,8'd0,8'd0,
         8'd0,8'd0,8'd0,8'd0,8'd0,8'd0,8'd0,8'd0,
         8'd0,8'd0,8'd0,8'd0,8'd0,8'd0,8'd0,8'd0,
         8'd0,8'd0,8'd0,8'd0,8'd0,8'd0,8'd0,8'd0};

    Enable <= 1; // Here the process will start in verilog file
    wait(done); //wait until 'done' output goes High.

    #(Clock_period/2);
    display;   //task calling 
    #Clock_period;  //wait for one clock cycle.
    Enable <= 0; //reset Enable.
    #Clock_period;
    $stop;
end

task display;    //Task to display the output matrix
    for(i=0;i<=63;i=i+1) begin
             #10 $display("%b",C[i*8 +:8]);
    end
endtask

always #(Clock_period/2) Clock <= ~Clock;
encode tb_encode 
        (.Clock(Clock), 
        .reset(reset), 
        .Enable(Enable), 
        .A(A),
        .C(C), 
        .done(done));


endmodule