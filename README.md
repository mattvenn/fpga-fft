./fftgen -f 64 -n 12 -m 12

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

-k #    Sets # clocks per sample, used to minimize multiplies.  Also
        sets one sample in per i_ce clock (opt -1)
./fftgen -f 64 -n 12 -m 12 -k 16

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


./fftgen -f 32 -n 12 -m 12 -k 16

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


ecp5 25k is $11 has 28 mulitplies. each cahnnel gets 7. 1 for hitproc leaves 6 for fft
ecp5 45k is $18 has 72 multiplies. each channel gets 18. 1 for hitproc leaves 17 for fft

./fftgen -f 32 -n 12 -m 12 -k 16 -p 6

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

./fftgen -f 64 -n 12 -m 12 -k 16 -p 6

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

for now working with
./fftgen -f 32 -n 12 -m 12 -k 16

Info: Device utilisation:
Info:            ICESTORM_LC:  6762/ 7680    88%
Info:           ICESTORM_RAM:    20/   32    62%
Info:                  SB_IO:    13/  256     5%
Info:                  SB_GB:     8/    8   100%
Info:           ICESTORM_PLL:     1/    2    50%
Info:            SB_WARMBOOT:     0/    1     0%

