library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock_filter is
	generic (	freq_in_hz : integer := 50000000;
				freq_out_hz : integer := 500);
	
	port (	reset_n		: in std_logic;
			clock_in	: in std_logic;
			clock_out	: out std_logic
	);
end clock_filter;

architecture behavioral of clock_filter is
	
	signal clock_out_tmp : std_logic := '0';

begin
	
	clock_out <= clock_out_tmp;
	
	filter_process : process(reset_n, clock_in)
		constant max : integer := (freq_in_hz / freq_out_hz) - 1;
		variable count : integer := 0;
	begin
	
		if reset_n = '0' then
			count := 0;
		else
			if (clock_in = '1' and clock_in'event) then
				if (count = max) then
					count := 0;
					clock_out_tmp <= '1';
				else
					count := count + 1;
					clock_out_tmp <= '0';
				end if;
			end if;
		end if;
	end process;
	
end;
