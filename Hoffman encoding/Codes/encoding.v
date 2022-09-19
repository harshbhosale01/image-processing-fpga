module encode(input Clock,
        input reset, //active high reset
        input Enable,
        input [511:0] A, //Input matrix in 1D form 
        output reg [511:0] C, //Output encoded string
        output reg done //To state the testbench that output is ready
        );
reg [511:0] D;
integer i,j,count1,count2;
reg [511:0] B;
reg [6:0] r; //To count the run-length, that is number of zeros before a non-zero coefficient
reg first_cycle; //To initialise all values 

always @(posedge Clock or posedge reset)
begin
    if(reset == 1) begin    //Resetting all the parameters to default values when reset id high
        i <= 0;
        j <= 0;
        first_cycle <= 1;
        done <= 0;
        count1<=0;
        count2<=0; 
        r <= 7'd0;
    end
    else begin
        if(Enable==1)
            if(first_cycle==1) begin
                B <= {8'd0,8'd1,8'd8,8'd16,8'd9,8'd2,8'd3,8'd10,
                      8'd17,8'd24,8'd32,8'd25,8'd18,8'd11,8'd4,8'd5,
                      8'd12,8'd19,8'd26,8'd33,8'd40,8'd48,8'd41,8'd34,
                      8'd27,8'd20,8'd13,8'd6,8'd7,8'd14,8'd21,8'd28,
                      8'd35,8'd42,8'd49,8'd56,8'd57,8'd50,8'd43,8'd36,
                      8'd29,8'd22,8'd15,8'd23,8'd30,8'd37,8'd44,8'd51,
                      8'd58,8'd59,8'd52,8'd45,8'd38,8'd31,8'd39,8'd46,
                      8'd53,8'd60,8'd61,8'd54,8'd47,8'd55,8'd62,8'd63};
                //re-initalize registers before the start of encoding
                first_cycle <= 0;
                i <= 0;
                j <= 0;
                done = 0;
                count1=0;
                count2=0;
                r <= 7'd0;
            end
            else if(first_cycle==0) begin
                
            if(A[(B[count1*8 +: 8]*8) +: 8] == 0) begin
                r = r+1;
                D[(count2)*8 +: 7] = r;
                D[((count2+1)*8 -1)] = 1'b1;
                count1=count1+1;
                if(A[(B[count1*8 +: 8]*8) +: 8] != 0)begin
                    count2=count2+1;
                    r <= 7'b0;
                end
            end
            else begin
                D[(count2)*8 +: 7] = A[(B[count1*8 +: 8]*8) +: 7]; 
                D[((count2+1)*8 -1)] = 1'b0;
                count1=count1+1;
                count2=count2+1;
            end

            if(count1==64) begin
                C[511:0] <= D[511:0];
                done <= 1;
            end
        end
    end
end
endmodule