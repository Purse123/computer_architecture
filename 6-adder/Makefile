file=6-added.vhdl
entity=half_adder
vcdFile=adder.vcd

compile:
	ghdl -a $(file)
execute: compile
	ghdl -e $(entity)
runnable: execute
	ghdl -r $(entity) --vcd=$(vcdFile)
gtkwave:
	gtkwave $(vcdFile)

file1=6-full-added.vhdl
entity1=full_adder
vcdFile1=full_adder.vcd

compile1:
	ghdl -a $(file1)
execute1: compile1
	ghdl -e $(entity1)
runnable1: execute1
	ghdl -r $(entity1) --vcd=$(vcdFile1)
gtkwave1:
	gtkwave $(vcdFile1)
