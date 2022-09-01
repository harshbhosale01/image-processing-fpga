//Testbench for testing the 8 by 8 matrix multiplier.
module tb_matrix_mult;  //testbench module is always empty. No input or output ports.

reg [511:0] A;
reg [511:0] B;
wire [511:0] C;
reg Clock,reset, Enable;
wire done;
reg [7:0] matC [7:0][7:0];
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
    A = {8'd9,8'd8,8'd7,8'd6,8'd5,8'd4,8'd3,8'd2,8'd1,
         8'd9,8'd8,8'd7,8'd6,8'd5,8'd4,8'd3,8'd2,8'd1,
         8'd9,8'd8,8'd7,8'd6,8'd5,8'd4,8'd3,8'd2,8'd1,
         8'd9,8'd8,8'd7,8'd6,8'd5,8'd4,8'd3,8'd2,8'd1,
         8'd9,8'd8,8'd7,8'd6,8'd5,8'd4,8'd3,8'd2,8'd1,
         8'd9,8'd8,8'd7,8'd6,8'd5,8'd4,8'd3,8'd2,8'd1,
         8'd9,8'd8,8'd7,8'd6,8'd5,8'd4,8'd3,8'd2,8'd1,
         8'd9,8'd8,8'd7,8'd6,8'd5,8'd4,8'd3,8'd2,8'd1};
    B = {8'd1,8'd9,8'd8,8'd7,8'd6,8'd5,8'd4,8'd3,8'd2,
         8'd1,8'd9,8'd8,8'd7,8'd6,8'd5,8'd4,8'd3,8'd2,
         8'd1,8'd9,8'd8,8'd7,8'd6,8'd5,8'd4,8'd3,8'd2,
         8'd1,8'd9,8'd8,8'd7,8'd6,8'd5,8'd4,8'd3,8'd2,
         8'd1,8'd9,8'd8,8'd7,8'd6,8'd5,8'd4,8'd3,8'd2,
         8'd1,8'd9,8'd8,8'd7,8'd6,8'd5,8'd4,8'd3,8'd2,
         8'd1,8'd9,8'd8,8'd7,8'd6,8'd5,8'd4,8'd3,8'd2,
         8'd1,8'd9,8'd8,8'd7,8'd6,8'd5,8'd4,8'd3,8'd2};
    Enable = 1; // Here the multiplication process will start in verilog file
    wait(done); //wait until 'done' output goes High.
    
    #(Clock_period/2);  //wait for half a clock cycle.
    //convert the 1-D matrix into 2-D format to easily verify the results.
    for(i=0;i<=7;i=i+1) begin
        for(j=0;j<=7;j=j+1) begin
            matC[i][j] = C[(i*8+j)*8+:8];
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
        for(j=0;j<=7;j=j+1) begin
             #10 $display("%d  ",matC[i][j]);
        end
        #10 $display(" \n ");
    end
   
endtask

//generate a 50Mhz clock for testing the design.
always #(Clock_period/2) Clock <= ~Clock;

//Instantiate the matrix multiplier
matrix_mult matrix_multiplier 
        (.Clock(Clock), 
        .reset(reset), 
        .Enable(Enable), 
        .A(A),
        .B(B), 
        .C(C),
        .done(done));


endmodule   //End of testbench.