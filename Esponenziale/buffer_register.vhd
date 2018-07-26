library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity buffer_register is
generic( n : natural := 8);
    Port ( data_in : in  STD_LOGIC_VECTOR (n-1 downto 0);
           clock : in  STD_LOGIC;
           load_data : in  STD_LOGIC;
			  reset_n : in STD_LOGIC;
           data_out : out  STD_LOGIC_VECTOR (n-1 downto 0));
end buffer_register;

architecture Behavioral of buffer_register is

signal Q_tmp : std_logic_vector(n-1 downto 0);
begin
	process (data_in,clock,load_data,reset_n)
	


	begin
	if (reset_n = '0') then
		Q_tmp <= (Q_tmp'range =>'0');
	elsif (clock = '1' and clock'event) then
		if (load_data = '1') then
			Q_tmp <= data_in;
		end if;
	end if;		 
	end process;
	data_out <= Q_tmp;
end Behavioral;

