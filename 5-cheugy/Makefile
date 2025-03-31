file=5-basic_gate.vhdl
entity=basic_gates
vcdFile=basic_gates.vcd

all: compile execute runnable

compile:
	ghdl -a $(file)
execute: compile
	ghdl -e $(entity)
runnable: execute
	ghdl -r $(entity) --vcd=$(vcdFile)
gtkwave: runnable
	gtkwave $(vcdFile)
