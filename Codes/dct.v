//8 by 8 matrix multiplier. Each element of the matrix is 8 bit wide. 
//Inputs are named A and B and output is named as C. 
//Each matrix has 64 elements each of which is 8 bit wide. So the inputs is 512 bit long.
module dct
    (   input Clock,
        input reset, //active high reset
        input enable1,    //This should be High throughout the matrix multiplication process.
        input [511:0] A,
        output reg [703:0] C,
		output reg enable2
    );   

//temperory registers.
reg signed [8:0] temp2 ; 
reg [7:0] matA [7:0][7:0];
reg signed [13:0] matB [7:0][7:0];
reg signed [13:0] matBT [7:0][7:0];   
reg signed [10:0] matTemp [7:0][7:0];
reg signed [10:0] matC [7:0][7:0];
reg signed [895:0] B;

integer i,j,k;  //loop indices
reg first_cycle;    //indicates its the first clock cycle after Enable went High.
reg end_of_mult1;    //indicates first multiplication has ended.
reg end_of_mult2;    //indicates second multiplication has ended.
reg signed [10:0] temp; //a temeporary register to hold the product of two elements.


//Matrix multiplication.
always @(posedge Clock or posedge reset)    
begin
    if(reset == 1) begin    //Active high reset
        i = 0;
        j = 0;
        k = 0;
        temp = 0;
        first_cycle = 1;
        end_of_mult1 = 0;
        end_of_mult2 = 0;
        enable2 = 0;
        //Initialize all the matrix register elements to zero.
        for(i=0;i<=7;i=i+1) begin
            for(j=0;j<=7;j=j+1) begin
                matA[i][j] = 8'd0;
                matB[i][j] = 14'd0;
                matBT[i][j] = 14'd0;
                matC[i][j] = 11'd0;
                matTemp[i][j] = 11'd0;
            end 
        end 
    end
    else begin  //for the positve edge of Clock.
        if(enable1 == 1)     //Any action happens only when Enable is High.
            if(first_cycle == 1) begin     //the very first cycle after Enable is high.
                //the matrices which are in a 1-D array are converted to 2-D matrices first.
                    B = {14'd3536,14'd3536,14'd3536,14'd3536,14'd3536,14'd3536,14'd3536,14'd3536,
                         14'd4904,14'd4157,14'd2778,14'd975,-14'd975,-14'd2778,-14'd4157,-14'd4904,
                         14'd4619,14'd1913,-14'd1913,-14'd4619,-14'd4619,-14'd1913,14'd1913,14'd4619,
                         14'd4157,-14'd975,-14'd4904,-14'd2778,14'd2778,14'd4904,14'd975,-14'd4157,
                         14'd3536,-14'd3536,-14'd3536,14'd3536,14'd3536,-14'd3536,-14'd3536,14'd3536,
                         14'd2778,-14'd4904,14'd975,14'd4157,-14'd4157,-14'd975,14'd4904,-14'd2778,
                         14'd1913,-14'd4619,14'd4619,-14'd1913,-14'd1913,14'd4619,-14'd4619,14'd1913,
                         14'd975,-14'd2778,14'd4157,-14'd4904,14'd4904,-14'd4157,14'd2778,-14'd975};
                for(i=0;i<=7;i=i+1) begin
                    for(j=0;j<=7;j=j+1) begin
                        matA[i][j] =  A[(i*8+j)*8+:8] ;   //Bit slicing is used here it is same as A[((i*8+j)*16)+15 : ((i*8+j)*8)]
                        matB[i][j] =  B[(i*8+j)*14+:14];
                        matBT[j][i] =  B[(i*8+j)*14+:14];
                        matC[i][j] = 11'd0;
                        matTemp[i][j] = 11'd0;
                    end 
                end
                //re-initalize registers before the start of multiplication.
                first_cycle = 0;
                end_of_mult1 = 0;
                end_of_mult2 = 0;
                temp = 0;
                i = 0;
                j = 0;
                k = 0;
            end
            else if(end_of_mult1 == 0 && end_of_mult2 == 0) begin
                /*Multiplication will happen when Reset equals 0, Enable equls 1, first_cycle equals 0 
                  and end_of_mult1 equals 0   
                  Remember, we can't use For loop here because for loops used for computation are not synthesizable*/
						temp2 = matA[k][j] - 128;
                temp = (matB[i][k]*(temp2))/10000;
                matTemp[i][j] = matTemp[i][j] + temp[10:0];    //Lower half of the product is accumulatively added to form the result.
                if(k == 7) begin
                    k = 0;
                    if(j == 7) begin
                        j = 0;
                        if (i == 7) begin
                            i = 0;
                            end_of_mult1 = 1;
                            temp = 0;
                        end
                        else
                            i = i + 1;
                    end
                    else
                        j = j+1;    
                end
                else
                    k = k+1;
            end
            else if(end_of_mult2 == 0 && end_of_mult1 == 1 ) begin  //Multiplication of resultant matrix and transpose matrix of B
            temp = (matTemp[i][k]*matBT[k][j])/10000;
            matC[i][j] = matC[i][j] + temp[10:0];   //Lower half of the product is accumulatively added to form the result.
            if(k == 7) begin
                    k = 0;
                    if(j == 7) begin
                        j = 0;
                        if (i == 7) begin
                            i = 0;
                            end_of_mult2 = 1;
                        end
                        else
                            i = i + 1;
                    end
                    else
                        j = j+1;    
                end
                else
                    k = k+1;
            end
            else if(end_of_mult1 == 1 && end_of_mult2 == 1) begin     //End of multiplication has reached
                //convert 8 by 8 matrix into a 1-D matrix.
                for(i=7;i>=0;i=i-1) begin   //run through the rows
                    for(j=7;j>=0;j=j-1) begin    //run through the columns
                        C[(i*8+j)*11+:11] = matC[i][j];
                    end
                end   
               enable2 = 1;   //Set this output High, to say that C has the final result.
            end
    end
end
endmodule
