`default_nettype none
module test;

    reg clk = 0;
    always #1 clk = !clk;
    
    localparam WIDTH = 12;
    localparam MAX_LEN = 2000;

    reg [WIDTH-1:0] sample_data [MAX_LEN-1:0];
    wire signed [WIDTH-1:0] sample_real = sample_data[count];

    top #(.WIDTH(WIDTH)) top0 (.clk(clk), .reset(0), .sample_real(sample_real));

    initial begin
//        $readmemh("sine.hex", sample_data);
        $readmemh("sweep.hex", sample_data);
    end

    reg [15:0] count = 0;
    always @(posedge clk) begin
        count <= count + 1;
        if(count == MAX_LEN)
            count <= 0;
    end

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0,test);

        wait(count == MAX_LEN);

        $finish;
    end

endmodule
