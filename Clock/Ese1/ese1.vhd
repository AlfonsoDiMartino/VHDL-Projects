
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity ese1 is
    Port ( output : out  STD_LOGIC);
end ese1;

architecture Behavioral of ese1 is

begin

main: process
begin
	output <= '0', '1' after 25 ns, '0' after 35 ns, '1' after 50 ns, '0' after 75 ns,
				 '1' after 105 ns, '0' after 110 ns, '1' after 155 ns, '0' after 175 ns,
				 '1' after 195 ns, '0' after 235 ns;
	wait for 280 ns;


end process;


end Behavioral;

