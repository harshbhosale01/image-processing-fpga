module tb_matrix_mult;  //testbench module is always empty. No input or output ports.

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
    A = {16'd154,16'd123,16'd123,16'd123,16'd123,16'd123,16'd123,16'd126,
         16'd192,16'd180,16'd136,16'd154,16'd154,16'd154,16'd136,16'd110,
         16'd254,16'd198,16'd154,16'd154,16'd180,16'd154,16'd123,16'd123,
         16'd239,16'd180,16'd136,16'd180,16'd180,16'd166,16'd123,16'd123,
         16'd180,16'd154,16'd136,16'd167,16'd166,16'd149,16'd136,16'd136,
         16'd128,16'd136,16'd123,16'd136,16'd154,16'd180,16'd198,16'd154,
         16'd123,16'd105,16'd110,16'd149,16'd136,16'd136,16'd180,16'd166,
         16'd110,16'd136,16'd123,16'd123,16'd123,16'd136,16'd154,16'd136};
    B = {16'd3536,16'd3536,16'd3536,16'd3536,16'd3536,16'd3536,16'd3536,16'd3536,
         16'd4904,16'd4157,16'd2778,16'd975,-16'd975,-16'd2778,-16'd4157,-16'd4904,
         16'd4619,16'd1913,-16'd1913,-16'd4619,-16'd4619,-16'd1913,16'd1913,16'd4619,
         16'd4157,-16'd975,-16'd4904,-16'd2778,16'd2778,16'd4904,16'd975,-16'd4157,
         16'd3536,-16'd3536,-16'd3536,16'd3536,16'd3536,-16'd3536,-16'd3536,16'd3536,
         16'd2778,-16'd4904,16'd975,16'd4157,-16'd4157,-16'd975,16'd4904,-16'd2778,
         -16'd1913,-16'd4619,16'd4619,-16'd1913,-16'd1913,16'd4619,-16'd4619,16'd1913,
         16'd975,-16'd2778,16'd4157,-16'd4904,16'd4904,-16'd4157,16'd2778,-16'd975};
    Enable = 1; // Here the multiplication process will start in verilog file
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