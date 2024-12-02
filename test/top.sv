module counter_top;

import counter_pkg::*;

//parameter cycle = 10;
  bit clock;
  
always #5 clock=~clock;

   counter_if DUV_IF (clock);

   counter_base base_test_h;   
   
  counter_base_extd1 base_test_h1;

   mod14_up_down_counter rtl(.clock(clock),
                 .data_in    (DUV_IF.data_in),
                 .rest       (DUV_IF.rest),
                 .mode      (DUV_IF.mode),
				 .load		(DUV_IF.load),
				 .data_out   (DUV_IF.data_out)
                ); 
   initial
	    begin
	if($test$plusargs("TEST1"))
            begin
               base_test_h = new(DUV_IF,DUV_IF,DUV_IF);
               number_of_transactions = 20;
               base_test_h.build();
               base_test_h.run();
               $finish;
            end
	if($test$plusargs("TEST2"))
            begin
               base_test_h1 = new(DUV_IF,DUV_IF,DUV_IF);
               number_of_transactions = 100;
               base_test_h1.build();
               base_test_h1.run();
               $finish;
            end
		
		end
		
endmodule:counter_top
