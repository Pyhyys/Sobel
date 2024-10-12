`timescale 1ns / 1ns
`define period          10
`define img_max_size    480*360*3+54
//---------------------------------------------------------------
//You need specify the path of image in/out
//---------------------------------------------------------------
`define path_img_in     "./picture/cat.bmp"
`define path_img_black   "./picture/cat_black.bmp"
`define path_img_outgx    "./picture/Gx_cat_after_sobel.bmp"
`define path_img_outgy    "./picture/Gy_cat_after_sobel.bmp"


module HDL_HW4_TB;
	parameter SIZE = 482*2+3; //linebuffer full capacity
    
	integer img_in;
	integer img_black;
	integer img_outgx;
	integer img_outgy;
    integer offset;
    integer img_h;
    integer img_w;
    integer idx;
    integer header;
 	integer index ; //index for 1D array of pad_data1 
	integer start; //control when to write
    integer i,j;
	integer count;  //count number of input datas 
	
	reg         clk;
	reg         rst;
    reg  [7:0]  img_data [0:`img_max_size-1];
	reg  [7:0]  pad_data [0:481][0:361];
	reg  [7:0]  pad_data1 [0:482*362-1];
	//reg signed [8:0]  Gx ;
	//reg signed [8:0]  Gy ;
	wire [7:0]  Gxout ;
	wire [7:0]  Gyout ;
	//reg  [7:0]  thr;
    reg  [7:0]  R;
    reg  [7:0]  G;
    reg  [7:0]  B;
    reg [19:0] Y;
	reg [7:0] data_in;
	
	
	
    //---------------------------------------------------------------
    //Insert your  verilog module at here
    //
    sobel u_sobel(.in(data_in),.start(start),.clk(clk),.rst(rst),.Gxout(Gxout),.Gyout(Gyout));
    //
    //---------------------------------------------------------------


//---------------------------------------------------------------------------------------Take out the color image(cat) of RGB----------------------------------------------
    
 	//create padding zero
	initial begin
	
	  for(i=0;i<482;i=i+1)begin
		for(j=0;j<362;j=j+1)begin
			pad_data[i][j] <= 8'b0;
		end
	  end
	  
	  for(i=0;i<482*362;i=i+1)begin
			pad_data1[i] <= 8'b0;
	  end 

	end
	


	//---------------------------------------------------------------
    //This initial block write the pixel 
    //---------------------------------------------------------------
    initial begin
        clk = 1'b1;
		start =0;
		rst = 1;
		data_in = 0;
    #(`period*10)

		for(idx = 0; idx < (img_h)*(img_w); idx = idx+1) begin
            R = img_data[idx*3 + offset + 2];
            G = img_data[idx*3 + offset + 1];
            B = img_data[idx*3 + offset + 0];
		  //-------------------------prompt--------------------------------
          

			Y = 0.299*R +  0.587*G +  0.114*B;

			//black image data to padding
			i = idx%480;
			j = idx/480;
			pad_data[i+1][j+1] = Y[7:0];
				
			//write black image data
			$fwrite(img_black, "%c%c%c", Y[7:0], Y[7:0], Y[7:0]);
		
			
		  //---------------------------------------------------------------

        #(`period);
        end
		
		//insert pad data (success)
		index =0;
		for(j=0;j<362;j=j+1)begin
			for(i=0;i<482;i=i+1)begin		
				pad_data1[index] = pad_data[i][j];				
				index = index+1;
			end
		end		
//-----------------------------------		
		//input data to u_sobel(success)
		$display(" -start");
		count = 0;
		rst = 0;
		#(`period)
		
		for(idx=0;idx<482*362;idx=idx+1)begin		
			data_in = pad_data1[idx];
			count = count+1;		  
		  if(count >= SIZE) start = 1;
		  else start = 0;
		  
		#(`period);
			//wriete output image data(success)
			if(start)begin
				if( !(count%483 == 481 || count%483 == 482) )begin
					$fwrite(img_outgx, "%c%c%c", Gxout,Gxout,Gxout);
					$fwrite(img_outgy, "%c%c%c", Gyout,Gyout,Gyout);
				end
			end
		end

		$display(" -write end");
		
//-----------------------------------		
			
    #(`period)
        $fclose(img_in);
		$fclose(img_outgx);
		$fclose(img_outgy);
		$fclose(img_black);
		$finish;
    end

    //---------------------------------------------------------------
    //This initial block read the pixel 
    //---------------------------------------------------------------
    initial begin
        img_in  = $fopen(`path_img_in, "rb");
		img_black = $fopen(`path_img_black, "wb");
		img_outgx = $fopen(`path_img_outgx, "wb");
		img_outgy = $fopen(`path_img_outgy, "wb");

        $fread(img_data, img_in);

        img_w   = {img_data[21],img_data[20],img_data[19],img_data[18]};
        img_h   = {img_data[25],img_data[24],img_data[23],img_data[22]};
        offset  = {img_data[13],img_data[12],img_data[11],img_data[10]};


        for(header = 0; header < 54; header = header + 1) begin
			$fwrite(img_black, "%c", img_data[header]);
			$fwrite(img_outgx, "%c", img_data[header]);
			$fwrite(img_outgy, "%c", img_data[header]);
        end
    end
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    always begin
		#(`period/2.0) clk <= ~clk;
	end

    /*
    initial begin
		$sdf_annotate (`path_sdf, <your instance name>);
	end
    */
	// initial begin
		// $fsdbDumpfile(`FSDB);
		// $fsdbDumpvars;
		// $fsdbDumpMDA;
	// end
	
endmodule