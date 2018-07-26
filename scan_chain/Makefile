cc = ghdl
cc_opz = --ieee=synopsys
sim_time = 1sec
compile = $(cc) -a $(cc_opz) $<
OBJ = muxedDLatch.o muxedBuffer.o cla_adder_cell.o cla_carry_net.o nibble_adder.o generic_cla_adder.o countermod10.o tb_counter.o 

.PHONY : tb_counter

tb_counter : $(OBJ)
	ghdl -e tb_counter
	ghdl -r tb_counter --vcd=tb_counter.vcd --stop-time=500ns
	gtkwave tb_counter.vcd

tb_counter.o : tb_counter.vhd
	$(compile)

countermod10.o : countermod10.vhd
	$(compile)

muxedBuffer.o : muxedBuffer.vhd
	$(compile)

muxedDLatch.o : muxedDLatch.vhd
	$(compile)
	
cla_adder_cell.o : cla_adder_cell.vhd
	$(compile)

cla_carry_net.o : cla_carry_net.vhd
	$(compile)

nibble_adder.o : nibble_adder.vhd
	$(compile)

generic_cla_adder.o : generic_cla_adder.vhd
	$(compile)

clean :
	rm -f $(obj) tb_counter.vcd *.o *.cf tb_counter
