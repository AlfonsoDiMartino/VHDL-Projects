library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity booth_multiplier is
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
end booth_multiplier;


architecture structural of booth_multiplier is
	----------------------------------------------------------------------------------------------
	-- componenti
	----------------------------------------------------------------------------------------------
	component buffer_register is
		generic	(
			N : natural := 8
		);
		port (
			clk 	: in  STD_LOGIC;
			load 	: in  STD_LOGIC;
			clear_n : in STD_LOGIC;
			I 		: in  STD_LOGIC_VECTOR (N-1 downto 0);
			Q 		: out  STD_LOGIC_VECTOR (N-1 downto 0)
		);
	end component;

	component right_shift_register is
		generic (
			N : natural := 8
		);
		port (
			clock			: in std_logic;
			reset_n 		: in std_logic;
			load_data 		: in std_logic;
			shift			: in std_logic;
			serial_in 		: in std_logic;
			parallel_in 	: in std_logic_vector(N-1 downto 0);
			serial_out 		: out std_logic;
			parallel_out 	: out std_logic_vector(N-1 downto 0)
		);
	end component;
	
	component generic_adder_subtractor is
		generic (nibbles 	: natural := 2);

		port ( x 			: in  std_logic_vector ((nibbles * 4)-1 downto 0);
			   y 			: in  std_logic_vector ((nibbles * 4)-1 downto 0);
			   sub_add_n	: in  std_logic;
			   sum 			: out  std_logic_vector ((nibbles * 4)-1 downto 0);
			   carry_out	: out  std_logic;
			   overflow 	: out  std_logic
		);
	end component;
	
	component op_counter is
		generic (
			N : natural := 8
		);
		port (
			clock 		: in std_logic;
			reset_n 	: in std_logic;
			count		: in std_logic;																			-- comando incrementa conteggio
			count_out	: out std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0)						-- segnale "passo corrente"
		);
	end component;

	component booth_cu is
		generic (
			N : natural := 8
		);
		port (
			clock 			: in std_logic;
			
			reset_n 		: in std_logic;
			start 			: in std_logic;			-- avvia il processo di moltiplicazione
			done 			: out std_logic;		-- flag fine del processo di calcolo
			
			count_in		: in std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0) := (others => '0');	-- segnale "passo corrente"
			Q_lsb 			: in std_logic_vector(1 downto 0);														-- due bit lsb del registro Q

			shift 			: out std_logic;	-- abilita/disabilita shift per registri A e Q
			subtract 		: out std_logic;	-- abilita/disabilita sottrazione
			
			enable_A 		: out std_logic;	-- abilita/disabilita load in registro A
			enable_M 		: out std_logic;	-- abilita/disabilita load in registro M
			enable_Q		: out std_logic;	-- abilita/disabilita load in registro Q
			enable_count	: out std_logic; 	-- abilita/disabilita incremento conteggio

			reset_A_n 		: out std_logic;	-- reset registro A (attivo basso)
			reset_M_n 		: out std_logic;	-- reset registro M (attivo basso)
			reset_Q_n 		: out std_logic;	-- reset registro Q (attivo basso)
			reset_count_n	: out std_logic		-- reset contatore (attivo basso)
		);
	end component;
	
	component generic_or is
		generic (
			N : natural := 8
		);
		Port (
			x : in STD_LOGIC_VECTOR (N-1 downto 0);
			or_x : out STD_LOGIC
		);
	end component;
	
	component generic_bitwise_and is
		generic (
			n : natural := 8
		);
		port (
			data_in_1 	: in std_logic_vector (n-1 downto 0);
			data_in_2 	: in std_logic_vector (n-1 downto 0);
			data_out 	: out std_logic_vector (n-1 downto 0)
		);
	end component;
	
	
	----------------------------------------------------------------------------------------------
	-- segnali
	----------------------------------------------------------------------------------------------	
	-- segnali di controllo in uscita dalla control unit
	signal shift 			: std_logic;	-- abilita/disabilita shift per registri A e Q
	signal subtract 		: std_logic;	-- abilita/disabilita sottrazione
	signal enable_A 		: std_logic;	-- abilita/disabilita load in registro A
	signal enable_M 		: std_logic;	-- abilita/disabilita load in registro M
	signal enable_Q			: std_logic;	-- abilita/disabilita load in registro Q
	signal enable_count		: std_logic; 	-- abilita/disabilita incremento conteggio
	signal reset_A_n 		: std_logic;	-- reset registro A (attivo basso)
	signal reset_M_n 		: std_logic;	-- reset registro M (attivo basso)
	signal reset_Q_n 		: std_logic;	-- reset registro Q (attivo basso)
	signal reset_count_n	: std_logic;	-- reset contatore (attivo basso)
		
	-- segnali dati per la control unit
	signal count_Value		: std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0) := (others => '0');	-- segnale "passo corrente"
	
	-- segnalo dato
	constant nibbles 		: natural := (N / 4) + 1;										-- dimensione "magiorata" dei registri in nibbles
	signal A_Value_in 		: std_logic_vector(nibbles*4-1 downto 0) := (others => '0'); 		-- segnale di ingresso a registro A
	signal A_Value_out	 	: std_logic_vector(nibbles*4-1 downto 0) := (others => '0'); 		-- segnale di uscita a registro A
	signal M_Value_in	 	: std_logic_vector(nibbles*4-1 downto 0) := (others => '0'); 		-- segnale di ingresso a registro M
	signal M_Value_out	 	: std_logic_vector(nibbles*4-1 downto 0) := (others => '0'); 		-- segnale di uscita a registro M
	
	signal Q_Value_in	 	: std_logic_vector(N downto 0) := (others => '0'); 				-- segnale di ingresso a registro Q (N +1 bit)
	signal Q_Value_out	 	: std_logic_vector(N downto 0) := (others => '0'); 				-- segnale di uscita a registro Q (N +1 bit)
	signal a_to_q			: std_logic := '0';													-- segnale serial_out di A, serial_in di Q
	
	signal sign				: std_logic := '0';													-- segnale serial_in di A
	
	signal M_not_null		: std_logic := '0';
	signal M_not_null_vector: std_logic_vector(N-1 downto 0) := (others => '0');
		
begin


	-- il registro M viene istanziato con un numero di bit maggiorato, in questo modo è
	-- teoricamente possibile fare in modo che contenga numeri più grandi di 2^(N-1)-1 e più
	-- piccoli di -2^(N-1). Questa evenienza non si verificherà mai, ma serve a risolvere il
	-- problema di cui è afflitto il moltiplicatore di Booth quando si tenta una moltiplicazione
	-- in cui il moltiplicatore è -2^(N-1).
	-- Sul registro M va effettuato un padding che rispecchi il segno del numero caricato al suo
	-- interno
	M_Value_in(nibbles*4-1 downto N) <= (others => Y(N-1));
	M_Value_in(N-1 downto 0) <= Y;
	
	mul_by_zero <= not M_not_null;
	M_not_null_vector <= (others => M_not_null);
	
	Q_Value_in <= X & '0';
	
	sign <= A_Value_out(nibbles*4-1);

	A : right_shift_register
		generic map (
			N => nibbles * 4
		)
		port map (
			clock			=> clock,
			reset_n 		=> reset_A_n,
			load_data 		=> enable_A,
			shift			=> shift,
			serial_in 		=> sign,
			parallel_in 	=> A_Value_in,
			serial_out 		=> a_to_q,
			parallel_out 	=> A_Value_out
		);
		
	Q : right_shift_register
		generic map (
			N => N+1
		)
		port map (
			clock			=> clock,
			reset_n 		=> reset_Q_n,
			load_data 		=> enable_Q,
			shift			=> shift,
			serial_in 		=> a_to_q,
			parallel_in 	=> Q_Value_in,
			serial_out 		=> open,
			parallel_out 	=> Q_Value_out
		);

	M : buffer_register
		generic map (
			N => nibbles * 4
		)
		port map (
			clk		=> clock,
			clear_n => reset_M_n,
			load 	=> enable_M,
			I		=> M_Value_in,
			Q	 	=> M_Value_out
		);
		
	ADDER : generic_adder_subtractor
		generic map (
			nibbles => nibbles
		)
		port map (
			x 				=> A_Value_out,
			y 				=> M_Value_out,
			sub_add_n		=> subtract,
			sum 			=> A_Value_in,
			carry_out		=> open,
			overflow 		=> open
		);
		
	COUNTER : op_counter
		generic map (
			N => N
		)
		port map (
			clock 			=> clock,
			reset_n 		=> reset_count_n,
			count			=> enable_count,
			count_out		=> count_Value
		);
		
	CONTROL_UNIT : booth_cu
		generic map (
			N => N
		)
		port map (
			clock 			=> clock,
			reset_n 		=> reset_n,
			start 			=> start,
			done 			=> done,
			
			count_in		=> count_Value,
			Q_lsb 			=> Q_Value_out(1 downto 0),

			shift 			=> shift,
			subtract 		=> subtract,
			
			enable_A 		=> enable_A,
			enable_M 		=> enable_M,
			enable_Q		=> enable_Q,
			enable_count	=> enable_count,
			
			reset_A_n 		=> reset_A_n,
			reset_M_n 		=> reset_M_n,
			reset_Q_n 		=> reset_Q_n,
			reset_count_n	=> reset_count_n
		);
		
	M_OR : generic_or
		generic map(
			N => N
		)
		port map (
			x 		=> M_Value_out(N-1 downto 0),
			or_x 	=> M_not_null
		);	
		
	ANDH : generic_bitwise_and
		generic map (
			n => N
		)
		port map (
			data_in_1 	=> A_Value_out(N-1 downto 0),
			data_in_2 	=> M_not_null_vector,
			data_out 	=> Prod(2*N-1 downto N)
		);
		
	ANDL : generic_bitwise_and
		generic map (
			n => N
		)
		port map (
			data_in_1 	=> Q_Value_out(N downto 1),
			data_in_2 	=> M_not_null_vector,
			data_out 	=> Prod(N-1 downto 0)
		);

end structural;

