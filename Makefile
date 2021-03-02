# The files
FILES		= src/registers.vhdl src/decoder.vhdl src/control.vhdl \
                src/cpu.vhdl
SIMDIR		= sim
SIMFILES	= test/reg_tb.vhdl test/decoder_tb.vhdl test/control_tb1.vhdl \
                test/cpu_tb.vhdl

# GHDL
GHDL_CMD	= ghdl
GHDL_FLAGS	= --ieee=synopsys --warn-no-vital-generic
GHDL_WORKDIR = --workdir=sim --work=work
GHDL_STOP	= --stop-time=500ns

# For visualization
VIEW_CMD        = /usr/bin/gtkwave

# The commands
all:
	make compile
	make run

compile:
	mkdir -p sim
	ghdl -a $(GHDL_FLAGS) $(GHDL_WORKDIR) $(FILES)
	ghdl -a $(GHDL_FLAGS) $(GHDL_WORKDIR) $(SIMFILES)
	ghdl -e -o sim/reg_tb $(GHDL_FLAGS) $(GHDL_WORKDIR) reg_tb
	ghdl -e -o sim/decoder_tb $(GHDL_FLAGS) $(GHDL_WORKDIR) decoder_tb
	ghdl -e -o sim/control_tb1 $(GHDL_FLAGS) $(GHDL_WORKDIR) control_tb1
	ghdl -e -o sim/cpu_tb $(GHDL_FLAGS) $(GHDL_WORKDIR) cpu_tb

run:
	cd sim; \
	#ghdl -r $(GHDL_FLAGS) reg_tb $(GHDL_STOP) --wave=wave.ghw; \
	#ghdl -r $(GHDL_FLAGS) decoder_tb $(GHDL_STOP) --wave=decoder_wave.ghw; \
	#ghdl -r $(GHDL_FLAGS) control_tb1 $(GHDL_STOP) --wave=control_tb1.ghw; \
	ghdl -r $(GHDL_FLAGS) cpu_tb $(GHDL_STOP) --wave=cpu_tb.ghw; \
	cd ..

view:
	gtkwave sim/wave.ghw

clean:
	$(GHDL_CMD) --clean --workdir=sim
