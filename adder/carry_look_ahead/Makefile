cc = ghdl
cc_opz = --ieee=synopsys
sim_time = 1sec
compile = $(cc) -a $(cc_opz) $<
obj = cla_adder_cell.o 	\
cla_carry_net.o \
nibble_adder.o \
generic_cla_adder.o \
tb_generic_cla_adder.o

.PHONY : all clean

all : $(obj)


clean :
	rm -rf $(obj) tb_generic_cla_adder tb_generic_cla_adder.vcd work-obj93.cf

tb_generic_cla_adder : $(obj)
	$(cc) -e tb_generic_cla_adder
	$(cc) -r tb_generic_cla_adder --vcd=tb_generic_cla_adder.vcd --stop-time=$(sim_time)
	gtkwave tb_generic_cla_adder.vcd

cla_adder_cell.o : cla_adder_cell.vhd
	$(compile)

cla_carry_net.o : cla_carry_net.vhd
	$(compile)

nibble_adder.o : nibble_adder.vhd
	$(compile)

generic_cla_adder.o : generic_cla_adder.vhd
	$(compile)

tb_generic_cla_adder.o : tb_generic_cla_adder.vhd
	$(compile)

