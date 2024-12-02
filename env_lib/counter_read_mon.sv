class counter_read_mon;

counter_trans rddata;
counter_trans data2sb;

virtual counter_if.RD_MON_MP rd_mon_if;

mailbox#(counter_trans)rd2sb;

function new(virtual counter_if.RD_MON_MP rd_mon_if,
		mailbox#(counter_trans)rd2sb);
	this.rd_mon_if=rd_mon_if;
	this.rd2sb=rd2sb;
	this.rddata=new;
endfunction: new

virtual task monitor();
	repeat(2)
	@(rd_mon_if.rd_mon_cb);
	rddata.data_out=rd_mon_if.rd_mon_cb.data_out;
   	 rddata.display("DATA FROM READ MONITOR"); 
endtask: monitor

virtual task start();
	fork
	   forever
	       begin
		   monitor();
		   
		   data2sb=new rddata;
		   
		   rd2sb.put(data2sb);
		   end
	join_none
endtask:start

endclass
			
		
		 




