library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real."ceil";
use IEEE.math_real."log2";
use ieee.numeric_std.all;

entity counter_modN_1 is
	 Generic(count_max : integer := 3);
    Port ( clock : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           enable : in  STD_LOGIC;
           done : out  STD_LOGIC);
end counter_modN_1;

architecture Behavioral of counter_modN_1 is

signal tmp_done : STD_LOGIC := '0';
signal tmp_count : STD_LOGIC_VECTOR(integer(ceil(log2(real(count_max))))-1 downto 0) := (others => '0');

begin

done <= tmp_done;

process(clock, reset_n, enable,tmp_done) 
		begin
			if(reset_n = '0') then 
				tmp_count <= (others => '0');
				tmp_done <= '0';
			elsif (clock = '1' and clock'event) then 
				if(enable = '1') then
					tmp_count <= std_logic_vector(unsigned(tmp_count)+1);
					tmp_done <= '0';
					if(tmp_count = std_logic_vector(to_unsigned(count_max-1, tmp_count'length))) then
						tmp_done <= '1';
						tmp_count <= (others => '0');
					end if;	
				end if;
			end if;		
		end process;	
end Behavioral;

