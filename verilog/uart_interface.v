`default_nettype none
module uart_interface(/*AUTOARG*/
   // Outputs
   ram_addr, ram_data, ram_stb,
   // Inputs
   clk, rst, uart_data, uart_data_stb
   );
   input wire clk;
   input wire rst;
   input wire [7:0] uart_data;
   input wire uart_data_stb;

    parameter RAM_BITS = 13;
    parameter NUM_COLS = 80;
    parameter NUM_ROWS = 80;

   output reg [RAM_BITS-1:0] ram_addr;
   output reg [7:0] 	     ram_data;
   output reg 		     ram_stb;

    
   reg [6:0] 		     row;
   reg [6:0] 		     col;
   reg [7:0] 		     uart_tmp;

   reg [1:0] 		     // auto enum state
			     state;

    localparam // auto enum state
      S_IDLE = 0,
      S_RX = 1;
    
    // This block receives data from the uart, stores it temporarily,
    // then forwards it on to the ram
    always @(posedge clk) begin
	if(rst) begin
	    /*AUTORESET*/
	    // Beginning of autoreset for uninitialized flops
	    ram_data <= 8'h0;
	    ram_stb <= 1'h0;
	    state <= 2'h0;
	    uart_tmp <= 8'h0;
	    // End of automatics
	end
	else begin
	    ram_stb <= 0;
	    case(state)
	      S_IDLE:
		  if(uart_data_stb)begin
		      uart_tmp <= uart_data;
		      state <= S_RX;
		  end
	      S_RX: begin
		  ram_data <= uart_tmp;
		  ram_stb <= 1;
		  state <= S_IDLE;
	      end
	      
	    endcase // case (state)
	end // else: !if(rst)
    end


    // This block handles the updating of the row and column counters,
    // as well as the ram pointer. The block keeps ram_addr =
    // row * NUM_COLS + col without a multiplier (proven)
   reg carry; //variable
    always @(posedge clk) begin
	if(rst) begin
	    /*AUTORESET*/
	    // Beginning of autoreset for uninitialized flops
	    carry <= 1'h0;
	    col <= 7'h0;
	    ram_addr <= {RAM_BITS{1'b0}};
	    row <= 7'h0;
	    // End of automatics
	end
	else begin
	    case(state)
	      S_IDLE: 
		  if(uart_data_stb) begin
		      if( uart_data != 'h0a) begin
			  if(row == NUM_COLS - 1) begin
			      row <= 0;
			      ram_addr <= 0;
			      col <= 0;
			  end
			  else begin
			      col <= 0;
			      ram_addr <= ram_addr + (NUM_COLS - col);
			      row <= row + 1;
			  end // else: !if(row == NUM_COLS - 1)
			  
			    
		      end
		      else begin
			  col <= col + 1;
			  ram_addr <= ram_addr + 1;
			  if(col == NUM_COLS - 1) begin
			      col <= 0;
			      if (row == NUM_ROWS - 1) begin
				  ram_addr <= 0; 
				  row <= 0;
			      end
			      else
				row <= row + 1;
			  end // if (col == 79)
		      end // else: !if( uart_data != 'h0a)
		  end // if (uart_data_stb)
	      endcase // case (state)
	end // else: !if(rst)
    end // always @ (posedge clk)
    
	     

    /*AUTOASCIIENUM("state", "state_ascii")*/
    // Beginning of automatic ASCII enum decoding
    reg [47:0]		state_ascii;		// Decode of state
    always @(state) begin
	case ({state})
	  (2'b1<<S_IDLE):   state_ascii = "s_idle";
	  (2'b1<<S_RX):     state_ascii = "s_rx  ";
	  default:          state_ascii = "%Error";
	endcase
    end
    // End of automatics
   
`ifdef FORMAL
    initial begin
	assume(rst == 1);
	assume(uart_data_stb == 0);
	assume(state == 0);
    end // initial begin
    


    always @(posedge clk) begin
	if(rst) begin
	    assume(uart_data_stb == 0);
	end
	
	// Assert that ram_addr == row * NUM_COLS + col
	if(!rst) begin
	    assert(col < NUM_COLS);
	    assert(row < NUM_ROWS);
	    if(state == S_IDLE) begin
		assert(ram_addr == row * NUM_COLS + col);
	    end

	    // Assert that state transitions work
	    if($past(uart_data_stb) && $past(state) == S_IDLE)
	      assert(state == S_RX);
	    if($past(state) == S_RX)
	      assert(state == S_IDLE);

	    // Make sure ram_stb is let up for at least a cycle
	    if($past(ram_stb))
	      assert(!ram_stb);

	    if(uart_data_stb)
	      assume($past(uart_data_stb) == 0 && $past(uart_data_stb,2) == 0);
	    if(uart_data_stb)
	      assert(state == S_IDLE);
	    assert(state == S_IDLE || state == S_RX);
	    
	end

    end // always @ (posedge clk)
    

`endif 
    
endmodule // uart_interface

