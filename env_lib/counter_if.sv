
interface counter_if(input bit clock);
   
   logic [3:0] data_in;
   logic  rest;
   logic  mode;
   logic  load;
   logic [3:0] data_out;
   
   
   //Write Driver clocking block
   clocking wr_drv_cb@(posedge clock);
      default input #1 output #1;
      output data_in;
      output rest;
	  output mode;
	  output load;
   endclocking: wr_drv_cb

   //Write monitor clocking block
   clocking wr_mon_cb@(posedge clock);
      default input #1 output #1;
      input data_in;
      input rest;
	  input mode;
	  input load;
   endclocking: wr_mon_cb
   
   //Read monitor clocking block
   clocking rd_mon_cb@(posedge clock);
      default input #1 output #1;
      input data_out;
   endclocking: rd_mon_cb

   //Write Driver modport
   modport WR_DRV_MP(clocking wr_drv_cb);

   //Write Monitor modport
   modport WR_MON_MP(clocking wr_mon_cb);

   //Read Monitor modport
   modport RD_MON_MP(clocking rd_mon_cb);
   

endinterface: counter_if

