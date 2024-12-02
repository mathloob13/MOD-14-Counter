class counter_trans_extnd1 extends counter_trans;    
   constraint valid_random_data2 {rest inside {0,1};}
   constraint valid_random_data3 {load == 1;}
   //constraint valid_random_rd {rd_address inside {0,4095};}  
endclass : counter_trans_extnd1








class counter_base;

   virtual counter_if.WR_DRV_MP wr_drv_if; 
   virtual counter_if.RD_MON_MP rd_mon_if; 
   virtual counter_if.WR_MON_MP wr_mon_if;
   
   counter_env  env_h;
   
   function new(virtual counter_if.WR_DRV_MP wr_drv_if, 
				virtual counter_if.RD_MON_MP rd_mon_if, 
				virtual counter_if.WR_MON_MP wr_mon_if);
			this.wr_drv_if=wr_drv_if;
			this.rd_mon_if=rd_mon_if;
			this.wr_mon_if=wr_mon_if;
			env_h= new(wr_drv_if,rd_mon_if,wr_mon_if);
	endfunction: new
	
	virtual task build();
		env_h.build();
	endtask: build
	
	virtual task run();
		env_h.run();
	endtask: run
endclass: counter_base

class counter_base_extd1 extends counter_base;

	counter_trans_extnd1	count_h1;

   
   function new(virtual counter_if.WR_DRV_MP wr_drv_if, 
				virtual counter_if.RD_MON_MP rd_mon_if, 
				virtual counter_if.WR_MON_MP wr_mon_if);
			super.new(wr_drv_if,rd_mon_if,wr_mon_if);
	endfunction: new
	
	virtual task build();
		super.build();
	endtask: build
	
	virtual task run();
		count_h1 = new;
		env_h.gen_h.gen_trans = count_h1;
		super.run();		
	endtask: run
endclass: counter_base_extd1
				
