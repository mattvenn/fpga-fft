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
FFT_CORE = bimpy.v bitreverse.v butterfly.v convround.v fftmain.v fftstage.v hwbfly.v laststage.v longbimpy.v qtrstage.v shiftaddmpy.v
FFT_SRC = $(addprefix fft-core/, $(FFT_CORE))
LOCAL_SRC = top.v adc.v pwm.v bram.v
SRC = $(FFT_SRC) $(LOCAL_SRC)

all: fft-core gamma.hex $(PROJ).bin

gamma.hex:
	python3 ./gamma.py 8

testtone.hex:
#	$(PULSE_TOOL) --wave sweep --amp 600 --amp2 600 --freq 62500 --freq2 125000 --sample-rate 2000000 --plot --file testtone.hex --length 2000
#	$(PULSE_TOOL) --wave sine --amp 600  --freq 62500   --sample-rate 2000000 --plot --file testtone.hex --length 2000
	$(PULSE_TOOL) --wave sine --amp 600  --freq 93750   --sample-rate 2000000 --plot --file testtone.hex --length 2000
#	$(PULSE_TOOL) --wave sine --amp 600  --freq 125000  --sample-rate 2000000 --plot --file testtone.hex --length 2000

# link from Dan's core
fft-core:
	make -C dblclockfft
	./dblclockfft/sw/fftgen -f 32 -n 12 -m 12 -k 16 -d fft-core
	ln -sf fft-core/cmem_8.hex .
	ln -sf fft-core/cmem_16.hex .
	ln -sf fft-core/cmem_32.hex .
	#ln -sf fft-core/cmem_64.hex .

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

clean:
	rm $(PROJ).bin

.phony: testtone.hex clean
