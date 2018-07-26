library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity restoring_divider is
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
end restoring_divider;


architecture structural of restoring_divider is
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

	component left_shift_register is
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


	component restoring_cu is
		generic (
			N : natural := 8
		);
		port (
			clock 		: in std_logic;
			reset_n 	: in std_logic;
			start 		: in std_logic;		-- avvia il processo di moltiplicazione
			done 		: out std_logic;	-- quando alto indica la fine del processo di calcolo
			
			count_in	: in std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0) := (others => '0');	-- segnale "passo corrente"
			
			lshift_A 	: out std_logic;	-- comando shift per registro A
			lshift_Q 	: out std_logic;	-- comando shift per registro Q
			subtract 	: out std_logic;	-- comando di sottrazione per addizionatore
			
			enable_A 	: out std_logic;	-- abilita/disabilita load in registro A
			enable_M 	: out std_logic;	-- abilita/disabilita load in registro M
			enable_Q	: out std_logic;	-- abilita/disabilita load in registro Q
			enable_cnt	: out std_logic; 	-- comando incrementa conteggio
			
			reset_A_n 	: out std_logic;	-- reset registro A (attivo basso)
			reset_M_n 	: out std_logic;	-- reset registro M (attivo basso)
			reset_Q_n 	: out std_logic;	-- reset registro Q (attivo basso)
			reset_cnt_n	: out std_logic		-- comando reset conteggio
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
	-- segnali dato
	signal Q_lsb	 	: std_logic := '0';	-- ultimo valore di Q calcolato, posto su serial in di Q
	signal Q_to_A	 	: std_logic := '0';	-- msb di Q in ingresso su serial_in di A
	signal count_out	: std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0) := (others => '0');
	
	constant nibbles 	: integer := (N / 4) + 1;											-- dimensione "magiorata" dei registri in nibbles
	signal A_in			: std_logic_vector(nibbles*4-1 downto 0) := (others => '0');		-- ingresso parallel-in di A
	signal A_out		: std_logic_vector(nibbles*4-1 downto 0) := (others => '0');		-- uscita parallel-out di A
	signal M_pad		: std_logic_vector(nibbles*4-1 downto N) := (others => '0');		-- padding di M
	signal M_out		: std_logic_vector(N-1 downto 0) := (others => '0');				-- uscita parallel-out di M
	signal M_padded		: std_logic_vector(nibbles*4-1 downto 0) := (others => '0');		-- M "paddato"
	signal Q_out		: std_logic_vector(N-1 downto 0) := (others => '0');				-- ingresso parallel-in di Q
	
	-- segnali di controllo in uscita alla control unit
	signal lshift_A 	: std_logic := '0';			-- comando shift per registro A
	signal lshift_Q 	: std_logic := '0';			-- comando shift per registro Q
	signal subtract 	: std_logic := '0';			-- comando di sottrazione per addizionatore
	
	signal enable_A_cmd	: std_logic := '0';			-- abilita/disabilita load in registro A
	signal enable_M 	: std_logic := '0';			-- abilita/disabilita load in registro M
	signal enable_Q		: std_logic := '0';			-- abilita/disabilita load in registro Q
	signal enable_cnt	: std_logic := '0'; 		-- comando incrementa conteggio
	signal reset_A_n 	: std_logic := '0';			-- reset registro A (attivo basso)
	signal reset_M_n 	: std_logic := '0';			-- reset registro M (attivo basso)
	signal reset_Q_n 	: std_logic := '0';			-- reset registro Q (attivo basso)
	signal reset_cnt_n	: std_logic := '0';			-- comando reset conteggio
	
	
	signal enable_A 	: std_logic := '0';			-- abilita/disabilita load in registro A (and tra not A_in(N) e enable_A_cmd)
	
	signal M_not_null		: std_logic := '0';
	signal M_not_null_vector: std_logic_vector(N-1 downto 0) := (others => '0');

begin

	
	M_padded <= M_pad & M_out;
	
	div_by_zero <= not M_not_null;
	M_not_null_vector <= (others => M_not_null);
	
	Q_lsb <= not A_in(N);
	enable_A <= enable_A_cmd and Q_lsb;
	

	CONTROL_UNIT : restoring_cu
		generic map (
			N => N
		)
		port map (
			clock 		=> clock,
			reset_n 	=> reset_n,
			start 		=> start,
			done 		=> done,
			count_in	=> count_out,
			lshift_A 	=> lshift_A,
			lshift_Q 	=> lshift_Q,
			subtract 	=> subtract,
			enable_A 	=> enable_A_cmd,
			enable_M 	=> enable_M,
			enable_Q	=> enable_Q,
			enable_cnt	=> enable_cnt,
			reset_A_n 	=> reset_A_n,
			reset_M_n 	=> reset_M_n,
			reset_Q_n 	=> reset_Q_n,
			reset_cnt_n	=> reset_cnt_n
		);
		
	COUNTER : op_counter
		generic map (
			N => N
		)
		port map (
			clock 		=> clock,
			reset_n 	=> reset_cnt_n,
			count		=> enable_cnt,
			count_out	=> count_out
		);

	M_REGISTER : buffer_register
		generic map (
			N => N
		)
		port map (
			clk				=> clock,
			clear_n 		=> reset_M_n,
			load	 		=> enable_M,
			I		 		=> V,
			Q			 	=> M_out
		);
		
	Q_REGISTER : left_shift_register
		generic map (
			N => N
		)
		port map (
			clock			=> clock,
			reset_n 		=> reset_Q_n,
			load_data 		=> enable_Q,
			shift			=> lshift_Q,
			serial_in 		=> Q_lsb,
			parallel_in 	=> D,
			serial_out 		=> Q_to_A,
			parallel_out 	=> Q_out
		);
		
	A_REGISTER : left_shift_register
		generic map (
			N => nibbles*4
		)
		port map (
			clock			=> clock,
			reset_n 		=> reset_A_n,
			load_data 		=> enable_A,
			shift			=> lshift_A,
			serial_in 		=> Q_to_A,
			parallel_in 	=> A_in,
			serial_out 		=> open,
			parallel_out 	=> A_out
		);
		
		
	ADDER: generic_adder_subtractor
		generic map (
			nibbles => nibbles
		)
		port map ( 
			x 			=> A_out,
			y 			=> M_padded,
			sub_add_n	=> subtract,
			sum 		=> A_in,
			carry_out	=> open,
			overflow 	=> open
		);
	
	
	M_OR : generic_or
		generic map(
			N => N
		)
		port map (
			x 		=> M_out(N-1 downto 0),
			or_x 	=> M_not_null
		);	
		
	ANDH : generic_bitwise_and
		generic map (
			n => N
		)
		port map (
			data_in_1 	=> A_out(N-1 downto 0),
			data_in_2 	=> M_not_null_vector,
			data_out 	=> R
		);
		
	ANDL : generic_bitwise_and
		generic map (
			n => N
		)
		port map (
			data_in_1 	=> Q_out(N-1 downto 0),
			data_in_2 	=> M_not_null_vector,
			data_out 	=> Q
		);

	
	
end structural;

