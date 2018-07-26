--------------------------------------------------------------------------------------------------
-- conf: 	stabilisce il tipo di operazione da effettuare e la semantica degli operandi (vedi),
--			di status (vedi) e di result (vedi).
--			000 : add (operand1 + operand2), addizione signed con complemento a due
--			001 : sub (operand1 - operand2), sottrazione signed con complemento a due
--			010 : mul (operand1 * operand2), moltiplicazione signed con
--			011 : div (operand1 / operand2), divisione intera unsigned
--			100 : pow (operand1 ^ operand2), elevamento a potenza unsigned
--
-- status :	riporta lo stato dell'alu dopo l'ultima operazione eseguita. I bit hanno semantica
--			differente a seconda dell'operazione che si sta effettuando (vedi conf).
--			000 : (add) status(0): carry; status(1): overflow;
--			001 : (sub) status(0): carry; status(1): overflow;
--			010 : (mul) status(0): done; status(1): mul_by_zero;
--			011 : (div) status(0): done; status(1): div_by_zero;
--			100 : (pow) status(0): done; status(1): result troncato;
--
-- result :	riporta il risultato dell'ultima operazione effettuata dall'alu. Assume semantica
--			diversa a seconda del tipo di operazione effettuata. Detti resultH i bit da 2N-1 a N
--			di result, e resultL i bit da N-1 a 0 allora:
--			000 : (add) resultH: 0; resultL: risultato della somma;
--			001 : (sub) resultH: 0; resultL: risultato della sottrazione;
--			010 : (mul) resultH & resultL prodotto
--			011 : (div) resultH: resto; resultL: quoziente;
--			100 : (pow) resultH & resultL: 
--------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity ALU is
	generic (
		N : integer := 8
	);
	port (
		clock		: in std_logic;
		reset_n		: in std_logic;
		start		: in std_logic;
		operand1	: in std_logic_vector(N-1 downto 0);
		operand2	: in std_logic_vector(N-1 downto 0);
		conf		: in std_logic_vector(2 downto 0);
		status		: out std_logic_vector(1 downto 0);
		result		: out std_logic_vector(2*N-1 downto 0)
	);
end ALU;

architecture structural of ALU is

	----------------------------------------------------------------------------------------------
	-- componenti
	----------------------------------------------------------------------------------------------
	component generic_adder_subtractor is
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
	end component;


	component multiplier is
		generic (
			N : natural := 8
		);
		port (
			clock 			: in std_logic;
			reset_n 		: in std_logic;
			start 			: in std_logic;		-- avvia il processo di moltiplicazione
			
			mul_by_zero		: out std_logic;	-- indica se il moltiplicatore e' zero
			done 			: out std_logic;	-- quando alto indica la fine del processo di calcolo
			
			X 				: in std_logic_vector(N-1 downto 0);
			Y 				: in std_logic_vector(N-1 downto 0);
			Prod 			: out std_logic_vector((2*N)-1 downto 0)
		);
	end component;


	component divider is
		generic (
			N : natural := 8
		);
		port (
			clock 			: in std_logic;
			reset_n 		: in std_logic;
			start 			: in std_logic;		-- avvia il processo di moltiplicazione
			
			div_by_zero		: out std_logic;	-- indica se il divisore e' zero
			done 			: out std_logic;	-- quando alto indica la fine del processo di calcolo
			
			D				: in std_logic_vector(N-1 downto 0);			-- dividendo
			V 				: in std_logic_vector(N-1 downto 0);			-- divisore
			Q				: out std_logic_vector(N-1 downto 0);			-- quoziente
			R				: out std_logic_vector(N-1 downto 0)			-- resto
		);
	end component;
	
	component generic_8to1_mux is
		generic (
			N : integer := 8
		);
		port (
			sel 		: in std_logic_vector(2 downto 0);
			data_in_000 : in std_logic_vector(N-1 downto 0);
			data_in_001 : in std_logic_vector(N-1 downto 0);
			data_in_010 : in std_logic_vector(N-1 downto 0);
			data_in_011 : in std_logic_vector(N-1 downto 0);
			data_in_100 : in std_logic_vector(N-1 downto 0);
			data_in_101 : in std_logic_vector(N-1 downto 0);
			data_in_110 : in std_logic_vector(N-1 downto 0);
			data_in_111 : in std_logic_vector(N-1 downto 0);
			data_out 	: out std_logic_vector(N-1 downto 0)
		);
	end component;
	
	component esponenziale is
		Generic (
			N : natural := 8
		);
		Port ( 
			start 		: in  STD_LOGIC;
			clock 		: in  STD_LOGIC;
			reset_n 	: in  STD_LOGIC;
			base 		: in  STD_LOGIC_VECTOR (N-1 downto 0);
			exp 		: in  STD_LOGIC_VECTOR (N-1 downto 0);
			done 		: out  STD_LOGIC;
			truncate 	: out STD_LOGIC;
			result 		: out  STD_LOGIC_VECTOR ((2*N)-1 downto 0)
		);
	end component;


for all : multiplier use entity work.robertson_multiplier;
for all : divider use entity work.divider_non_restoring;

	----------------------------------------------------------------------------------------------
	-- segnali
	----------------------------------------------------------------------------------------------
	signal sub_add_n 		: std_logic := '0';
	signal sum		 		: std_logic_vector((2*N)-1 downto 0) := (others => '0');
	signal sum_status		: std_logic_vector(1 downto 0) := "01";
	signal prod		 		: std_logic_vector((2*N)-1 downto 0) := (others => '0');
	signal mul_status		: std_logic_vector(1 downto 0) := (others => '0');
	signal div		 		: std_logic_vector((2*N)-1 downto 0) := (others => '0');
	signal div_status		: std_logic_vector(1 downto 0) := (others => '0');
	signal pow		 		: std_logic_vector((2*N)-1 downto 0) := (others => '0');
	signal pow_status		: std_logic_vector(1 downto 0) := (others => '0');
	
	constant res_zero		: std_logic_vector((2*N)-1 downto 0) := (others => '0');
	constant status_zero	: std_logic_vector(1 downto 0) := (others => '0');

begin

	sub_add_n <= '1' when conf = "001" else '0';

	ADD_block : generic_adder_subtractor
		generic map (
			nibbles 	=> N / 4
		)
		port map (
			x 			=> operand1,
			y 			=> operand2,
			sub_add_n	=> sub_add_n,
			sum 		=> sum(N-1 downto 0),
			carry_out	=> sum_status(1),
			overflow 	=> open
		);
		
	sum(2*N-1 downto N) <= (others => sum(N-1));	
		
	MUL_block : multiplier
		generic map (
			N => N
		)
		port map (
			clock 			=> clock,
			reset_n 		=> reset_n,
			start 			=> start,
			mul_by_zero		=> mul_status(1),
			done 			=> mul_status(0),
			X 				=> operand1,
			Y 				=> operand2,
			Prod 			=> prod
		);
		
	DIV_block : divider
		generic map (
			N => N
		)
		port map (
			clock 			=> clock,
			reset_n 		=> reset_n,
			start 			=> start,
			div_by_zero		=> div_status(1),
			done 			=> div_status(0),
			D				=> operand1,
			V 				=> operand2,
			Q				=> div(N-1 downto 0),
			R				=> div(2*N-1 downto N)
		);
		
		
	POW_block : esponenziale
		Generic map (
			N => N
		)
		Port map ( 
			start 		=> start,
			clock 		=> clock,
			reset_n 	=> reset_n,
			base 		=> operand1,
			exp 		=> operand2,
			done 		=> pow_status(0),
			truncate 	=> pow_status(1),
			result 		=> pow
		);		
	
	STATUS_mux : generic_8to1_mux
		generic map (
			N => 2
		)
		port map (
			sel 		=> conf,
			data_in_000 => sum_status,
			data_in_001 => sum_status,
			data_in_010 => mul_status,
			data_in_011 => div_status,
			data_in_100 => pow_status,
			data_in_101 => status_zero,
			data_in_110 => status_zero,
			data_in_111 => status_zero,
			data_out 	=> status
		);
		
	RES_mux : generic_8to1_mux
		generic map (
			N => 2*N
		)
		port map (
			sel 		=> conf,
			data_in_000 => sum,
			data_in_001 => sum,
			data_in_010 => prod,
			data_in_011 => div,
			data_in_100 => pow,
			data_in_101 => res_zero,
			data_in_110 => res_zero,
			data_in_111 => res_zero,
			data_out 	=> result
		);


end structural;
