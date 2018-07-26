library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- invertitore xor di nbit generico
-- pensato per l'uso in un addizionatore per sottrazioni con complemento a due

entity generic_xor_inverter is
	generic (N : natural:= 8);								-- numero di bit
    Port ( data_in : in  STD_LOGIC_VECTOR (N-1 downto 0);	-- ingresso dati
           invert : in  STD_LOGIC;								-- comando inverti
           data_out : out  STD_LOGIC_VECTOR (N-1 downto 0));	-- uscita dati
end generic_xor_inverter;

architecture structural of generic_xor_inverter is

begin
	xor_chain : for i in 0 to N-1 generate
		data_out(i) <= data_in(i) xor invert;
	end generate;
end structural;

