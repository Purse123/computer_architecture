file=sr_flipflop.vhd
entity=sr
vcdFile=sr_flipflop.vcd

compile:
	ghdl -a $(file)
execute: compile
	ghdl -e $(entity)
runnable: execute
	ghdl -r $(entity) --vcd=$(vcdFile)
gtkwave:
	gtkwave $(vcdFile)
