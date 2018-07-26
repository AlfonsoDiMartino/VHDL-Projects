library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cla_adder_cell is
	port (	add1, add2, carryin: in std_logic;
		prop, gen, sum: out std_logic);
end cla_adder_cell;

architecture dataflow of cla_adder_cell is
begin
	prop <= add1 or add2;
	gen <= add1 and add2;
	sum <= add1 xor add2 xor carryin;
end dataflow;

