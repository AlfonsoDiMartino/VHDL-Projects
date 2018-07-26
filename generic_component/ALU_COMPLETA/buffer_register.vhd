library ieee;
use ieee.std_logic_1164.all;

entity buffer_register is
	generic	(
		N : natural := 8
	);
	port (
		clk 	: in  STD_LOGIC;
		load 	: in  STD_LOGIC;
		clear_n : in STD_LOGIC;
		I 		: in  STD_LOGIC_VECTOR (N-1 downto 0);
		Q 		: out  STD_LOGIC_VECTOR (N-1 downto 0)
	);
end buffer_register;

architecture Behavioral of buffer_register is
	signal Q_tmp : std_logic_vector(N-1 downto 0);
begin

	Q <= Q_tmp;
	
	process (I,clk,load,clear_n)
	begin
		if (clear_n = '0') then
			Q_tmp <= (others =>'0');
		elsif (clk = '1' and clk'event) then
			if (load = '1') then
				Q_tmp <= I;
			end if;
		end if;		 
	end process;
	
end Behavioral;

