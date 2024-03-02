`timescale 1ns/1ps
module CRC_tb #(
    parameter data_width=8,
    parameter [data_width-1:0]seed = 8'hd8 
) ();

   reg clk_tb,rst_tb;
   reg data_tb,active_tb;
   wire crc_tb,valid_tb;
   
   CRC #(.data_width(data_width),.seed(seed))dut (
         .clk(clk_tb),
         .rst(rst_tb),
         .data(data_tb),
         .active(active_tb),
         .crc(crc_tb),
         .valid(valid_tb)
    
   ); 

always #50 clk_tb=~clk_tb;

parameter depth=10,
          all_test_casaes=10,
          period=100;

reg [data_width-1:0] mem   [depth-1:0];
reg [data_width-1:0] check [depth-1:0];



initial begin
   $dumpfile("CRC.vcd");
   $dumpvars;
   $readmemh("DATA_h.txt",mem); 
   $readmemh("Expec_Out_h.txt",check); 


    initialization();
    do_operations();


   #(4*period)
   $stop;
end



task initialization;
begin
   clk_tb=0;
   data_tb=0;
   active_tb=0; 
   rst_tb=1;
end
endtask

task RST;
begin
    rst_tb=0;
    #50
    rst_tb=1;
end
endtask




task take_data;
input [4:0]depth_t;
integer i;
begin
    active_tb=1;
    $display("**********************************************************************************************");
    $display("Read data from mem[%0d]",depth_t);
    for(i=0; i<data_width; i=i+1)
    begin
         data_tb = mem[depth_t][i];
        $display("Read data from mem[%0d][%0d]: %b", depth_t, i, data_tb);
        #period;
    end
    $display("The Read Data is %h",mem[depth_t]);
    active_tb=0;
end
endtask




task test;
input [4:0]depth_test;
reg done;
integer n;
reg [data_width-1:0] crc_out;
begin
    $display("********Test case %0d*********",depth_test+1);
    done=1;
    for(n=0; n<data_width; n=n+1)
    begin
        #period
            crc_out[n]=crc_tb;
            if(crc_tb == check[depth_test][n])
            $display("the crc bit is %b is equal to bit number %0d and the bit in Expected output is %b ",crc_tb,n,check[depth_test][n]);
            else
            begin
            done=0;
            $display("the crc bit is %b isn't equal to bit number %0d and the bit in Expected output is %b ",crc_tb,n,check[depth_test][n]);
            end
    end
    if(done) begin
    $display("the crc bits %h equal to expected ouput %h",crc_out,check[depth_test]);
    $display("test case %0d is passed",depth_test+1);
    end
    else
    $display("test case %0d is failed",depth_test+1);

    $display("**********************************************************************************************");

end
endtask


task do_operations;
integer test_case;
begin
for (test_case =0 ; test_case < all_test_casaes; test_case = test_case + 1 ) 
  begin
    RST();
    take_data(test_case);
    test(test_case);
  end   
end
endtask



endmodule