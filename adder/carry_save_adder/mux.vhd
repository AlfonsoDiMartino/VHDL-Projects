library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux is
	port (
		in0 : in std_logic_vector(7 downto 0);
		in1 : in std_logic_vector(7 downto 0);
		in2 : in std_logic_vector(7 downto 0);
		sel : in std_logic_vector(1 downto 0);
		data_out : out std_logic_vector(7 downto 0)
	);
end mux;

architecture dataflow of mux is
begin

	with sel select
		data_out <=	in0 when "01",
					in1 when "10",
					in2 when "11",
					x"00" when others;

end dataflow;
