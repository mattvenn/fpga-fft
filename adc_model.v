/*
model of the ADC that the adc.v core reads
Serial ADC [ADS7883](http://www.ti.com/lit/ds/symlink/ads7883.pdf)
*/
`default_nettype none
module adc_model #(
   parameter MAX_LEN = 128,
   parameter WIDTH = 12,
   parameter SAMPLE_FILE = "sample.list"
)
(
    input wire clk,
    input wire cs,
    input wire run,
    output done,
    output reg sd
);

    reg [$clog2(MAX_LEN)-1:0] sample_count = 0;
    reg [$clog2(WIDTH)-1:0] bit_count = 0;
    reg [WIDTH-1:0] sample_data [MAX_LEN-1:0];

    assign done = state == STATE_IDLE;

    initial begin
        if (SAMPLE_FILE) $readmemh(SAMPLE_FILE, sample_data);
        sd <= 0;
        bit_count <= 0;
        sample_count <= 0;
    end

    localparam STATE_IDLE   = 0;
    localparam STATE_WAIT_CS= 1;
    localparam STATE_RUN    = 2;

    reg [2:0] state = STATE_IDLE;

    always @(negedge clk)
        case(state)
            STATE_IDLE: begin
                sd <= 0;
                sample_count <= 0;
                bit_count <= 0;
                if(run)
                    state <= STATE_WAIT_CS;
            end

            STATE_WAIT_CS: begin // sync to adc reader
                if(cs == 1)
                    state <= STATE_RUN;
                end

            STATE_RUN: begin
                if(cs == 1 && sample_count < MAX_LEN - 1) begin // reset counters
    //                $display("sample = %d", sample_data[sample_count]);
                    bit_count <= 0;
                    sample_count <= sample_count + 1;
                    sd <= 0;
                end else if (bit_count <= WIDTH ) begin // clock out data on negedge of clock until end of the sample file
                    bit_count <= bit_count + 1;
                    if(bit_count == 0) // ADC outputs a leading 0 before the sample data follows
                        sd <= 0;
                    else
                        sd <= sample_data[sample_count][WIDTH-bit_count];
                end else if (sample_count == MAX_LEN - 1)
                    state <= STATE_IDLE;
            end
        endcase

endmodule
