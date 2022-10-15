/*Here we will find average of 4 pixels and save the result in the another matrix, instead of 4 
unique values now there will be one single value for 4 adjacent pixels*/
module chrominance_downsampling
       (input Clock,
        input reset, 
        input Enable0,
        input [511:0] Cb,
        input [511:0] Cr,
        output reg [511:0] Cb_d,
        output reg [511:0] Cr_d,
        output reg enable1);
        
reg  [7:0] matCb_d [7:0][7:0];  //To save the final result
reg  [7:0] matCr_d [7:0][7:0];
reg  [7:0] matCb [7:0][7:0];    //To save the 1D to 2D results 
reg  [7:0] matCr [7:0][7:0];
reg  [9:0] temp1;
reg  [9:0] temp2;
reg done1;
reg done2;
integer i,j,m,n;
reg first_cycle1; 
reg first_cycle2; 
reg end_of_mean1;
reg end_of_mean2;

always @(posedge Clock or posedge reset)
begin
    enable1 = (done1 && done2);
end
always @(posedge Clock or posedge reset) //Blue chrominance downsampling block
begin
    if(reset == 1) begin    //Active high reset
        i = 0;
        j = 0;
        temp1=0;
        end_of_mean1 = 0;
        first_cycle1=1;
        done1 = 0;
        //Initialize all the matrix register elements to zero.
        for(i=0;i<=7;i=i+1) begin
            for(j=0;j<=7;j=j+1) begin
                matCb[i][j] = 8'd0;
                matCb_d[i][j] = 8'd0;
            end         
        end
    end  
    else begin
        if(Enable0 == 1)     //Any action happens only when Enable is High.
             if(first_cycle1==1)begin
                //the matrices which are in a 1-D array are converted to 2-D matrices first.
                for(i=0;i<=7;i=i+1) begin
                    for(j=0;j<=7;j=j+1) begin
                        matCb_d[i][j] =  Cb[(i*8+j)*8+:8] ;   //Bit slicing is used here it is same as A[((i*8+j)*8)+7 : ((i*8+j)*8)]
                        matCb[i][j] = 8'd0;
                    end 
                end
                first_cycle1=0;
                end_of_mean1 = 0;
                i = 0;
                j = 0;
                temp1[9:0]=0;
             end
             else if(end_of_mean1==0) begin
                temp1=(matCb_d[i][j]+matCb_d[i][j+1]+matCb_d[i+1][j]+matCb_d[i+1][j+1]); //Adding the four values to find their mean
                matCb[i][j]=temp1[9:2]; //Removing two end bits, that is equivalent to dividing by 4
                matCb[i][j+1]=temp1[9:2];
                matCb[i+1][j]=temp1[9:2];
                matCb[i+1][j+1]=temp1[9:2];

                if(j == 6) begin
                        j = 0;
                        if (i == 6) begin
                            i = 0;
                            end_of_mean1 = 1;  
                        end
                        else
                            i = i + 2;
                            temp1=0;
                end
                else
                    j = j + 2;
                    temp1=0;
            end

            else if(end_of_mean1==1)begin //Converting the 2D matrix to 1D matrix
                for(i=0;i<=7;i=i+1) begin   //run through the rows
                    for(j=0;j<=7;j=j+1) begin    //run through the columns
                        Cb_d[(i*8+j)*8+:8] = matCb[i][j];
                    end
                end   
                done1 = 1;   //Set this output High, to say that C has the final result.
            end
    end
end

always @(posedge Clock or posedge reset)//Red chrominance downsampling block
begin
    if(reset == 1) begin    //Active high reset
        m = 0;
        n = 0;
        temp2=0;
        end_of_mean2 = 0;
        first_cycle2=1;
        done2 = 0;
        //Initialize all the matrix register elements to zero.
        for(m=0;m<=7;m=m+1) begin
            for(n=0;n<=7;n=n+1) begin
                matCr[m][n] = 8'd0;
                matCr_d[m][n] = 8'd0;
            end         
        end
    end  
    else begin
        if(Enable0 == 1)     //Any action happens only when Enable is High.
             if(first_cycle2==1)begin
                //the matrices which are in a 1-D array are converted to 2-D matrices first.
                for(m=0;m<=7;m=m+1) begin
                    for(n=0;n<=7;n=n+1) begin
                        matCr_d[m][n] =  Cr[(m*8+n)*8+:8] ;   //Bit slicing is used here it is same as A[((i*8+j)*8)+7 : ((i*8+j)*8)]
                        matCr[m][n] = 8'd0;
                    end 
                end
                first_cycle2=0;
                end_of_mean2 = 0;
                m=0;
                n=0;
                temp2=0;
             end
             else if(end_of_mean2==0) begin
                temp2=(matCr_d[m][n]+matCr_d[m][n+1]+matCr_d[m+1][n]+matCr_d[m+1][n+1]); //Adding the four values to find their mean
                matCr[m][n]=temp2[9:2]; //Removing two end bits, that is equivalent to dividing by 4
                matCr[m][n+1]=temp2[9:2];
                matCr[m+1][n]=temp2[9:2];
                matCr[m+1][n+1]=temp2[9:2];

                if(n == 6) begin
                        n = 0;
                        if (m == 6) begin
                            m = 0;
                            end_of_mean2 = 1;
                            
                        end
                        else
                            m = m + 2;
                            temp2=0;
                end
                else
                    n = n + 2;
                    temp2=0;
            end

            else if(end_of_mean2==1)begin  //Converting the 2D matrix to 1D matrix
                for(m=0;m<=7;m=m+1) begin   //run through the rows
                    for(n=0;n<=7;n=n+1) begin    //run through the columns
                        Cr_d[(m*8+n)*8+:8] = matCr[m][n];
                    end

                end   
                done2 = 1;   //Set this output High, to say that C has the final result.
            end
    end
end
endmodule