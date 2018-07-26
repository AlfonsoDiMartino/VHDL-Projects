library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RCA_subtractor is
	generic (N 	: natural := 8);
	
    port ( x 			: in  std_logic_vector (N-1 downto 0);
           y 			: in  std_logic_vector (N-1 downto 0);
           sub_add_n	: in  std_logic;
           sum 			: out  std_logic_vector (N-1 downto 0);
           carry_out	: out  std_logic
           --overflow 	: out  std_logic
    );
end RCA_subtractor;

architecture structural of RCA_subtractor is
	-- invertitore xor usato per complementare uno degli addendi quando l'ingresso sub_add_n
	-- e' alto
	component generic_xor_inverter is
		generic (N : natural);								-- numero di bit
		port ( data_in : in  std_logic_vector (N-1 downto 0);	-- ingresso dati
			   invert : in  std_logic;								-- comando inverti
			   data_out : out  std_logic_vector (N-1 downto 0));	-- uscita dati
	end component;
	
COMPONENT ripple_carry_adder
	generic (N: natural);
	PORT(
		x : IN std_logic_vector(N-1 downto 0);
		y : IN std_logic_vector(N-1 downto 0);
		carry_in : IN std_logic;          
		carry_out : OUT std_logic;
		sum : OUT std_logic_vector(N-1 downto 0)
		);
	END COMPONENT;

	

	-- segnali di uscita dall'invertitore xor
	signal xorinv_out : std_logic_vector (N-1 downto 0);
	
	signal carry 	: std_logic;
	signal sum_tmp	: std_logic_vector (N-1 downto 0);

begin

	xor_inv :	generic_xor_inverter
		generic map (N)
		port map (	data_in => y,
					invert => sub_add_n,
					data_out => xorinv_out
		);
							
	
		
	Inst_ripple_carry_adder: ripple_carry_adder 
	GENERIC MAP(N)
	PORT MAP(
		x => x,
		y => xorinv_out,
		carry_in => sub_add_n,
		carry_out => carry,
		sum => sum_tmp
	);
				
	sum <= sum_tmp;
	carry_out <= carry;
	
end structural;

