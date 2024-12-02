class counter_gen;

counter_trans gen_trans;
counter_trans data2send;

mailbox#(counter_trans)gen2wd;

function new(mailbox#(counter_trans)gen2wd);
	gen_trans=new();
	this.gen2wd=gen2wd;
endfunction: new

virtual task start();
	fork
		for(int i=0;i<number_of_transactions;i++)
			begin
				assert(gen_trans.randomize());
				data2send=new gen_trans;
				gen2wd.put(data2send);
			end
	join_none
endtask


endclass: counter_gen
				