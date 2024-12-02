class counter_rm;

counter_trans wrmon_data,refmod2sb;;

static bit [3:0] count_out;

mailbox#(counter_trans)wr2rm;
mailbox#(counter_trans)rm2sb;

function new(mailbox#(counter_trans)wr2rm,
				mailbox#(counter_trans)rm2sb);
			this.wr2rm=wr2rm;
			this.rm2sb=rm2sb;
			refmod2sb=new;
endfunction: new

virtual task mode_counter (counter_trans wrmon_h);
	if(wrmon_h.rest == 1)
		count_out <= 4'b0000;
	else 
		if(wrmon_data.load)
			count_out <= wrmon_h.data_in;
		else
			if(wrmon_h.mode == 1)
				if(count_out >= 4'b1101)
					count_out <= 4'b0000;
				else
					count_out=count_out+1'b1;
			else
				if(count_out == 4'b0000)
					count_out <= 4'b1101;
				else
					count_out=count_out-1'b1;
endtask: mode_counter	


virtual task start();
fork	
			forever
				begin
					wr2rm.get(wrmon_data);
					mode_counter(wrmon_data);
					refmod2sb.data_out= count_out;
					rm2sb.put(refmod2sb);
				end
join_none
endtask: start

endclass
					
