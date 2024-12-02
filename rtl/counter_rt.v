module mod14_up_down_counter(clock,rest,mode,load,data_in,data_out);
input clock;
input rest;
input load;
input [3:0]data_in;
output reg [3:0]data_out;
input mode;
always@(posedge clock)
	begin
		if (rest)
			data_out <= 4'd0;
		else if (load)
			data_out <= data_in;
		else 
		    begin 
			    if (mode)
				begin	
					if (data_out == 4'b1101)
					    data_out <= 4'd0;
					else
						data_out <= data_out+1'b1;
				end
				else
				begin
					if(data_out == 4'b0000)
						data_out <= 4'b1101;
					else
						data_out <= data_out-1'b1;
				end
			end
	end
endmodule
