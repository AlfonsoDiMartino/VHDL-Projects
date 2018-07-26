library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_counter is
	port (
		clock		: in std_logic;
		reset_n		: in std_logic;
		count_in	: in std_logic;
		count_out	: out std_logic_vector(1 downto 0)
	);
end reg_counter;


architecture behavioral of reg_counter is

	signal count_out_tmp : std_logic_vector(1 downto 0) := (others => '0');

begin

	count_out <= count_out_tmp;

	count_process : process (clock, reset_n, count_in)
	begin
		if ( reset_n = '0' ) then
			count_out_tmp <= (others => '0');
		elsif (clock = '1' and clock'event) then
			if (count_in = '1') then
				count_out_tmp <= std_logic_vector(unsigned(count_out_tmp) + 1);
			end if;
		end if;
	end process;

end behavioral;
		
