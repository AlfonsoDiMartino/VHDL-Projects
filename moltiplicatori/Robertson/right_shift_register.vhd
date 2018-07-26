library ieee;
use ieee.std_logic_1164.all;

entity right_shift_register is
	generic (
		N : natural := 8
	);
	port (
		clock			: in std_logic;
		reset_n 		: in std_logic;
		load_data 		: in std_logic;
		shift			: in std_logic;
		serial_in 		: in std_logic;
		parallel_in 	: in std_logic_vector(N-1 downto 0);
		serial_out 		: out std_logic;
		parallel_out 	: out std_logic_vector(N-1 downto 0)
	);
end right_shift_register;


architecture behavioral of right_shift_register is
	signal data : std_logic_vector(N-1 downto 0);
begin
	serial_out <= data(0);
	parallel_out <= data;
	
	process(clock, reset_n, load_data, shift, parallel_in)
	begin
		if (reset_n = '0') then
			data <= (others => '0');
		elsif (clock='1' and clock'event) then
			if (load_data = '1') then
				data <= parallel_in;
			elsif (shift = '1') then
				data <= serial_in & data(N-1 downto 1);
			end if;
		end if;
	end process;

end behavioral;

