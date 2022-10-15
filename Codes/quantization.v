//8 by 8 matrix Division. Each element of the matrix is 8 bit wide. 
//Inputs are named A and B and output is named as C. 
//Each matrix has 64 elements each of which is 8 bit wide. So the inputs is 512 bit long.
module quantization
    (   input Clock,
        input reset, //active high reset
        input Enable,    //This should be High throughout the quantization process.
        input [703:0] A,
        output reg [511:0] C,
        output reg done     //A High indicates that division is done and result is availble at C.
    );   

//temperory registers. 
reg [511:0] B;
reg signed [10:0] matA [7:0][7:0]; //To store the result from DCT
reg signed [7:0] matB [7:0][7:0]; //To store the quantization matrix
reg signed [7:0] matC [7:0][7:0]; //To store the result


integer signed i,j;  //loop indices
reg first_cycle;    //indicates its the first clock cycle after Enable went High.
reg end_of_div;    //indicates division has ended.

//Quantization
always @(posedge Clock or posedge reset)    
begin
    if(reset == 1) begin    //Active high reset
        i = 0;
        j = 0;
        first_cycle = 1;
        end_of_div = 0;
        done = 0;
        //Initialize all the matrix register elements to zero.
        B = {8'd16,8'd11,8'd10,8'd16,8'd24,8'd40,8'd51,8'd61,
         8'd12,8'd12,8'd14,8'd19,8'd26,8'd58,8'd60,8'd55,
         8'd14,8'd13,8'd16,8'd24,8'd40,8'd57,8'd69,8'd56,
         8'd14,8'd17,8'd22,8'd29,8'd51,8'd87,8'd80,8'd62,
         8'd18,8'd22,8'd37,8'd56,8'd68,8'd109,8'd103,8'd77,
         8'd24,8'd35,8'd55,8'd64,8'd81,8'd104,8'd113,8'd92,
         8'd49,8'd64,8'd78,8'd87,8'd103,8'd121,8'd120,8'd101,
         8'd72,8'd92,8'd95,8'd98,8'd112,8'd100,8'd103,8'd99};
        for(i=0;i<=7;i=i+1) begin
            for(j=0;j<=7;j=j+1) begin
                matA[i][j] = 11'd0;
                matB[i][j] = 8'd0;
                matC[i][j] = 8'd0;
            end 
        end 
    end
    else begin  //for the positve edge of Clock.
        if(Enable == 1)     //Any action happens only when Enable is High.
            if(first_cycle == 1) begin     //the very first cycle after Enable is high.
                //the matrices which are in a 1-D array are converted to 2-D matrices first.
                for(i=0;i<=7;i=i+1) begin
                    for(j=0;j<=7;j=j+1) begin
                        matA[i][j] =  A[(i*8+j)*11+:11];   
                        matB[i][j] =  B[(i*8+j)*8+:8];
                        matC[i][j] = 8'd0;
                    end 
                end
                //re-initalize registers before the start of multiplication.
                first_cycle = 0;
                end_of_div = 0;
                i = 0;
                j = 0;
            end
            else if(end_of_div == 0) begin
                /*Division will happen when Reset equals 0, Enable equls 1, first_cycle equals 0 
                  and end_of_div equals 0   
                  Remember, we can't use For loop here because for loops used for computation are not synthesizable*/
                matC[i][j] = (matA[i][j]/matB[i][j]);  
                
                    if(j == 7) begin
                        j = 0;
                        if (i == 7) begin
                            i = 0;
                            end_of_div = 1;
                        end
                        else
                            i = i + 1;
                    end
                    else
                        j = j + 1;    
                
            end
            else if(end_of_div == 1) begin     //End of division has reached
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