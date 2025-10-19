`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jonathan Fuentes
// 
// Create Date: 05/04/2025 05:04:37 PM
// Design Name: 
// Module Name: clk_24_12_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clk_24_12_top(
        input clk,
        input reset,
        input set_time,
        input hour10,
        input hour1,
        input min10,
        input min1,
        input sec10,
        input sec1,
        input ampm_toggle,
        output am_pm,
        
        
        
        output [6:0] muxOuth10,
        output [6:0] muxOuth1,
        output [6:0] muxOutm10,
        output [6:0] muxOutm1,
        output [6:0] muxOuts10,
        output [6:0] muxOuts1,
   
        output reg [7:0] anode_result,
        output reg SA, SB, SC, SD, SE, SF, SG
    );
       
reg [19:0] refresh_rate;
wire [2:0] anode_counter;
wire clkout;

wire [6:0] hour10_12;
wire [6:0] hour1_12;
wire [6:0] min10_12;
wire [6:0] min1_12;
wire [6:0] sec10_12;
wire [6:0] sec1_12;


wire [6:0] hour10_24;
wire [6:0] hour1_24;
wire [6:0] min10_24;
wire [6:0] min1_24;
wire [6:0] sec10_24;
wire [6:0] sec1_24;
        

clk_divider clk24(.clk(clk), .clkout(clkout));

clk_24_hr hourclock(.clk(clkout), .reset(reset), .set_time(set_time), .hour10(hour10), .hour1(hour1), .min10(min10), .min1(min1), .sec10(sec10), .sec1(sec1), .hour10_seg(hour10_24), .hour1_seg(hour1_24), .min10_seg(min10_24), .min1_seg(min1_24), .sec10_seg(sec10_24), .sec1_seg(sec1_24));    
clk_12_hr hour12clock(.clk(clkout), .reset(reset), .set_time(set_time), .hour10(hour10), .hour1(hour1), .min10(min10), .min1(min1), .sec10(sec10), .sec1(sec1), .hour10_seg(hour10_12), .hour1_seg(hour1_12), .min10_seg(min10_12), .min1_seg(min1_12), .sec10_seg(sec10_12), .sec1_seg(sec1_12), .am_pm(am_pm));   

mux_2to1_7bit outHour10(.sel(ampm_toggle), .a(hour10_24), .b(hour10_12), .out(muxOuth10));
mux_2to1_7bit outHour1(.sel(ampm_toggle), .a(hour1_24), .b(hour1_12), .out(muxOuth1));
mux_2to1_7bit outMin10(.sel(ampm_toggle), .a(min10_24), .b(min10_12), .out(muxOutm10));
mux_2to1_7bit outMin1(.sel(ampm_toggle), .a(min1_24), .b(min1_12), .out(muxOutm1));
mux_2to1_7bit outSec10(.sel(ampm_toggle), .a(sec10_24), .b(sec10_12), .out(muxOuts10));
mux_2to1_7bit outSec1(.sel(ampm_toggle), .a(sec1_24), .b(sec1_12), .out(muxOuts1));

always@(posedge clk) begin
    refresh_rate <= refresh_rate + 1;
end
assign anode_counter = refresh_rate[19:17];

always@(posedge clk) begin
  case(anode_counter)
    3'b000: begin
        SA <= muxOuth10[6];
        SB <= muxOuth10[5];
        SC <= muxOuth10[4];
        SD <= muxOuth10[3];
        SE <= muxOuth10[2];
        SF <= muxOuth10[1];
        SG <= muxOuth10[0];
        
        anode_result <= 8'b1111_1110;
    end
    3'b001: begin
        SA <= muxOuth1[6];
        SB <= muxOuth1[5];
        SC <= muxOuth1[4];
        SD <= muxOuth1[3];
        SE <= muxOuth1[2];
        SF <= muxOuth1[1];
        SG <= muxOuth1[0];
        
        anode_result <= 8'b1111_1101;
    end
    3'b010: begin
        SA <= muxOutm10[6];
        SB <= muxOutm10[5];
        SC <= muxOutm10[4];
        SD <= muxOutm10[3];
        SE <= muxOutm10[2];
        SF <= muxOutm10[1];
        SG <= muxOutm10[0];
        
        anode_result <= 8'b1111_1011;
    end
    3'b011: begin
        SA <= muxOutm1[6];
        SB <= muxOutm1[5];
        SC <= muxOutm1[4];
        SD <= muxOutm1[3];
        SE <= muxOutm1[2];
        SF <= muxOutm1[1];
        SG <= muxOutm1[0];
        
        anode_result <= 8'b1111_0111;
    end
    3'b100: begin
        SA <= muxOuts10[6];
        SB <= muxOuts10[5];
        SC <= muxOuts10[4];
        SD <= muxOuts10[3];
        SE <= muxOuts10[2];
        SF <= muxOuts10[1];
        SG <= muxOuts10[0];
        
        anode_result <= 8'b1110_1111;
    end
    3'b101: begin
        SA <= muxOuts1[6];
        SB <= muxOuts1[5];
        SC <= muxOuts1[4];
        SD <= muxOuts1[3];
        SE <= muxOuts1[2];
        SF <= muxOuts1[1];
        SG <= muxOuts1[0];
        
        anode_result <= 8'b1101_1111;
    end
    3'b110: begin
        SA <= 1'b1;
        SB <= 1'b1;
        SC <= 1'b1;
        SD <= 1'b1;
        SE <= 1'b1;
        SF <= 1'b1;
        SG <= 1'b1;
        
        anode_result <= 8'b1011_1111;
    end
    3'b111: begin
        SA <= 1'b1;
        SB <= 1'b1;
        SC <= 1'b1;
        SD <= 1'b1;
        SE <= 1'b1;
        SF <= 1'b1;
        SG <= 1'b1;
        
        anode_result <= 8'b0111_1111;
   end
   default: begin
        SA <= 1'b1;
        SB <= 1'b1;
        SC <= 1'b1;
        SD <= 1'b1;
        SE <= 1'b1;
        SF <= 1'b1;
        SG <= 1'b1;
        
        anode_result <= 8'b1111_1111;
   end
   endcase
end    
endmodule
