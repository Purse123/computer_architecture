file=5-basic_gate.vhdl
entity=basic_gates
vcdFile=basic_gates.vcd

compile:
	ghdl -a $(file)
execute:
	ghdl -e $(entity)
runnable:
	ghdl -r $(entity) --vcd=$(vcdFile)
gtkwave:
	gtkwave $(vcdFile)
