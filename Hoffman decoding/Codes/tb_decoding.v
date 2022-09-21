module tb_dcode();
reg signed [511:0] A;
wire signed [511:0] C;
wire done;
reg Clock,reset, Enable;
reg signed [7:0] matC [7:0][7:0];
parameter Clock_period = 10;
integer i,j;

initial begin
    Clock <= 1;
    reset <= 1;
    #100;   //Apply reset for 100 ns before applying inputs.
    reset <= 0;
    #Clock_period;

    A <={344'bx,168'b000010010000001100000010011110100000100000000001000001001000000101111100011111100111111101111100100000010000000100000001100000010000000101111111100010010111111110100100};

    Enable <= 1; // Here the process will start in verilog file
    wait(done); //wait until 'done' output goes High.

    #(Clock_period/2);
    for(i=7;i>=0;i=i-1) begin
        for(j=7;j>=0;j=j-1) begin
            matC[i][j] = C[(i*8+j)*8+:8];
        end
    end
    display;   //task calling 
    #Clock_period;  //wait for one clock cycle.
    Enable <= 0; //reset Enable.
    #Clock_period;
    $stop;
end

task display;    //Task to display the output matrix
    for(i=0;i<=7;i=i+1) begin
             #10 $display("%d %d %d %d %d %d %d %d", matC[i][0], matC[i][1], matC[i][2], matC[i][3], matC[i][4], matC[i][5], matC[i][6],matC[i][7]);
    end
endtask

always #(Clock_period/2) Clock <= ~Clock;
decoding tb_decode 
        (.Clock(Clock), 
        .reset(reset), 
        .Enable(Enable), 
        .A(A),
        .C(C), 
        .done(done));


endmodule