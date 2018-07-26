library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity generic_adder_subtractor is
	generic (
		nibbles 	: natural := 2
	);
    port (
		x 			: in  std_logic_vector ((nibbles * 4)-1 downto 0);
		y 			: in  std_logic_vector ((nibbles * 4)-1 downto 0);
		sub_add_n	: in  std_logic;
		sum 		: out  std_logic_vector ((nibbles * 4)-1 downto 0);
		carry_out	: out  std_logic;
		overflow 	: out  std_logic
    );
end generic_adder_subtractor;

architecture structural of generic_adder_subtractor is

	-- adder generico
	component generic_adder is
		generic (nibbles : natural := 2);	-- l'adder va instanzializzato in nibble (4 bit)
											-- es. un adder cla a 16 bit va instanzializzato usado
											-- nibbles = 4
		port (	carry_in : in  std_logic;								-- carry in ingresso
				x : in  std_logic_vector ((nibbles * 4)-1 downto 0);	-- primo addendo
				y : in  std_logic_vector ((nibbles * 4)-1 downto 0);	-- secondo addendo
				sum : out  std_logic_vector ((nibbles * 4)-1 downto 0);	-- risultato della somma
				carry_out : out std_logic								-- carry in uscita
			);
	end component;
	
	-- ##### cambiare la seguente per cambiare il sommatore usato
	for all : generic_adder use entity work.generic_cla_adder;

	-- invertitore xor usato per complementare uno degli addendi quando l'ingresso sub_add_n
	-- e' alto
	component generic_xor_inverter is
		generic (N : natural := 4);								-- numero di bit
		port ( data_in : in  std_logic_vector (N-1 downto 0);	-- ingresso dati
			   invert : in  std_logic;								-- comando inverti
			   data_out : out  std_logic_vector (N-1 downto 0));	-- uscita dati
	end component;
	


	-- segnali di uscita dall'invertitore xor
	signal xorinv_out : std_logic_vector ((nibbles * 4)-1 downto 0);
	
	signal carry 	: std_logic;
	signal sum_tmp	: std_logic_vector ((nibbles * 4)-1 downto 0);

begin

	xor_inv :	generic_xor_inverter
		generic map (nibbles * 4)
		port map (	data_in => y,
					invert => sub_add_n,
					data_out => xorinv_out
		);
							
	g_adder :	generic_adder
		generic map (nibbles)
		port map (	sub_add_n,
					x => x,
					y => xorinv_out,
					sum => sum_tmp,
					carry_out => carry
		);
				
	sum <= sum_tmp;
	carry_out <= carry;
	overflow <= (not x((nibbles * 4)-1) and not y((nibbles * 4)-1) and sum_tmp((nibbles * 4)-1) and not carry) or 
				(x((nibbles * 4)-1) and y((nibbles * 4)-1) and not sum_tmp((nibbles * 4)-1) and carry);
				

end structural;

