class counter_write_drv;

virtual counter_if.WR_DRV_MP wr_drv_if;

counter_trans data2duv;

mailbox#(counter_trans)gen2wd;

function new(virtual counter_if.WR_DRV_MP wr_drv_if,
             mailbox#(counter_trans)gen2wd);
			 
		this.wr_drv_if=wr_drv_if;
		this.gen2wd=gen2wd;
endfunction: new

virtual task drive();
begin
//	@(wr_drv_if.wr_drv_cb);
	wr_drv_if.wr_drv_cb.data_in <= data2duv.data_in;
	wr_drv_if.wr_drv_cb.rest <= data2duv.rest;
	wr_drv_if.wr_drv_cb.load <= data2duv.load;
	wr_drv_if.wr_drv_cb.mode <= data2duv.mode;
	data2duv.display("from write driver");

	@(wr_drv_if.wr_drv_cb);
end
endtask:drive
         
virtual task start();
			fork
				forever
					begin
						gen2wd.get(data2duv);
						drive();
					end
			join_none
endtask: start


endclass
