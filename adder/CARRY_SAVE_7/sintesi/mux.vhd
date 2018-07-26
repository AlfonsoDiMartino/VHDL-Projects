library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux is
	port (
		in0 : in std_logic_vector(7 downto 0);
		in1 : in std_logic_vector(7 downto 0);
		in2 : in std_logic_vector(7 downto 0);
		in3 : in std_logic_vector(7 downto 0);
		in4 : in std_logic_vector(7 downto 0);
		in5 : in std_logic_vector(7 downto 0);
		in6 : in std_logic_vector(7 downto 0);
		sel : in std_logic_vector(2 downto 0);
		data_out : out std_logic_vector(7 downto 0)
	);
end mux;

architecture dataflow of mux is
begin

	with sel select
		data_out <=	in0 when "001",
					in1 when "010",
					in2 when "011",
					in3 when "100",
					in4 when "101",
					in5 when "110",
					in6 when "111",
					x"00" when others;

end dataflow;
