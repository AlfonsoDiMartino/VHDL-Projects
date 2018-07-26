cc = ghdl
cc_opz = --ieee=synopsys
sim_time = 1sec


project : full_adder.o mac_cell.o mac_row.o mac_multiplier.o tb_mac_multiplier.o
	$(cc) -e tb_mac_multiplier
	$(cc) -r tb_mac_multiplier --vcd=tb_mac_multiplier.vcd --stop-time=$(sim_time)
	gtkwave tb_mac_multiplier.vcd

full_adder.o : full_adder.vhd
	$(cc) -a $(cc_opz) $<

mac_cell.o : mac_cell.vhd
	$(cc) -a $(cc_opz) $<

mac_multiplier.o : mac_multiplier.vhd
	$(cc) -a $(cc_opz) $<

mac_row.o : mac_row.vhd
	$(cc) -a $(cc_opz) $<

tb_mac_multiplier.o : tb_mac_multiplier.vhd
	$(cc) -a $(cc_opz) $<
	
clean :
	rm -f tb_mac_multiplier.vcd *.o *.cf tb_mac_multiplier
	
