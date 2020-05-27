# Demo of Dan's FFT Core

https://zipcpu.com/dsp/2018/10/02/fft.html
https://github.com/ZipCPU/dblclockfft

This demo uses a 32 bin 12 bit core generated with this command:

    ./fftgen -f 32 -n 12 -m 12 -k 16

Runs at 32MHz, with -k 16 fft only runs once per 16 cycles (to reduce number of 
multipliers). So throughput is 2MHz.

Only the first 8 bins are displayed on the LEDs.

# Build

Dev board targetted is [here](https://github.com/mattvenn/first-fpga-pcb)

* run make debug to see trace of a generated sine
* run make prog-fpga to build a bin and copy to dev board plugged to raspi

# Resource usage

## HX8k

### ./fftgen -f 64 -n 12 -m 12

    === top ===

       Number of wires:               5026
       Number of wire bits:          32754
       Number of public wires:        5026
       Number of public wire bits:   32754
       Number of memories:               0
       Number of memory bits:            0
       Number of processes:              0
       Number of cells:              20790
         SB_CARRY                     4011
         SB_DFF                       6903
         SB_DFFE                       301
         SB_DFFESR                      46
         SB_DFFSR                      215
         SB_DFFSS                        1
         SB_LUT4                      9285
         SB_RAM40_4K                    28

### ./fftgen -f 64 -n 12 -m 12 -k 16

-k #    Sets # clocks per sample, used to minimize multiplies.  Also
        sets one sample in per i_ce clock (opt -1)

97% fpga usage on 8k

    === top ===

       Number of wires:               3309
       Number of wire bits:          18949
       Number of public wires:        3309
       Number of public wire bits:   18949
       Number of memories:               0
       Number of memory bits:            0
       Number of processes:              0
       Number of cells:              10583
         SB_CARRY                     1763
         SB_DFF                       3634
         SB_DFFE                       301
         SB_DFFESR                      46
         SB_DFFSR                      236
         SB_DFFSS                        1
         SB_LUT4                      4574
         SB_RAM40_4K                    28


### ./fftgen -f 32 -n 12 -m 12 -k 16

    Info: Device utilisation:
    Info:            ICESTORM_LC:  6053/ 7680    78%
    Info:           ICESTORM_RAM:    20/   32    62%
    Info:                  SB_IO:    40/  256    15%
    Info:                  SB_GB:     8/    8   100%
    Info:           ICESTORM_PLL:     0/    2     0%
    Info:            SB_WARMBOOT:     0/    1     0%

=== top ===

       Number of wires:               2815
       Number of wire bits:          15018
       Number of public wires:        2815
       Number of public wire bits:   15018
       Number of memories:               0
       Number of memory bits:            0
       Number of processes:              0
       Number of cells:               8445
         SB_CARRY                     1377
         SB_DFF                       2790
         SB_DFFE                       301
         SB_DFFESR                      33
         SB_DFFSR                      181
         SB_DFFSS                        1
         SB_LUT4                      3742
         SB_RAM40_4K                    20

### ./fftgen -f 32 -n 12 -m 12 -k 16 -p 6

using hardware dsps on up5k

    Info:            ICESTORM_LC:  3092/ 5280    58%
    Info:           ICESTORM_RAM:    14/   30    46%
    Info:                  SB_IO:    40/   96    41%
    Info:                  SB_GB:     8/    8   100%
    Info:           ICESTORM_PLL:     0/    1     0%
    Info:            SB_WARMBOOT:     0/    1     0%
    Info:           ICESTORM_DSP:     5/    8    62%
    Info:         ICESTORM_HFOSC:     0/    1     0%
    Info:         ICESTORM_LFOSC:     0/    1     0%
    Info:                 SB_I2C:     0/    2     0%
    Info:                 SB_SPI:     0/    2     0%
    Info:                 IO_I3C:     0/    2     0%
    Info:            SB_LEDDA_IP:     0/    1     0%
    Info:            SB_RGBA_DRV:     0/    1     0%
    Info:         ICESTORM_SPRAM:     0/    4     0%

### ./fftgen -f 64 -n 12 -m 12 -k 16 -p 6

using hardware dsps on up5k

    Info:            ICESTORM_LC:  3809/ 5280    72%
    Info:           ICESTORM_RAM:    20/   30    66%
    Info:                  SB_IO:    40/   96    41%
    Info:                  SB_GB:     8/    8   100%
    Info:           ICESTORM_PLL:     0/    1     0%
    Info:            SB_WARMBOOT:     0/    1     0%
    Info:           ICESTORM_DSP:     6/    8    75%
    Info:         ICESTORM_HFOSC:     0/    1     0%
    Info:         ICESTORM_LFOSC:     0/    1     0%
    Info:                 SB_I2C:     0/    2     0%
    Info:                 SB_SPI:     0/    2     0%
    Info:                 IO_I3C:     0/    2     0%
    Info:            SB_LEDDA_IP:     0/    1     0%
    Info:            SB_RGBA_DRV:     0/    1     0%
    Info:         ICESTORM_SPRAM:     0/    4     0%

### ./fftgen -f 32 -n 12 -m 12 -k 16

for now working with this one

    Info: Device utilisation:
    Info:            ICESTORM_LC:  6762/ 7680    88%
    Info:           ICESTORM_RAM:    20/   32    62%
    Info:                  SB_IO:    13/  256     5%
    Info:                  SB_GB:     8/    8   100%
    Info:           ICESTORM_PLL:     1/    2    50%
    Info:            SB_WARMBOOT:     0/    1     0%

