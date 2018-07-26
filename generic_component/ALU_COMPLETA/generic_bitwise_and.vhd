library ieee;
use ieee.std_logic_1164.all;

entity generic_bitwise_and is
	generic (
		n : natural := 8
	);
	port (
		data_in_1 	: in std_logic_vector (n-1 downto 0);
		data_in_2 	: in std_logic_vector (n-1 downto 0);
		data_out 	: out std_logic_vector (n-1 downto 0)
	);
end generic_bitwise_and;

architecture dataflow of generic_bitwise_and is

begin

	and_chain : for i in n-1 downto 0 generate
		data_out(i) <= data_in_1(i) and data_in_2(i);
	end generate;

end dataflow;

