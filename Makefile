PROJ = fft
DEVICE = hx8k
PIN_DEF = mv-dev.pcf
PACKAGE = tq144:4k
SEED = 8

PULSE_TOOL=~/work/kneesonic/tools/gen_pulse.py
SRC=bimpy.v bitreverse.v butterfly.v convround.v fftmain.v fftstage.v hwbfly.v laststage.v longbimpy.v qtrstage.v shiftaddmpy.v top.v
debug: 
#	$(PULSE_TOOL) --wave sweep --amp 100 --amp2 100 --freq 1000 --freq2 50000 --sample-rate 400000 --plot --file sweep.hex --length 2000
	iverilog -DDEBUG -o test test_tb.v $(SRC)
	vvp test
	gtkwave test.vcd fft.gtkw

%.json: $(SRC)
	yosys -l yosys.log -p 'synth_ice40 -top top -json $@' $^

%.asc: %.json $(PIN_DEF) 
	nextpnr-ice40 -l nextpnr.log --seed $(SEED) --freq 32 --package $(PACKAGE) --$(DEVICE) --asc $@ --pcf $(PIN_DEF) --json $<
