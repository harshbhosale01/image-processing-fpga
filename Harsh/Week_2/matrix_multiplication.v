//8 by 8 matrix multiplier. Each element of the matrix is 8 bit wide. 
//Inputs are named A and B and output is named as C. 
//Each matrix has 64 elements each of which is 8 bit wide. So the inputs is 512 bit long.
module matrix_mult
    (   input Clock,
        input reset, //active high reset
        input Enable,    //This should be High throughout the matrix multiplication process.
        input [511:0] A,
        input [511:0] B,
        output reg [511:0] C,
        output reg done     //A High indicates that multiplication is done and result is availble at C.
    );   

//temperory registers. 
reg signed [7:0] matA [7:0][7:0];
reg signed [7:0] matB [7:0][7:0];
reg signed [7:0] matTemp [7:0][7:0];
reg signed [7:0] matBT [7:0][7:0];     //Transpose of B matrix
reg signed [7:0] matC [7:0][7:0];


integer i,j,k;  //loop indices
reg first_cycle;    //indicates its the first clock cycle after Enable went High.
reg end_of_mult1;    //indicates first multiplication has ended.
reg end_of_mult2;    //indicates second multiplication has ended.
reg signed [15:0] temp; //a temeporary register to hold the product of two elements.

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
        done = 0;
        //Initialize all the matrix register elements to zero.
        for(i=0;i<=7;i=i+1) begin
            for(j=0;j<=7;j=j+1) begin
                matA[i][j] = 8'd0;
                matB[i][j] = 8'd0;
                matC[i][j] = 8'd0;
                matBT[i][j] = 8'd0;
                matTemp[i][j] = 8'd0;
            end 
        end 
    end
    else begin  //for the positve edge of Clock.
        if(Enable == 1)     //Any action happens only when Enable is High.
            if(first_cycle == 1) begin     //the very first cycle after Enable is high.
                //the matrices which are in a 1-D array are converted to 2-D matrices first.
                for(i=0;i<=7;i=i+1) begin
                    for(j=0;j<=7;j=j+1) begin
                        matA[i][j] = A[(i*8+j)*8+:8] - 128 ;   //Bit slicing is used here it is same as A[((i*8+j)*8)+7 : ((i*8+j)*8)]
                        matB[i][j] = B[(i*8+j)*8+:8];
                        matBT[j][i] = B[(i*8+j)*8+:8];
                        matC[i][j] = 8'd0;
                        matTemp[i][j] = 8'd0;
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
                temp = matA[i][k]*matB[k][j];
                matTemp[i][j] = matTemp[i][j] + temp[15:0];    //Lower half of the product is accumulatively added to form the result.
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
            temp = matTemp[i][k]*matBT[k][j];
            matC[i][j] = matC[i][j] + temp[15:0];   //Lower half of the product is accumulatively added to form the result.
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
                for(i=0;i<=7;i=i+1) begin   //run through the rows
                    for(j=0;j<=7;j=j+1) begin    //run through the columns
                        C[(i*8+j)*8+:8] = matC[i][j];
                    end
                end   
                done = 1;   //Set this output High, to say that C has the final result.
            end
    end
end
endmodule
