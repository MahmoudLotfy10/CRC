module CRC #(
    parameter data_width=8,
    parameter [data_width-1:0]seed = 8'hD8,
    parameter [data_width-1:0]tabs = 8'b01000100
) (
    input      clk,rst,
    input      data, active,
    output reg crc,valid
);
    reg [data_width-1:0] lfsr;

    wire fb;
    assign fb = lfsr[0] ^ data;

    //the counter wil count in worst case 32 cycle so we need 5 bits
    reg [4:0]counter; 
    wire counter_done;
    assign counter_done = (counter==data_width);
     
    integer i;
    always @(posedge clk , negedge rst) begin
        if (!rst)
        begin
            lfsr<=seed;
            valid<=0;
            crc<=0;
            counter<=data_width;
        end
        else if(active)
        begin
            valid<=0;
            counter<=0;
            lfsr[7] <= fb;
            for(i=0; i<data_width-1; i=i+1)
            begin
                if(tabs[i]==1)
                lfsr[i] = lfsr[i+1] ^ fb;
                else
                lfsr[i] = lfsr[i+1] ;
            end
            
            /*
            lfsr[0] <= lfsr[1];
            lfsr[1] <= lfsr[2];
            lfsr[2] <= fb ^ lfsr[3];
            lfsr[3] <= lfsr[4];
            lfsr[4] <= lfsr[5];
            lfsr[5] <= lfsr[6];
            lfsr[6] <= fb ^ lfsr[7];
            lfsr[7] <= fb;
            */
        end
        else if(!counter_done && !active)
            begin
            valid<=1;
            {lfsr,crc} <= {1'b0,lfsr};
            /* 
            crc<=lfsr[0];
            lfsr[0]<=lfsr[1];
            lfsr[1]<=lfsr[2];
            lfsr[2]<=lfsr[3];
            lfsr[3]<=lfsr[4];
            lfsr[4]<=lfsr[5];
            lfsr[6]<=lfsr[7];
            lfsr[7]<=0; */
            counter<= counter+1;
            end
            else
            begin
                crc<=0;
                valid<=0;
                counter<=counter;
            end

        end
    

endmodule