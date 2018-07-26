library ieee;
use ieee.std_logic_1164.all;

entity otb_multiplier is
	port (
		clock 			: in std_logic;
		reset	 		: in std_logic;
		start 			: in std_logic;		-- avvia il processo di moltiplicazione
		loadX 			: in std_logic;
		loadY 			: in std_logic;
		data_in 		: in std_logic_vector(7 downto 0);
		
		done 			: out std_logic;	-- quando alto indica la fine del processo di calcolo
		mul_by_zero		: out std_logic;	-- indica se il moltiplicatore e' zero (attivo basso)
		
		display_on_n 	: out std_logic_vector(3 downto 0);
		segment_on_n	: out std_logic_vector(6 downto 0);
		dot_on_n		: out std_logic
	);
end otb_multiplier;


architecture behavioral_structural of otb_multiplier is

	component driver_7seg is
		generic (	clock_freq_hz : integer := 50000000;			-- frequenza clock board
					refresh_freq_hz : integer := 500);				-- frequenza refresh display
					
		port (	reset_n		: in std_logic;							-- reset asincrono (attivo basso)
				clock 		: in std_logic;							-- clock
				display_en 	: in std_logic_vector(3 downto 0);		-- segnale di enable, ogni bit abilita un diverso display
				data 		: in std_logic_vector(15 downto 0);		-- ingresso dati
				dot_en 		: in std_logic_vector (3 downto 0);		-- segnale di enable per i punti
				
				display_on_n 		: out std_logic_vector(3 downto 0);	-- segnale di accensione/spegnimento per i display (attivo basso)
				segment_on_n		: out std_logic_vector(6 downto 0);	-- segnale di accensione/spegnimento per i segmenti (attivo basso)
				dot_on_n			: out std_logic						-- segnale di accensione/spegnimento per i punti (attivo basso)
		);
	end component;


	component multiplier is
		generic (
			nbit : natural := 8
		);
		port (
			clock 			: in std_logic;
			reset_n 		: in std_logic;
			start 			: in std_logic;		-- avvia il processo di moltiplicazione
			
			mul_by_zero		: out std_logic;	-- indica se il moltiplicatore e' zero
			done 			: out std_logic;	-- quando alto indica la fine del processo di calcolo
			
			X 				: in std_logic_vector(nbit-1 downto 0);
			Y 				: in std_logic_vector(nbit-1 downto 0);
			Prod 			: out std_logic_vector((2*nbit)-1 downto 0)
		);
	end component;
	
	for all : multiplier use entity work.booth_multiplier;
	
	component buffer_register is
		generic (
			nbit : natural := 8;
			edge : std_logic := '1'		-- '1' = rising_edge		
		);
		port (
			clock			: in std_logic;
			reset_n 		: in std_logic;
			load_data 		: in std_logic;
			data_in 		: in std_logic_vector(nbit-1 downto 0);
			data_out	 	: out std_logic_vector(nbit-1 downto 0)
		);
	end component;

	signal reset_n 		: std_logic := '0';
	signal prod_done 	: std_logic := '0';										-- segnale "prodotto completato"
	signal X_Value 		: std_logic_vector(7 downto 0) := (others => '0');		-- segnale di uscita registro X, ingresso moltiplicatore
	signal Y_Value 		: std_logic_vector(7 downto 0) := (others => '0');		-- segnale di uscita registro Y, ingresso moltiplicatore
	signal Prod_Value 	: std_logic_vector(15 downto 0) := (others => '0');		-- segnale uscita moltiplicatore, ingresso registro P
	signal P_Value 		: std_logic_vector(15 downto 0) := (others => '0');		-- segnale di uscita registro P, ingresso Display
	

begin

	reset_n <= not reset;
	done 	<= prod_done;

	DISPLAY : driver_7seg
		generic map (	
			clock_freq_hz => 50000000,
			refresh_freq_hz => 50000
		)
		port map (	
			reset_n			=> reset_n,
			clock 			=> clock,
			display_en 		=> "1111",
			data 			=> P_Value,
			dot_en 			=> "0000",
			display_on_n 	=> display_on_n,
			segment_on_n	=> segment_on_n,
			dot_on_n		=> dot_on_n
		);

	X : buffer_register
		generic map (
			nbit => 8,
			edge => '1'
		)
		port map (
			clock			=> clock,
			reset_n 		=> reset_n,
			load_data 		=> loadX,
			data_in 		=> data_in,
			data_out	 	=> X_Value
		);
		
	Y : buffer_register
		generic map (
			nbit => 8,
			edge => '1'
		)
		port map (
			clock			=> clock,
			reset_n 		=> reset_n,
			load_data 		=> loadY,
			data_in 		=> data_in,
			data_out	 	=> Y_Value
		);
		
	MUL : multiplier
		generic map (
			nbit => 8
		)
		port map (
			clock 			=> clock,
			reset_n 		=> reset_n,
			start 			=> start,
			mul_by_zero		=> mul_by_zero,
			done 			=> prod_done,
			X 				=> X_Value,
			Y 				=> Y_Value,
			Prod 			=> Prod_Value
		);
		
	Prod : buffer_register
		generic map (
			nbit => 16,
			edge => '1'
		)
		port map (
			clock			=> clock, 
			reset_n 		=> reset_n,
			load_data 		=> prod_done,
			data_in 		=> Prod_Value,
			data_out	 	=> P_Value
		);

end behavioral_structural;
