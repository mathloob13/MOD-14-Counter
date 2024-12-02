class counter_sb;

event DONE;

counter_trans rm_data;
counter_trans cov_data;
counter_trans rcvd_data;


int data_verified='0;
int rm_data_count='0;
int mon_data_count = '0;

mailbox#(counter_trans)rm2sb;
mailbox#(counter_trans)rdm2sb;


covergroup counter_coverage;
	option.per_instance = 1;

	DATA : coverpoint cov_data.data_in{bins datain = {[0:13]};}
	RESET : coverpoint cov_data.rest{bins rest={0,1};}
	LOAD : coverpoint cov_data.load{bins load={0,1};}
	MODE : coverpoint cov_data.mode{bins mode={0,1};}
	DATAOUT : coverpoint cov_data.data_out{bins dataout = {[0:13]};}
	ldXdin : cross LOAD,DATA;
endgroup: counter_coverage

function new(mailbox#(counter_trans)rm2sb,
       	         mailbox#(counter_trans)rdm2sb);

	this.rm2sb=rm2sb;
	this.rdm2sb=rdm2sb;
	counter_coverage=new();
endfunction: new


virtual task start();
	fork
	    forever begin
		fork
		begin
		    rm2sb.get(rm_data);
			rm_data_count++;
		end
		begin	
                    rdm2sb.get(rcvd_data);
			mon_data_count++;
		end
		join
		    check(rcvd_data);
		end
	join_none
endtask: start


virtual task check(counter_trans rc_data);
  	   if(rc_data.data_out == rm_data.data_out)
		$display("DATA OUT MATCHED");
	  else
		begin
		$display("DATA OUT MISMATCHED");
		cov_data= new rm_data;
		counter_coverage.sample();
		end
		
	data_verified++;

    if(data_verified == number_of_transactions)
          ->DONE;
endtask: check

virtual function void report();
	$display("------------------SCOREBOARD REPORT--------------------------\n");
	$display("/t %0d Read Data Generated, %0d Read Data Recevied, %0d Read Data Verified \n",
                                             rm_data_count,mon_data_count,data_verified);
        $display(" -------------------------------------------------------- \n ");
   endfunction: report
    
endclass: counter_sb 		    		
