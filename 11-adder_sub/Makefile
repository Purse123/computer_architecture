file=AdderSubtractor4Bit.vhd
entity=Testbench
vcdFile=AdderSubtractor4Bit.vcd

compile:
	ghdl -a $(file)
execute: compile
	ghdl -e $(entity)
runnable: execute
	ghdl -r $(entity) --vcd=$(vcdFile)
gtkwave:
	gtkwave $(vcdFile)
