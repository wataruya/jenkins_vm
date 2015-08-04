module xor_module (clk,xor_in1,xor_in2,xor_out);
   input     clk;
   input     xor_in1,xor_in2;    
   output    xor_out;        
   reg       xor_out;
   
   always @(posedge clk) begin 
      xor_out = (xor_in1 ^ xor_in2);
   end
   
endmodule

