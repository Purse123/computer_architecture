file=decoder.vhdl
file1=encoder.vhdl
entity=decoder2to4
entity1=encoder4to2
vcdFile=decoder2to4.vcd
vcdFile1=encoder4to2.vcd

compile:
	ghdl -a $(file)
execute: compile
	ghdl -e $(entity)
runnable: execute
	ghdl -r $(entity) --vcd=$(vcdFile)
gtkwave:
	gtkwave $(vcdFile)

compile1:
	ghdl -a $(file1)
execute1: compile1
	ghdl -e $(entity1)
runnable1: execute1
	ghdl -r $(entity1) --vcd=$(vcdFile1)
gtkwave1:
	gtkwave $(vcdFile1)
