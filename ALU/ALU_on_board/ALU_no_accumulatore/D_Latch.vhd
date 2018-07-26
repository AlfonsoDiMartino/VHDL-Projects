library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity D_Latch is
    Port ( i : in  STD_LOGIC;
           clock : in  STD_LOGIC;
           load : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           q : out  STD_LOGIC);
end D_Latch;

architecture Behavioral of D_Latch is

signal tmp_q : std_logic:='0';

begin


main: process( clock, reset_n, load)
begin
	if (reset_n = '0') then
		tmp_q <= '0';
	elsif (clock = '1' and clock'event) then
		if (load = '1') then
			tmp_q <= i;
		end if;
	end if;

end process;

q <= tmp_q;

end Behavioral;

