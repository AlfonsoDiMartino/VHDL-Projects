library ieee;
use ieee.std_logic_1164.all;

entity myAND is
	generic (
		delay : time := 10 ns
	);
	port (
		input_A : in std_logic;
		input_B : in std_logic;
		output 	: out std_logic
	);
end myAND;


architecture dataflow of myAND is
begin
	output <=  (input_A and input_B) after delay;
end dataflow;

