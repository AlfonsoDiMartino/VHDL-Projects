library ieee;
use ieee.std_logic_1164.all;

entity buffer_register is
	generic( n : natural := 8);
	port (
		i 		: in std_logic_vector (n-1 downto 0);
		clk		: in std_logic;
		load	: in std_logic;
		clear_n	: in std_logic;
		q		: out std_logic_vector (n-1 downto 0)
	);
end buffer_register;

architecture behavioral of buffer_register is
	signal q_tmp : std_logic_vector(n-1 downto 0);
begin
	process (i,clk,load,clear_n)
	begin
		if (clear_n = '0') then
			q_tmp <= (q_tmp'range =>'0');
		elsif (clk = '1' and clk'event) then
			if (load = '1') then
				q_tmp <= i;
			end if;
		end if;		 
	end process;
	q <= q_tmp;
end behavioral;


