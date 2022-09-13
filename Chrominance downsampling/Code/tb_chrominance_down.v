module tb_chrominance_downsampling;  //testbench module is always empty. No input or output ports.

reg signed [511:0] Cb;
reg signed [511:0] Cr;
wire signed [511:0] Cb_d;
wire signed [511:0] Cr_d;
reg Clock,reset, Enable;
wire done1 , done2;
reg [7:0] mat1 [7:0][7:0];
reg [7:0] mat2 [7:0][7:0];
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
    Cb ={8'd154,8'd123,8'd123,8'd123,8'd123,8'd123,8'd123,8'd126,
         8'd192,8'd180,8'd136,8'd154,8'd154,8'd154,8'd136,8'd110,
         8'd254,8'd198,8'd154,8'd154,8'd180,8'd154,8'd123,8'd123,
         8'd239,8'd180,8'd136,8'd180,8'd180,8'd166,8'd123,8'd123,
         8'd180,8'd154,8'd136,8'd167,8'd166,8'd149,8'd136,8'd136,
         8'd128,8'd136,8'd123,8'd136,8'd154,8'd180,8'd198,8'd154,
         8'd123,8'd105,8'd110,8'd149,8'd136,8'd136,8'd180,8'd166,
         8'd110,8'd136,8'd123,8'd123,8'd123,8'd136,8'd154,8'd136};
    Cr ={8'd154,8'd123,8'd123,8'd123,8'd123,8'd123,8'd123,8'd126,
         8'd192,8'd180,8'd136,8'd154,8'd154,8'd154,8'd136,8'd110,
         8'd254,8'd198,8'd154,8'd154,8'd180,8'd154,8'd123,8'd123,
         8'd239,8'd180,8'd136,8'd180,8'd180,8'd166,8'd123,8'd123,
         8'd180,8'd154,8'd136,8'd167,8'd166,8'd149,8'd136,8'd136,
         8'd128,8'd136,8'd123,8'd136,8'd154,8'd180,8'd198,8'd154,
         8'd123,8'd105,8'd110,8'd149,8'd136,8'd136,8'd180,8'd166,
         8'd110,8'd136,8'd123,8'd123,8'd123,8'd136,8'd154,8'd136};
    Enable = 1; // Here the downsampling process will start in verilog file
    wait(done1 && done2); //wait until 'done' output goes High.
    
    #(Clock_period/2);  //wait for half a clock cycle.
    //convert the 1-D matrix into 2-D format to easily verify the results.
    for(i=7;i>=0;i=i-1) begin
        for(j=7;j>=0;j=j-1) begin
            mat1[i][j] = Cb_d[(i*8+j)*8+:8];
            mat2[i][j] = Cr_d[(i*8+j)*8+:8];
        end
    end

    display;   //task calling 
    #Clock_period;  //wait for one clock cycle.
    Enable = 0; //reset Enable.
    #Clock_period;
    $stop;  //Stop the simulation, as we have finished testing the design.
end

task display;
begin    //Task to display the output matrix
    for(i=0;i<=7;i=i+1) begin
             #10 $display("%d %d %d %d %d %d %d %d", mat1[i][0], mat1[i][1], mat1[i][2], mat1[i][3], mat1[i][4], mat1[i][5], mat1[i][6],mat1[i][7]);
    end
    #100;
    for(i=0;i<=7;i=i+1) begin
             #10 $display("%d %d %d %d %d %d %d %d", mat2[i][0], mat2[i][1], mat2[i][2], mat2[i][3], mat2[i][4], mat2[i][5], mat2[i][6],mat2[i][7]);
    end
end
endtask

//generate a 50Mhz clock for testing the design.
always #(Clock_period/2) Clock <= ~Clock;

//Instantiate the matrix multiplier
chrominance_downsampling chrominance_down 
        (.Clock(Clock), 
        .reset(reset), 
        .Enable(Enable), 
        .Cb(Cb),
        .Cr(Cr), 
        .Cb_d(Cb_d),
        .Cr_d(Cr_d),
        .done1(done1),
        .done2(done2));


endmodule 