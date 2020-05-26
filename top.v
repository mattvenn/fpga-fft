`default_nettype none
module top #(
    parameter WIDTH = 12)
    (
    input wire reset,
    input wire clk,
    input wire [11:0] sample_real,
    output wire [WIDTH*2+1:0] abs
    );

    reg ce = 1;

    wire signed [WIDTH-1:0] sample_imag = 12'b0;
    wire signed [WIDTH-1:0] output_real, output_imag;
    assign abs = (output_real * output_real) + (output_imag * output_imag);

    fftmain fft_0(.i_clk(clk), .i_reset(reset), .i_ce(ce), .i_sample({sample_real, sample_imag}), .o_result({output_real, output_imag}));

endmodule
