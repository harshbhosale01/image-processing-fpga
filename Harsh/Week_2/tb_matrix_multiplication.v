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
    A = {8'd191,8'd191,8'd191,8'd190,8'd187,8'd222,8'd255,8'd220,
         8'd188,8'd188,8'd189,8'd190,8'd193,8'd188,8'd214,8'd255,
         8'd192,8'd187,8'd199,8'd186,8'd189,8'd193,8'd187,8'd224,
         8'd188,8'd192,8'd184,8'd191,8'd196,8'd185,8'd193,8'd189,
         8'd194,8'd87,8'd255,8'd186,8'd255,8'd87,8'd192,8'd185,
         8'd186,8'd255,8'd110,8'd255,8'd104,8'd255,8'd188,8'd194,
         8'd191,8'd189,8'd251,8'd0,8'd255,8'd188,8'd190,8'd190,
         8'd188,8'd189,8'd193,8'd254,8'd189,8'd191,8'd188,8'd191};
    B = {8'd239,8'd32,8'd27,-8'd12,8'd3,-8'd5,8'd3,8'd1,
         8'd34,-8'd3,-8'd19,8'd6,8'd3,8'd0,-8'd1,8'd1,
         -8'd70,8'd2,8'd8,8'd23,8'd9,8'd6,-8'd1,-8'd1,
         8'd5,8'd0,-8'd6,8'd11,-8'd2,8'd0,-8'd1,8'd1,
         -8'd17,-8'd3,8'd6,8'd6,8'd3,-8'd1,8'd0,8'd0,
         8'd2,8'd4,8'd2,8'd2,8'd1,-8'd2,8'd0,8'd1,
         -8'd3,8'd0,8'd0,-8'd1,-8'd1,-8'd1,8'd0,8'd0,
         8'd1,-8'd1,8'd3,8'd1,8'd0,8'd0,8'd0,8'd0};
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