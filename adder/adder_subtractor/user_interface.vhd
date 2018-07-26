library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity user_interface is
	port (	clock		: in std_logic;
			-- segnali "utente"
			reset		: in std_logic;
			loadX		: in std_logic;
			loadY		: in std_logic;
			data_in 	: in std_logic_vector(7 downto 0);
			-- segnali di controllo per il driver del display
			reset_n		: out std_logic;
			display_data: out std_logic_vector(15 downto 0);
			-- segnali per l'adder
			X 			: out std_logic_vector(7 downto 0);
			Y			: out std_logic_vector(7 downto 0);
			sum			: in std_logic_vector(7 downto 0)
	);
end user_interface;


architecture behavioral of user_interface is
begin
	reset_n <= not reset;
	
	process(clock, reset, loadX, loadY, sum)
	begin
		if reset = '1' then
			X <= x"00";
			Y <= x"00";
		elsif (clock = '1' and clock'event) then
			if (loadX = '1') then
				X <= data_in;
			elsif (loadY = '1') then
				Y <= data_in;
			end if;
		end if;
		display_data <= x"00" & sum;
	end process;

end;
