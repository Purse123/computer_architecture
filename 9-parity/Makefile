file=party.vhdl
entity=parity_gen_check
vcdFile=parity_gen_check.vcd

compile:
	ghdl -a $(file)
execute: compile
	ghdl -e $(entity)
runnable: execute
	ghdl -r $(entity) --vcd=$(vcdFile)
gtkwave:
	gtkwave $(vcdFile)
