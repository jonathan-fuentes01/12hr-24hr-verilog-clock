`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jonathan Fuentes
// 
// Create Date: 05/04/2025 05:17:27 PM
// Design Name: 
// Module Name: mux_2to1_7bit
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


module mux_2to1_7bit(
    input [6:0] a,
    input [6:0] b,
    input sel,
    output reg [6:0] out
    );

always@(*)begin
    case(sel)
        0: out = a;
        1: out = b;
        default: out = 7'b000_0000;
    endcase
end
endmodule
