library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity op_counter is
	generic (
		nbit : natural := 8
	);
	port (
		clock 		: in std_logic;
		reset_n 	: in std_logic;
		count		: in std_logic;																			-- comando incrementa conteggio
		count_out	: out std_logic_vector(integer(ceil(log2(real(nbit))))-1 downto 0)						-- segnale "passo corrente"
	);
end op_counter;


architecture behavioral of op_counter is
	signal count_tmp : std_logic_vector(integer(ceil(log2(real(nbit))))-1 downto 0) := (others => '0');
begin

	count_out <= count_tmp;

	process (clock, reset_n, count)
	begin
		if (reset_n = '0') then
			count_tmp <= (others => '0');
		elsif (clock = '1' and clock'event) then
			if (count = '1') then
				count_tmp <= std_logic_vector(unsigned(count_tmp) + 1);
			end if;
		end if;
	end process;

end behavioral;
