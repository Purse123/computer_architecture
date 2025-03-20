file=b2g.vhdl
file1=g2b.vhdl
entity=bin2gray
entity1=gray2bin
vcdFile=bin2gray.vcd
vcdFile1=gray2bin.vcd

compile:
	ghdl -a $(file)
execute:
	ghdl -e $(entity)
runnable:
	ghdl -r $(entity) --vcd=$(vcdFile)
gtkwave:
	gtkwave $(vcdFile)

compile1:
	ghdl -a $(file1)
execute1:
	ghdl -e $(entity1)
runnable1:
	ghdl -r $(entity1) --vcd=$(vcdFile1)
gtkwave1:
	gtkwave $(vcdFile1)
