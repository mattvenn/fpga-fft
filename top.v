`default_nettype none
`define MV_BOARD
module top #(
    parameter WIDTH = 12,
    parameter BINS = 8,
    parameter PWM_WIDTH = 8)
    (
    input wire reset_async,
    input wire ext_clk,
    output wire adc_clk,
    output wire adc_cs,
    output wire [7:0] leds,
    input wire adc_sd
    );

    // power on and reset sync
	reg [5:0] reset_cnt = 0;
	wire reset = reset_cnt < (1<<5);

	always @(posedge clk_32m) begin
		reset_cnt <= reset_cnt + reset;
        if(reset_async) // if pressed
            reset_cnt <= 0;
	end

    `ifndef DEBUG
    wire clk_32m;
    SB_PLL40_CORE #(
        .FEEDBACK_PATH("SIMPLE"),
        .PLLOUT_SELECT("GENCLK"),
        `ifdef ICOBOARD // achieved 32.031
        .DIVR(4'b0011),
        .DIVF(7'b0101000),
        .DIVQ(3'b101), 
        .FILTER_RANGE(3'b010)
        `elsif MV_BOARD // achieved 31.875
        .DIVR(4'b0000),
        .DIVF(7'b1010100),
        .DIVQ(3'b101), 
        .FILTER_RANGE(3'b010)
        `endif
    ) uut (
        .RESETB(1'b1),
        .BYPASS(1'b0),
        .REFERENCECLK(ext_clk),
        .PLLOUTCORE(clk_32m)
    );
    `endif
    `ifdef DEBUG
          reg clk_32m = 0;
          always #1 clk_32m = !clk_32m;
    `endif

   
    wire adc_ready;
    wire [WIDTH-1:0] adc_data;
      adc adc_inst(
            .clk(clk_32m), 
            .adc_clk(adc_clk), 
            .adc_cs(adc_cs), 
            .adc_sd(adc_sd), 
            .data(adc_data), 
            .ready(adc_ready), 
            .reset(reset));

    wire signed [WIDTH-1:0] sample_imag = 12'b0;
    wire signed [WIDTH-1:0] output_real, output_imag;
    wire [WIDTH*2+1:0] abs = (output_real * output_real) + (output_imag * output_imag);

    reg [7:0] bins [BINS-1:0];
    wire sync;
    reg [7:0] bin = 0;
    always @(posedge adc_ready) begin
        if(sync)
            bin <= 0;
        else
            bin <= bin + 1;
        if(bin < BINS)
            bins[bin] <= abs >> 6;
    end

    fftmain fft_0(.i_clk(clk_32m), .i_reset(reset), .i_ce(adc_ready), .i_sample({adc_data, sample_imag}), .o_result({output_real, output_imag}), .o_sync(sync));

      generate
          genvar i;
          for(i = 0; i < BINS; i = i + 1) begin
                pwm #(.WIDTH(PWM_WIDTH), .INVERT(1'b0))  pwm_inst (.clk(clk_32m), .level(bins[i]), .pwm(leds[i]));
          end
      endgenerate

endmodule
