library ieee;
use ieee.std_logic_1164.all;

entity myNOR3 is
	generic (
		delay : time := 10 ns
	);
	port (
		input_A : in std_logic;
		input_B : in std_logic;
		input_C : in std_logic;
		output 	: out std_logic
	);
end myNOR3;

architecture dataflow of myNOR3 is
begin
	output <= not (input_A or input_B or input_C) after delay;
end dataflow;
