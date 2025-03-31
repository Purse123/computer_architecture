file=cpu.v
vcdFile=ALU4Bit.vcd

runnable:
	iverilog $(file) -o output
	./output

gtkwave:
	gtkwave $(vcdFile)
