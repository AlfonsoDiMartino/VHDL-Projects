library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder is
	port (
		sel 		: in std_logic_vector (2 downto 0);
		data_out 	: out std_logic_vector (6 downto 0)
	);
end decoder;

architecture dataflow of decoder is
begin
	
	with sel select
	data_out <=	"0000001" when "001",
				"0000010" when "010",
				"0000100" when "011",
				"0001000" when "100",
				"0010000" when "101",
				"0100000" when "110",
				"1000000" when "111",
				"0000000" when others;

end dataflow;
