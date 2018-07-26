library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity invert is
	generic (delay : time := 100 ps);
    Port ( i : in  STD_LOGIC;
           inv_o : out  STD_LOGIC);
end invert;

architecture Behavioral of invert is

begin

inv_o <= not i after delay;
end Behavioral;

