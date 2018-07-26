library ieee;
use ieee.std_logic_1164.all;

entity sck_filter is 
	port (
		clock	 	: in std_logic;
		reset_n 	: in std_logic;
		en_in		: in std_logic;
		en_out 		: out std_logic
	);
end sck_filter;

architecture behavioral of sck_filter is

	type state is (idle, locked, unlocked);
	signal curr_state : state := idle;
	signal next_state : state := idle;
	signal out_tmp : std_logic := '0';

begin

	en_out <= out_tmp;
	
	stp : process(clock)
	begin
		if (clock = '1' and clock'event) then
			curr_state <= next_state;
		end if;
	end process;
	
	
	scp : process(reset_n, curr_state, en_in)
	begin
	
		out_tmp <= '0';
		
		if (reset_n = '0') then
			next_state <= idle;
		else
			case curr_state is
			
				when idle =>
					if (en_in = '1') then
						next_state <= unlocked;
					else
						next_state <= idle;
					end if;
				
				when unlocked =>
					out_tmp <= '1';
					next_state <= locked;
				
				when locked =>
					if (en_in = '0') then
						next_state <= idle;
					else
						next_state <= locked;
					end if;
			end case;
		end if;
					
	
	end process;

end behavioral;
		
