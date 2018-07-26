library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder is
	port (
		sel 		: in std_logic_vector (1 downto 0);
		data_out 	: out std_logic_vector (2 downto 0)
	);
end decoder;

architecture dataflow of decoder is
begin
	
	with sel select
	data_out <=	"001" when "01",
				"010" when "10",
				"100" when "11",
				"000" when others;

end dataflow;
