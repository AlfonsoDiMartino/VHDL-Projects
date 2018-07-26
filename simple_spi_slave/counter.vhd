library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- contatore modulo 4
entity counter is
	port	(	reset_n 	: in std_logic;
				clock		: in std_logic;
				enable		: in std_logic;
				count_out	: out std_logic_vector(1 downto 0)
	);
end counter;

architecture behavioral of counter is

	signal tmp_count : std_logic_vector(1 downto 0) := (others => '0');

begin
	
	count_proc : process (reset_n, clock, enable)
	begin
	
		if ( reset_n = '0' ) then
			tmp_count <= (others => '0');
		else
			if (clock = '1' and clock'event) then
				if (enable = '1') then
					tmp_count <= std_logic_vector(unsigned(tmp_count) + 1);
				end if;
			end if;
		end if;

	end process;
	
	count_out <= tmp_count;
end;
