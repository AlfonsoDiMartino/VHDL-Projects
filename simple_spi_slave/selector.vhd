library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- componente selector, "demux" a due ingressi e 4 uscite selezionabili
-- l'uscita non selezionata e' a livello logico alto
-- l'uscita è portata a livello logico basso quando selezionata
entity selector is
	port (	display_en		: in std_logic_vector(3 downto 0);
			-- se display_en(i) = '1' allora il diplay i-esimo è acceso
	
			display_sel		: in std_logic_vector(1 downto 0);
			display_on_n	: out std_logic_vector(3 downto 0)
	);
end selector;

architecture dataflow of selector is
begin
	
	display_on_n(0) <= '0' when (display_en(0) = '1' and display_sel="00") else '1';
	display_on_n(1) <= '0' when (display_en(1) = '1' and display_sel="01") else '1';
	display_on_n(2) <= '0' when (display_en(2) = '1' and display_sel="10") else '1';
	display_on_n(3) <= '0' when (display_en(3) = '1' and display_sel="11") else '1';
	
end dataflow;
