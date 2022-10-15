
module idct
    (   input Clock,
        input reset, 
        input Enable,    
        input [703:0] A,
        output reg [575:0] C,
        output reg done    
    );   


reg signed [10:0] matA [7:0][7:0];
reg signed [13:0] matB [7:0][7:0];
reg signed [13:0] matBT [7:0][7:0];
reg signed [10:0] matTemp [7:0][7:0];     
reg signed [10:0] matC [7:0][7:0];
reg [895:0] coeff;

integer signed i,j,k;  
reg first_cycle;    
reg end_of_mult1;    
reg end_of_mult2;    
reg signed [10:0] temp; 


always @(posedge Clock or posedge reset)    
begin
    if(reset == 1) begin    
        i = 0;
        j = 0;
        k = 0;
        temp = 0;
        first_cycle = 1;
        end_of_mult1 = 0;
        end_of_mult2 = 0;
        done = 0;
        
        for(i=0;i<=7;i=i+1) begin
            for(j=0;j<=7;j=j+1) begin
                matA[i][j] = 11'd0;
                matB[i][j] = 14'd0;
                matBT[i][j] = 14'd0;
                matC[i][j] = 11'd0;
                matTemp[i][j] = 11'd0;
            end 
        end 
    end
    else begin  
        if(Enable == 1)     
            if(first_cycle == 1) begin    
                
                coeff = {14'd3536,14'd3536,14'd3536,14'd3536,14'd3536,14'd3536,14'd3536,14'd3536,
                         14'd4904,14'd4157,14'd2778,14'd975,-14'd975,-14'd2778,-14'd4157,-14'd4904,
                         14'd4619,14'd1913,-14'd1913,-14'd4619,-14'd4619,-14'd1913,14'd1913,14'd4619,
                         14'd4157,-14'd975,-14'd4904,-14'd2778,14'd2778,14'd4904,14'd975,-14'd4157,
                         14'd3536,-14'd3536,-14'd3536,14'd3536,14'd3536,-14'd3536,-14'd3536,14'd3536,
                         14'd2778,-14'd4904,14'd975,14'd4157,-14'd4157,-14'd975,14'd4904,-14'd2778,
                         14'd1913,-14'd4619,14'd4619,-14'd1913,-14'd1913,14'd4619,-14'd4619,14'd1913,
                         14'd975,-14'd2778,14'd4157,-14'd4904,14'd4904,-14'd4157,14'd2778,-14'd975};

                for(i=0;i<=7;i=i+1) begin
                    for(j=0;j<=7;j=j+1) begin
                        matA[i][j] =  A[(i*8+j)*11+:11] ;   
                        matB[i][j] =  coeff[(i*8+j)*14 +: 14];
                        matBT[j][i] = coeff[(i*8+j)*14 +: 14];
                        matC[i][j] = 11'd0;
                        matTemp[i][j] = 11'd0;
                    end 
                end
                
                first_cycle = 0;
                end_of_mult1 = 0;
                end_of_mult2 = 0;
                temp = 0;
                i = 0;
                j = 0;
                k = 0;
            end
            else if(end_of_mult1 == 0 && end_of_mult2 == 0) begin
                
                temp = (matBT[i][k]*matA[k][j])/10000;
                matTemp[i][j] = matTemp[i][j] + temp[10:0];    
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
            else if(end_of_mult2 == 0 && end_of_mult1 == 1 ) begin  
            temp = (matTemp[i][k]*matB[k][j])/10000;
            matC[i][j] = matC[i][j] + temp[10:0];   
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
            else if(end_of_mult1 == 1 && end_of_mult2 == 1) begin     
                for(i=0;i<=7;i=i+1) begin   
                    for(j=0;j<=7;j=j+1) begin   
                        C[(i*8+j)*9+:9] = (matC[i][j]+128);
                    end
                end   
                done = 1;   
            end
    end
end
endmodule
