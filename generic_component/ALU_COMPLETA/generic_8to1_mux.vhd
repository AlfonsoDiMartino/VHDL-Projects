library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity generic_8to1_mux is
	generic (
		N : integer := 8
	);
	port (
		sel 		: in std_logic_vector(2 downto 0);
		data_in_000 : in std_logic_vector(N-1 downto 0);
		data_in_001 : in std_logic_vector(N-1 downto 0);
		data_in_010 : in std_logic_vector(N-1 downto 0);
		data_in_011 : in std_logic_vector(N-1 downto 0);
		data_in_100 : in std_logic_vector(N-1 downto 0);
		data_in_101 : in std_logic_vector(N-1 downto 0);
		data_in_110 : in std_logic_vector(N-1 downto 0);
		data_in_111 : in std_logic_vector(N-1 downto 0);
		data_out 	: out std_logic_vector(N-1 downto 0)
	);
end generic_8to1_mux;

architecture dataflow of generic_8to1_mux is
begin
	with sel select
		data_out <=	data_in_000 when "000",
					data_in_001 when "001",
					data_in_010 when "010",
					data_in_011 when "011",
					data_in_100 when "100",
					data_in_101 when "101",
					data_in_110 when "110",
					data_in_111 when "111",
					(others => '0') when others;
end dataflow;
