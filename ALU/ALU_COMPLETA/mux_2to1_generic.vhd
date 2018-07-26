library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.all;

entity mux_2to1_generic is
	generic(N:natural := 4);
	port (	X : in std_logic_vector (N-1 downto 0);
				Y : in std_logic_vector (N-1 downto 0);
				S : in std_logic;
				Z : out std_logic_vector(N-1 downto 0)
				);
end mux_2to1_generic;

architecture Behavioral of mux_2to1_generic is

begin
	Z 	<=	X when S = '0' else
			Y when S = '1';
end Behavioral;

