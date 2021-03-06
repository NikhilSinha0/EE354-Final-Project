///////////////////
// File Name:   VGA Tutorial
// Author   :   Da Cheng
// Course   :   EE201 
///////////////////
// timing diagram for the horizontal synch signal (HS)
// 0                       655    752           800 (pixels)
// -------------------------|______|-----------------
// timing diagram for the vertical synch signal (VS)
// 0                                 490    491  525 (lines)
// -----------------------------------|______|-------

module hvsync_generator(clk, reset,vga_h_sync, vga_v_sync, inDisplayArea, CounterX, CounterY, x, y);
input clk;
input reset;
output vga_h_sync, vga_v_sync;
output inDisplayArea;
output [9:0] CounterX;
output [9:0] CounterY;
output [5:0] x;
output [5:0] y;

//////////////////////////////////////////////////
reg [9:0] CounterX;
reg [9:0] CounterY;
reg [5:0] x;
reg [5:0] y;
reg vga_HS, vga_VS;
reg inDisplayArea;
//increment column counter
always @(posedge clk)
begin
   if(reset) begin
      CounterX <= 0;
		x <= 0;
		end
   else if(CounterX==10'h320) begin
	   CounterX <= 0;
		x <= 0;
		end
   else begin
	   CounterX <= CounterX +1;
		if (CounterX[3:0] == 4'b0000)
			x <= x + 1;
		end
end
//increment row counter
always @(posedge clk)
begin
   if(reset) begin
      CounterY<=0; 
		y <= 0;
		end
   else if(CounterY==10'h209) begin   //521
      CounterY<=0;
		y <= 0;
		end
   else if(CounterX==10'h320) begin   //800
      CounterY <= CounterY + 1;
		if (CounterY[3:0] == 4'b0000)
			y <= y + 1;
		end
end
//generate synchronization signal for both vertical and horizontal
always @(posedge clk)
begin
	vga_HS <= (CounterX>655 && CounterX<752); 	// change these values to move the display horizontally
	vga_VS <= (CounterY==490 ||CounterY==491); 	// change these values to move the display vertically
end 


always @(posedge clk)
   if(reset)
      inDisplayArea<=0;
   else
	   inDisplayArea <= (CounterX<640) && (CounterY<480);
	
assign vga_h_sync = ~vga_HS;
assign vga_v_sync = ~vga_VS;

endmodule
