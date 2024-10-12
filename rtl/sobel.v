
module sobel(in,start,clk,rst,Gxout,Gyout);

parameter SIZE = 482*2+3;

input [7:0] in;
input start;
input clk,rst;

output reg  [7:0]  Gxout ;
output reg  [7:0]  Gyout ;

reg signed [8:0] Gx,Gy;
reg [7:0] linebuffer [0:SIZE-1];
reg [7:0] pad_data [0:SIZE-1];
reg [7:0] data_in;
integer i;



	
//linebuffe
always@(negedge clk,posedge rst)begin
	if(rst)begin	  
	  for(i=0;i<SIZE;i=i+1)begin
		linebuffer[i] <= 0;
	  end	  
	end
	else begin
		  for(i=1;i<SIZE;i=i+1)begin
			linebuffer[i] <= linebuffer[i-1];
		  end
		    linebuffer[0] <= in;		  
	end
	
end


//convolution
always@(*)begin
	if(start)begin
		Gx = -1*linebuffer[2]      + 0*linebuffer[1]       + 1*linebuffer[0]      
			+ -2*linebuffer[2+482]   + 0*linebuffer[1+482]   + 2*linebuffer[0+482]  
			+ -1*linebuffer[2+482*2] + 0*linebuffer[1+482*2] + 1*linebuffer[0+482*2];
																								  
		Gy = 1*linebuffer[2]      + 2*linebuffer[1]      + 1*linebuffer[0]      
			+  0*linebuffer[2+482]   + 0*linebuffer[1+482]   + 0*linebuffer[0+482]  
			+  -1*linebuffer[2+482*2] + -2*linebuffer[1+482*2] + -1*linebuffer[0+482*2];								
	end
	else begin
		Gx = 0;
		Gy = 0;	
	end

end

//2 norm
always@(posedge clk,posedge rst)begin
	if(rst)begin
		Gxout    <= 0;
		Gyout    <= 0;
	end
	else begin
		if(start)begin
			Gxout <= (Gx > 100)? 8'd255:0;						  
			Gyout <= (Gy > 100)? 8'd255:0;				 						   
		end
		else begin
		    Gxout   <= 0;
		    Gyout   <= 0;
	    end
	end

end


endmodule
