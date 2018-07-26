library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity generic_counter is
	generic (
		N : integer := 8
	);
	port (
		clock 		: in std_logic;
		reset_n 	: in std_logic;
		enable 		: in std_logic;
		load 		: in std_logic;
		count_in 	: in std_logic_vector(N-1 downto 0);
		count_max 	: in std_logic_vector(N-1 downto 0);
		count_out 	: out std_logic_vector(N-1 downto 0);
		done 		: out std_logic
	);
end generic_counter;


architecture behavioral of generic_counter is

	signal count_out_tmp 	: std_logic_vector(N-1 downto 0) := (others => '0');
	signal done_tmp			: std_logic := '0';
	
begin

	done <= done_tmp;
	count_out <= count_out_tmp;

	-- processo di conteggio
	process(clock, reset_n, enable, count_max)
	begin
		if ( reset_n = '0' ) then
			count_out_tmp <= (others => '0');
			done_tmp <= '0';
		elsif (clock = '1' and clock'event) then
			if load = '1' then
				count_out_tmp <= count_in;
			elsif (enable = '1') then
				if (count_out_tmp = count_max) then
					count_out_tmp <= (others => '0');
					done_tmp <= '1';
				else
				count_out_tmp <= std_logic_vector(unsigned(count_out_tmp) + 1);
				done_tmp <= '0';
				end if;
			end if;
		end if;
	end process;
	
--	-- processo di determinazione condizione di done
--	process (reset_n, count_out_tmp, count_max)
--	begin
--		if ( reset_n = '0' ) then
--			done_tmp <= '0';
--		elsif (count_out_tmp = count_max) then
--			done_tmp <= '1';
--		else
--			done_tmp <= '0';
--		end if;
--	end process;

end behavioral;
		
