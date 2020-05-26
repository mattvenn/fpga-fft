PROJ = fft

DEVICE = hx8k
PIN_DEF = mv-dev.pcf
PACKAGE = tq144:4k

#DEVICE = up5k
#PIN_DEF = icebreaker.pcf
#PACKAGE = sg48

BUILD_DIR = .
PI_ADDR = pi@fpga.local
FOMU_FLASH = ~/fomu-flash/fomu-flash

SEED = 8

PULSE_TOOL=~/work/kneesonic/tools/gen_pulse.py
SRC=bimpy.v bitreverse.v butterfly.v convround.v fftmain.v fftstage.v hwbfly.v laststage.v longbimpy.v qtrstage.v shiftaddmpy.v top.v adc.v pwm.v

all:  $(PROJ).bin

testtone.hex:
	$(PULSE_TOOL) --wave sweep --amp 600 --amp2 600 --freq 62500 --freq2 250000 --sample-rate 2000000 --plot --file testtone.hex --length 2000
#	$(PULSE_TOOL) --wave sine --amp 600  --freq 4000000  --sample-rate 32000000 --plot --file testtone.hex --length 2000

debug: testtone.hex
	iverilog -DDEBUG -o test test_tb.v adc_model.v $(SRC)
	vvp test
	gtkwave test.vcd fft.gtkw

# needs -dsp to infer multiplies
%.json: $(SRC)
	yosys -l yosys.log -p 'synth_ice40  -top top -json $@' $^

%.asc: %.json $(PIN_DEF) 
	nextpnr-ice40 -l nextpnr.log --seed $(SEED) --freq 32 --package $(PACKAGE) --$(DEVICE) --asc $@ --pcf $(PIN_DEF) --json $< 

%.bin: %.asc
	icepack $< $@

prog-fpga: $(BUILD_DIR)/$(PROJ).bin
	scp $< $(PI_ADDR):/tmp/$(PROJ).bin
	ssh $(PI_ADDR) "sudo $(FOMU_FLASH) -f /tmp/$(PROJ).bin"

prog-flash: $(BUILD_DIR)/$(PROJ).bin
	scp $< $(PI_ADDR):/tmp/$(PROJ).bin
	ssh $(PI_ADDR) "sudo $(FOMU_FLASH) -w /tmp/$(PROJ).bin; sudo $(FOMU_FLASH) -r"
