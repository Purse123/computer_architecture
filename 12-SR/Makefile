file=sr_flipflop.vhd
entity=Testbench
vcdFile=sr_flipflop.vcd

compile:
	ghdl -a $(file)
execute:
	ghdl -e $(entity)
runnable:
	ghdl -r $(entity) --vcd=$(vcdFile)
gtkwave:
	gtkwave $(vcdFile)
