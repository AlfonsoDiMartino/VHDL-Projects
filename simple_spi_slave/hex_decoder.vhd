library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- decoder BCD per display a 7 segmenti ad anodo comune,
-- con visualizzazione delle cifre esadecimali
--		__a
--	  f|  | b
--	 	--g
--	  e|__| c
--		d
-- a = seg_on_n(0)
-- b = seg_on_n(1)
-- ...
-- g = seg_on_n(6) 

entity hex_decoder is
	port	(	data_in : in std_logic_vector(3 downto 0);
				seg_on_n : out std_logic_vector(6 downto 0)
	);
end hex_decoder;

architecture dataflow of hex_decoder is
begin
	with data_in select
	seg_on_n <=		"1000000" when "0000",
					"1111001" when "0001",
					"0100100" when "0010",
					"0110000" when "0011",
					"0011001" when "0100",
					"0010010" when "0101",
					"0000010" when "0110",
					"1111000" when "0111",
					"0000000" when "1000",
					"0010000" when "1001",
					"0001000" when "1010",
					"0000011" when "1011",
					"1000110" when "1100",
					"0100001" when "1101",
					"0000110" when "1110",
					"0001110" when "1111",
					"1111111" when others;
end;
