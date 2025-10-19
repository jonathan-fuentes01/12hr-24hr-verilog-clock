module clk_divider(
    input clk,
    output reg clkout
);

reg [26:0] second_counter;

always @(posedge clk) begin
    if(second_counter == 49_999_999) begin
        second_counter <= 0;
        clkout <= ~clkout;
    end
    else
        second_counter <= second_counter + 1;
end
endmodule