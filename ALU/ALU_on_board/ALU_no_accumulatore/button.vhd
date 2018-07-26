library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity button_debouncer is
	generic (lazy : natural := 26); 		-- lazy indica quanto il pulsante è pigro. più è alto
											-- più tempo dovrà intercorrere tra una pressione e la
											-- successiva affinché possano essere rilevate
	port (
		clock		: in std_logic;
		reset_n		: in std_logic;
		key			: in std_logic;
		pulse		: out std_logic
	);
end button_debouncer;


architecture behavioral of button_debouncer is
	
	signal count : std_logic_vector (lazy downto 0) := (others => '0');

begin

	process (clock, reset_n, key,count)
	begin
	
		pulse <= count(lazy);
	
		if (reset_n = '0') then
			count <= (others => '0');
		elsif (clock = '1' and clock'event) then
				if (key = '1') then
					if (count(lazy) = '0') then
						count <= std_logic_vector(unsigned(count) + 1);
					else
						count <= (others => '0');
					end if;
				else
					count <= (others => '0');
				end if;
		end if;
	end process;

end behavioral;
