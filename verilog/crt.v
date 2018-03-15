module CRT (/*AUTOARG*/
   // Outputs
   h_sync, v_sync, video,
   // Inputs
   clk_in, rst
   );
   input clk_in;
   input rst;
   output h_sync;
   output v_sync;
   output video;

    parameter h_pixels			= 704;
    parameter param_quick_num		= 22;
    parameter h_offset			= 14;
    parameter h_sync_len		= 288;
    parameter h_vid_offset		= 192;
    parameter h_vid_after_length	= 110;

    parameter v_pixels			= 370;
    parameter v_offset			= 28;
    parameter v_sync_len		= 4;
    parameter vid_offset		= 28;
    parameter v_vid_len			= 2;

    parameter total_dots		= 260480;

   wire   clk = clk_in;
   wire   newframe;
    

   reg [19:0]	  count;
   reg [15:0]	  v_count;
   reg [15:0]	  h_count;
    
    assign newframe = count == 8;
    assign h_sync = 
		    (h_count <= (h_vid_offset + h_vid_after_length) &&
		     h_count >= h_offset + 1) 
      ? 0 : 1 ;

    assign video = clk_in;
    assign v_sync = (v_count >= 1 & v_count < vid_offset) ? 0 : 1; 

    always @(posedge clk) begin
	if(rst) begin
	    /*AUTORESET*/
	    // Beginning of autoreset for uninitialized flops
	    count <= 1'h0;
	    h_count <= 1'h0;
	    v_count <= 1'h0;
	    // End of automatics
	end
	else begin
	    if(count < total_dots)
	      count <= count + 1;
	    else begin
		count <= 1;
		v_count <= 1;
	    end // else: !if(count < total_dots)
	   if (h_count < h_pixels)
	     h_count <= h_count + 1;
	   else begin
	       h_count <= 1;
	       //if(count < total_dots)
	       // The previous line found in CRT.vhd was replaced
	       // to allow v_count to be proven to be less than v_pixels
	       if(v_count < v_pixels)
		 v_count <= v_count + 1;
	   end // else: !if(h_count < h_pixels)
	end // else: !if(rst)
    end // always @ (posedge clk)

`ifdef FORMAL
    initial begin
	assume(rst == 1);
	assume(count == 0);
	assume(h_count == 0);
	assume(v_count == 0);
    end
    
    always @(posedge clk) begin
	assert(count <= total_dots);
	assert(h_count <= h_pixels);
	assert(v_count <= v_pixels);
    end

    assert property(newframe == (count == 8));
    always @(posedge clk)
      cover(h_count == 100);
    
`endif
    
    
	  
	  

endmodule // CRT

	
   
