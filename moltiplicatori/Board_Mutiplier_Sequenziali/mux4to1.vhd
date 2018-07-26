library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- component mux 4 ingressi 1 uscita
entity mux4to1 is
	port	(	data_in		: in std_logic_vector(3 downto 0);		-- dati in ingresso
				data_sel	: in std_logic_vector(1 downto 0);		-- comando selezione
				data_out	: out std_logic							-- dati in uscita
	);
end mux4to1;

architecture dataflow of mux4to1 is
begin

	with data_sel select
	data_out <=	data_in(0) when "00",
				data_in(1) when "01",
				data_in(2) when "10",
				data_in(3) when "11",
				'0' when others;
end;
