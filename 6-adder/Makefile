file=6-added.vhdl
entity=half_adder
vcdFile=adder.vcd

compile:
	ghdl -a $(file)
execute:
	ghdl -e $(entity)
runnable:
	ghdl -r $(entity) --vcd=$(vcdFile)
gtkwave:
	gtkwave $(vcdFile)
