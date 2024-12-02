class counter_write_mon;

counter_trans wrdata;
counter_trans data2rm;

virtual counter_if.WR_MON_MP wr_mon_if;

mailbox#(counter_trans)wr2rm;

function new(virtual counter_if.WR_MON_MP wr_mon_if,
		mailbox#(counter_trans)wr2rm);
	
	wrdata=new;
	this.wr_mon_if=wr_mon_if;
	this.wr2rm=wr2rm;
endfunction: new

virtual task monitor();
	repeat(2)
	
	@(wr_mon_if.wr_mon_cb);
	wrdata.mode=wr_mon_if.wr_mon_cb.mode;
	wrdata.data_in=wr_mon_if.wr_mon_cb.data_in;
	wrdata.load=wr_mon_if.wr_mon_cb.load;
	wrdata.rest=wr_mon_if.wr_mon_cb.rest;
	wrdata.display("from write monitor");
endtask: monitor


virtual task start();
	fork
	    forever
		begin
		    monitor();
		    data2rm=new wrdata;
		    wr2rm.put(data2rm);
		end
	join_none
endtask: start
endclass
		    	
