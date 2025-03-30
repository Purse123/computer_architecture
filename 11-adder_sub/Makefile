file=AdderSubtractor4Bit.vhd
entity=Testbench
vcdFile=AdderSubtractor4Bit.vcd

compile:
	ghdl -a $(file)
execute:
	ghdl -e $(entity)
runnable:
	ghdl -r $(entity) --vcd=$(vcdFile)
gtkwave:
	gtkwave $(vcdFile)
