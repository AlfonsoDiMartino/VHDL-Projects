
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity decoder_2to4 is
    Port ( data_in : in  STD_LOGIC_VECTOR (1 downto 0);
           data_out : out  STD_LOGIC_VECTOR (3 downto 0));
end decoder_2to4;

architecture Data_Flow of decoder_2to4 is

begin

	with data_in select
	data_out<=  "0001" when "00",	   	--0-14 secondi, primo led acceso
					"0010" when "01",			--15-29 secondi, secondo led acceso
					"0100" when "10",			--30-44 secondi, terzo led acceso
					"1000" when "11",			--45-59 secondi, quarto led acceso
					"0000" when others;		
end Data_Flow;


