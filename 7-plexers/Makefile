file=7-plexer.vhdl
file2=7-dmux.vhdl
entity1=mux4to1
entity2=dmux1to4
vcdFile1=plexer.vcd
vcdFile2=dmux1to4.vcd

compile1:
	ghdl -a $(file)
compile2:
	ghdl -a $(file2)
execute1: compile1
	ghdl -e $(entity1)
execute2: compile2
	ghdl -e $(entity2)
runnable: execute1
	ghdl -r $(entity1) --vcd=$(vcdFile1)
runnable2: execute2
	ghdl -r $(entity2) --vcd=$(vcdFile2)
gtkwave1:
	gtkwave $(vcdFile1)
gtkwave2:
	gtkwave $(vcdFile2)
