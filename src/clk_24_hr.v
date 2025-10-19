`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jonathan Fuentes
// 
// Create Date: 05/04/2025 02:04:59 PM
// Design Name: 
// Module Name: clk_24_hr
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


module clk_24_hr( 
    input clk,
    input set_time,
    input reset,
    input hour10,  
    input hour1,   
    input min10,  
    input min1,   
    input sec10,   
    input sec1, 
    output [6:0] hour10_seg,
    output [6:0] hour1_seg,
    output [6:0] min10_seg,
    output [6:0] min1_seg,
    output [6:0] sec10_seg,
    output [6:0] sec1_seg
);
    
    reg [3:0] h10_out = 0;
    reg [3:0] h1_out  = 0;
    reg [3:0] m10_out = 0;
    reg [3:0] m1_out  = 0;
    reg [3:0] s10_out = 0;
    reg [3:0] s1_out  = 0;
    
    always @(posedge clk) begin
    if (reset) begin
        h10_out <= 0; 
        h1_out <= 0;
        m10_out <= 0; 
        m1_out <= 0;
        s10_out <= 0; 
        s1_out <= 0;
    end 
    else if (set_time) begin
        if (hour1 && (h10_out * 10 + h1_out < 24)) begin
            if (h1_out == 9 || (h10_out == 2 && h1_out == 3)) 
                h1_out <= 0;
            else
                h1_out <= h1_out + 1;
        end

        if (hour10 && (h10_out < 2 || (h10_out == 2 && h1_out < 4))) begin
            if (h10_out == 2)
                h10_out <= 0;
            else
                h10_out <= h10_out + 1;
        end
        if (min1) begin
            if (m1_out == 9)
                m1_out <= 0;
            else
                m1_out <= m1_out + 1;
        end
        if (min10) begin
            if (m10_out == 5)
                m10_out <= 0;
            else
                m10_out <= m10_out + 1;
        end
        if (sec1) begin
            if (s1_out == 9)
                s1_out <= 0;
            else
                s1_out <= s1_out + 1;
        end
        if (sec10) begin
            if (s10_out == 5)
                s10_out <= 0;
            else
                s10_out <= s10_out + 1;
        end
    end
    else begin
        if (s1_out == 9) begin
            s1_out <= 0;
            if (s10_out == 5) begin
                s10_out <= 0;

                if (m1_out == 9) begin
                    m1_out <= 0;
                    if (m10_out == 5) begin
                        m10_out <= 0;
                        if (h1_out == 9 || (h10_out == 2 && h1_out == 3)) begin
                            h1_out <= 0;
                            if (h10_out == 2)
                                h10_out <= 0;
                            else
                                h10_out <= h10_out + 1;
                        end 
                        else begin
                            h1_out <= h1_out + 1;
                        end
                    end 
                    else begin
                        m10_out <= m10_out + 1;
                    end
                end 
                else begin
                    m1_out <= m1_out + 1;
                end
            end 
            else begin
                s10_out <= s10_out + 1;
            end
        end 
        else begin
            s1_out <= s1_out + 1;
        end
    end
end

seven_seg_decoder hours10(.four_bit_in(h10_out), .seg(hour10_seg));
seven_seg_decoder hours1(.four_bit_in(h1_out), .seg(hour1_seg));
seven_seg_decoder minutes10(.four_bit_in(m10_out), .seg(min10_seg));
seven_seg_decoder minutes1(.four_bit_in(m1_out), .seg(min1_seg));
seven_seg_decoder seconds10(.four_bit_in(s10_out), .seg(sec10_seg));
seven_seg_decoder seconds1(.four_bit_in(s1_out), .seg(sec1_seg));  
    
endmodule
