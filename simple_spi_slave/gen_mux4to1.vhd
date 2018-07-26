library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- component mux 4 ingressi 1 uscita, generico per parallelismo di dati di ingresso/uscita
entity gen_mux4to1 is
	generic (nbit : natural := 4);											-- parallelismo dei dati
	port	(	data_in		: in std_logic_vector ((nbit*4)-1 downto 0);	-- dati in ingresso
				data_sel	: in std_logic_vector (1 downto 0);				-- comando selezione
				data_out	: out std_logic_vector (nbit-1 downto 0)		-- dati in uscita
	);
end gen_mux4to1;

architecture dataflow of gen_mux4to1 is

	alias part0 is data_in(nbit-1 downto 0);
	alias part1 is data_in((2*nbit)-1 downto nbit);
	alias part2 is data_in((3*nbit)-1 downto 2*nbit);
	alias part3 is data_in((4*nbit)-1 downto 3*nbit);

begin

	data_out <=	part0 when data_sel = "00" else
				part1 when data_sel = "01" else
				part2 when data_sel = "10" else
				part3 when data_sel = "11";
end;
	
