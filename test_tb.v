`default_nettype none
module test;

    reg clk = 0;
    always #1 clk = !clk;
    
    localparam WIDTH = 12;
    localparam MAX_LEN = 2000;
    localparam CE = 16;
    localparam BINS = 8;

    top #(.WIDTH(WIDTH), .BINS(BINS)) top0 (.ext_clk(clk), .reset_async(1'b0), .adc_clk(adc_clk), .adc_cs(adc_cs), .adc_sd(adc_sd));

    wire done, adc_sd, adc_cs, adc_clk;
    reg run;
    adc_model #(.MAX_LEN(MAX_LEN), .SAMPLE_FILE("testtone.hex")) adc_model_inst(.run(run), .clk(adc_clk), .cs(adc_cs), .sd(adc_sd), .done(done));

    integer i;
    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0,test);
        for (i = 0 ; i < BINS ; i = i + 1) begin
            $dumpvars(1, top0.bins[i]);
        end
        
        # 20
        run = 1;
        # 20000

        $finish;
    end

endmodule
