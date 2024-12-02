class counter_trans;

rand bit [3:0] data_in;
rand bit rest;
rand bit load;
rand bit mode;


logic [3:0] data_out;

static int no_of_rest_trans;
static int no_of_load_trans;
static int no_of_upcount;
static int no_of_downcount;

constraint c1 {data_in inside {[0:13]};}
constraint c2 {rest dist{1:=50 ,0:=500};}
constraint c3 {mode dist{1:=50, 0:=50};}
constraint c4 {load dist{1:=20, 0:=500};}

function void post_randomize();
	if(this.rest==1 || this.rest==0);
		no_of_rest_trans++;
	if(this.load==1 || this.load==0);
		no_of_load_trans++;
	if(this.mode==1);
		no_of_upcount++;
	if(this.mode==0);
		no_of_downcount++;
	this.display("\tRANDOMIZED DATA");
endfunction:post_randomize

virtual function void display(input string message);
      $display("=============================================================");
      $display($time,"%s",message);
	  $display("/treset transaction no= %d",no_of_rest_trans);
	  $display("/tload transaction no= %d",no_of_load_trans);
	  $display("/tnumber of upcounts= %d",no_of_upcount);
	  $display("/tnumber of downcounts= %d",no_of_downcount);
	  $display("/tdata input= %d",data_in);
	  $display("/trest= %d",rest);
	  $display("/tload= %d",load);
	  $display("/tmode= %d",mode);
	  $display("/tdata ouput= %d",data_out);
	  $display("==============================================================");
endfunction
endclass
