library ieee;
use ieee.std_logic_1164.all;

entity buffer_register is
	generic (
		nbit : natural := 8;
		edge : std_logic := '1'		-- '1' = rising_edge		
	);
	port (
		clock			: in std_logic;
		reset_n 		: in std_logic;
		load_data 		: in std_logic;
		data_in 		: in std_logic_vector(nbit-1 downto 0);
		data_out	 	: out std_logic_vector(nbit-1 downto 0)
	);
end buffer_register;


architecture behavioral of buffer_register is
	signal data : std_logic_vector(nbit-1 downto 0);
begin
	data_out <= data;
	
	process(clock, reset_n, load_data, data_in)
	begin
		if (reset_n = '0') then
			data <= (others => '0');
		elsif (clock=edge and clock'event) then
			if (load_data = '1') then
				data <= data_in;
			end if;
		end if;
	end process;

end behavioral;


