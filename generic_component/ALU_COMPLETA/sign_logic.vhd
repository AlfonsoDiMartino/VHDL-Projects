library ieee;
use ieee.std_logic_1164.all;


entity sign_logic is
	port (
		clock		: in std_logic;
		reset_n		: in std_logic;
		load_data	: in std_logic;
		M_msb 		: in std_logic;
		Q_lsb 		: in std_logic;
		correct 	: in std_logic;
		sign 		: out std_logic
	);
end sign_logic;


architecture behavioral of sign_logic is
	signal sign_tmp : std_logic := '0';
begin

	sign <= sign_tmp;
	
	process(clock, reset_n, load_data, M_msb, Q_lsb, correct)
	begin
		if (reset_n = '0') then
			sign_tmp <= '0';
		elsif (clock='1' and clock'event) then
			if (load_data = '1') then
				if (correct = '1') then
					sign_tmp <= (sign_tmp and M_msb and not Q_lsb) or (not sign_tmp and not M_msb and Q_lsb);
					--sign_tmp <= (M_msb and Q_lsb) or sign_tmp; --- proposta 0
					--sign_tmp <= M_msb and Q_lsb; -- proposta (1, non corretta)
				else
					sign_tmp <= (M_msb and Q_lsb) or sign_tmp;
				end if;
			end if;
		end if;
	end process;

end behavioral;		
