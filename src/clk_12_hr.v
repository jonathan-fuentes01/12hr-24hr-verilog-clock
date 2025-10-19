`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jonathan Fuentes
// 
// Create Date: 05/04/2025 04:46:00 PM
// Design Name: 
// Module Name: clk_12_hr
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


module clk_12_hr(  
    input clk,
    input reset,
    input set_time,
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
    output [6:0] sec1_seg,
    output reg am_pm
);

    reg [3:0] h10_out = 1;
    reg [3:0] h1_out  = 2;
    reg [3:0] m10_out = 0;
    reg [3:0] m1_out  = 0;
    reg [3:0] s10_out = 0;
    reg [3:0] s1_out  = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            h10_out <= 1; h1_out <= 2;
            m10_out <= 0; m1_out <= 0;
            s10_out <= 0; s1_out <= 0;
            am_pm   <= 0;
        end else if (set_time) begin
            if (sec1) begin
                if (s1_out < 9)
                    s1_out <= s1_out + 1;
                else begin
                    s1_out <= 0;
                    if (s10_out < 5)
                        s10_out <= s10_out + 1;
                    else
                        s10_out <= 0;
                end
            end
            if (sec10) begin
                if (s10_out < 5)
                    s10_out <= s10_out + 1;
                else
                    s10_out <= 0;
            end
            if (min1) begin
                if (m1_out < 9)
                    m1_out <= m1_out + 1;
                else begin
                    m1_out <= 0;
                    if (m10_out < 5)
                        m10_out <= m10_out + 1;
                    else
                        m10_out <= 0;
                end
            end
            if (min10) begin
                if (m10_out < 5)
                    m10_out <= m10_out + 1;
                else
                    m10_out <= 0;
            end         
            if (hour1) begin
                if (h10_out == 1 && h1_out == 1) begin
                    h1_out <= 2;
                    am_pm  <= ~am_pm;
                end
                else if (h10_out == 1 && h1_out == 2) begin
                    h10_out <= 0;
                    h1_out  <= 1;
                end 
                else if (h10_out == 0 && h1_out == 9) begin
                    h10_out <= 1;
                    h1_out  <= 0;
                end 
                else begin
                    h1_out <= h1_out + 1;
                end
            end
            if (hour10) begin
                if (h10_out == 0) begin
                    h10_out <= 1;
                    if (h1_out > 2)
                        h1_out <= 2;
                end 
                else begin
                    h10_out <= 0;
                    if (h1_out == 0)
                        h1_out <= 1;
                end
            end
        end 
        else begin
            if (s1_out < 9) begin
                s1_out <= s1_out + 1;
            end 
            else begin
                s1_out <= 0;
                if (s10_out < 5) begin
                    s10_out <= s10_out + 1;
                end 
                else begin
                    s10_out <= 0;
                    if (m1_out < 9) begin
                        m1_out <= m1_out + 1;
                    end 
                    else begin
                        m1_out <= 0;
                        if (m10_out < 5) begin
                            m10_out <= m10_out + 1;
                        end 
                        else begin
                            m10_out <= 0;
                            if (h10_out == 1 && h1_out == 1) begin
                                h1_out <= 2;
                                am_pm  <= ~am_pm;
                            end
                            else if (h10_out == 1 && h1_out == 2) begin
                                h10_out <= 0;
                                h1_out  <= 1;
                            end 
                            else if (h10_out == 0 && h1_out == 9) begin
                                h10_out <= 1;
                                h1_out  <= 0;
                            end 
                            else begin
                                h1_out <= h1_out + 1;
                            end
                        end
                    end
                end
            end
        end
    end

    seven_seg_decoder hours10   (.four_bit_in(h10_out), .seg(hour10_seg));
    seven_seg_decoder hours1    (.four_bit_in(h1_out),  .seg(hour1_seg));
    seven_seg_decoder minutes10 (.four_bit_in(m10_out), .seg(min10_seg));
    seven_seg_decoder minutes1  (.four_bit_in(m1_out),  .seg(min1_seg));
    seven_seg_decoder seconds10 (.four_bit_in(s10_out), .seg(sec10_seg));
    seven_seg_decoder seconds1  (.four_bit_in(s1_out),  .seg(sec1_seg));

endmodule