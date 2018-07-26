library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity esercizio_3 is
	port(clk_base : out std_logic;
			forma_clk : out std_logic );
end esercizio_3;

architecture Behavioral of esercizio_3 is

signal tmp_out : std_logic := '0';
signal clk : std_logic := '0';

begin

forma_clk <= tmp_out;
clk_base <= clk;

-------------------------------------------------------
---------- PROCESSO CHE GENERA IL CLOCK BASE ----------
-------------------------------------------------------
clk_base_gen : process(clk)
	begin
		clk <= not clk after 10 ns;
	end process;
	
-------------------------------------------------------
---------- PROCESSO CHE GENERA IL PATTERN  ----------
-------------------------------------------------------

forma_clk_gen : process(clk)	
	variable count_rising , count_falling  : integer := 0;
			begin
				if (clk = '1' and clk'event) then
					count_rising := count_rising +1;
					if(count_rising = 15)	then
						tmp_out <= '1';
					elsif(count_rising = 49) then
						tmp_out <= '0';
					end if;
				end if;
				if (clk = '0' and clk'event) then
					count_falling := count_falling +1;
					if(count_falling = 24)	then
						tmp_out <= '0';
					elsif(count_falling = 39) then
						tmp_out <= '1';
					end if;
				end if;	
				
				if(count_rising = 49 and count_falling = 49) then
					count_rising := 0;
					count_falling := 0;
				end if;	
			end process;	
						
end Behavioral;