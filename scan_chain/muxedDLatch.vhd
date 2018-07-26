library ieee;
use ieee.std_logic_1164.all;

entity muxeddlatch is
	generic (
			edge : std_logic := '1' -- 1 = rising edge, 0 = falling edge
	);
	port ( 	clk 		: in std_logic;
			reset_n 	: in std_logic;		-- reset asincrono ha priorita' massima
			load		: in std_logic;		-- load asincrono ha priorita' su tutto eccetto che su reset
			datain 		: in std_logic;
			dataout 	: out std_logic;
			scanen 		: in std_logic;		-- abilita
			scanin 		: in std_logic
	);
end muxeddlatch;

architecture behavioral of muxeddlatch is
	signal d : std_logic := '0';
begin
	mdl : process(clk, reset_n, load, scanen, datain, scanin)
	begin
	
		if (reset_n = '0') then
			d <= '0';
		else
			if (load = '1') then
				d <= datain;
			elsif (clk = edge and clk'event) then
				if (scanen = '1') then
					d <= scanin;
				else
					d <= datain;
				end if;
			end if;
		end if;
	
	end process;
	
	dataout <= d;
	
end behavioral;

