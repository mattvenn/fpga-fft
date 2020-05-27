/*
Serial ADC reader for [ADS7883](http://www.ti.com/lit/ds/symlink/ads7883.pdf)

Matt Venn 2017

ADC starts sample on CS low. First 2 clocks are blank and then sample is 
clocked out MSB first.

*/
`default_nettype none
module adc (
	input wire clk,
    input wire reset,
    output wire adc_clk,
    output wire adc_cs,
    output reg ready,
    input wire adc_sd,
    output reg [11:0] data,
    output reg [11:0] max
);

    initial begin
        ready = 0;
        data = 0;
        max = 0;
    end

    // outputs only valid not in reset
    assign adc_clk = clk;
    assign adc_cs = (cnt == 0 && reset == 0) ? 1 : 0; 

    reg [11:0] serial_data = 0;
    reg [3:0] cnt = 0;
    reg capture = 0;

    always @(posedge clk) begin

        if(reset) begin

            max <= 0;
            serial_data <= 12'b0;
            cnt <= 0;
            data <= 12'b0;
            ready <= 0;

        end else begin

            cnt<=cnt+1;

            if(cnt == 0) begin
                ready <= 0;
            end

            if(cnt > 1 && cnt <= 13)
                serial_data <= { serial_data[10:0], adc_sd };
            if(cnt == 0)
                serial_data <= 0;

            if(cnt == 14) begin
                data <= serial_data;
                ready <= 1;
                if(serial_data > max)
                    max <= serial_data;
            end

            // ready signal is only valid for 1 clock, used for clock enable
            if(cnt == 15) 
                ready <= 0;
        end
    end

    `ifdef FORMAL_ADC
        // all this mostly from https://zipcpu.com/blog/2017/10/19/formal-intro.html

        // past valid signal
        reg f_past_valid = 0;
        always @(posedge clk)
            f_past_valid <= 1'b1;

        // start in reset
        initial restrict(reset);

        // force: clock to change, only allow inputs to change on rising clock
        reg f_last_clk = 0;
        always @($global_clock) begin
            restrict(clk == !f_last_clk);
            f_last_clk <= clk;
            if (!$rose(clk)) begin
                assume($stable(reset));
            end
        end

        // check everything is zeroed on the reset signal
        always @(posedge clk)
            if (f_past_valid)
                if ($past(reset)) begin
                    assert(max == 0);
                    assert(serial_data == 0);
                    assert(cnt == 0);
                    assert(data == 0);
                    assert(ready == 0);
                end

        // ready signal is asserted
        // check data doesn't change when the ready signal is given
        always @(posedge clk)
            if(cnt == 15) begin
                assert(ready == 1);
                assert(data == $past(serial_data));
            end

        // ready signal only one clock
        always @(posedge clk)
            if (f_past_valid)
                if($past(ready))
                    assert(ready == 0);

        // cs signal
        always @(posedge clk)
            if(!reset && cnt == 0)
                assert(adc_cs == 1);

    `endif

endmodule
