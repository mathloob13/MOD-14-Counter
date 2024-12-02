class counter_env;

	virtual counter_if.WR_DRV_MP wr_drv_if;
	virtual counter_if.RD_MON_MP rd_mon_if;
	virtual counter_if.WR_MON_MP wr_mon_if; 

	mailbox #(counter_trans)gen2wd = new();

	mailbox #(counter_trans)wr2rm = new();

	mailbox #(counter_trans)rdm2sb = new();
	mailbox #(counter_trans)rm2sb = new();


	counter_gen     	gen_h;
	counter_write_drv 	wr_drv_h;
	counter_read_mon	rd_mon_h;
	counter_write_mon	wr_mon_h;
	counter_rm       	ref_mod_h;
	counter_sb              sb_h;

	function new(	virtual counter_if.WR_DRV_MP wr_drv_if,
			virtual counter_if.RD_MON_MP rd_mon_if,
			virtual counter_if.WR_MON_MP wr_mon_if);
			
		this.wr_drv_if=wr_drv_if;
		this.wr_mon_if=wr_mon_if;
		this.rd_mon_if=rd_mon_if;
		
		
	endfunction:new

	
	virtual task build();
		  gen_h      = new(gen2wd);
   	          wr_drv_h   = new(wr_drv_if,gen2wd);
                  wr_mon_h   = new(wr_mon_if,wr2rm);
                  rd_mon_h   = new(rd_mon_if,rdm2sb);
                  ref_mod_h  = new(wr2rm,rm2sb);
                  sb_h       = new(rm2sb,rdm2sb);
  	 endtask: build

	
 virtual task start;
      gen_h.start();
      wr_drv_h.start();
      wr_mon_h.start();
      rd_mon_h.start();
      ref_mod_h.start();
      sb_h.start();
   endtask: start

   virtual task stop();
      wait(sb_h.DONE.triggered);
   endtask : stop 
 
   virtual task run();
      start();
      stop();
      sb_h.report();
   endtask: run

endclass : counter_env




























