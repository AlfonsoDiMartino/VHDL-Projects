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
			N : natural := 8
		);
		port (
			clock 			: in std_logic;
			reset_n 		: in std_logic;
			start 			: in std_logic;		-- avvia il processo di moltiplicazione
			
			truncate		: out std_logic;	-- indica se il moltiplicatore e' zero
			done 			: out std_logic;	-- quando alto indica la fine del processo di calcolo
			
			base 				: in std_logic_vector(N-1 downto 0);
			exp 				: in std_logic_vector(N-1 downto 0);
			result 			: out std_logic_vector((2*N)-1 downto 0)
		);
	end component;
	
	for all : multiplier use entity work.esponenziale;
	
	component buffer_register is
		generic (N : natural);
		port (
			clock			: in std_logic;
			reset_n 		: in std_logic;
			load_data 		: in std_logic;
			data_in 		: in std_logic_vector(N-1 downto 0);
			data_out	 	: out std_logic_vector(N-1 downto 0)
		);
	end component;

	signal reset_n 		: std_logic := '0';
	signal prod_done 	: std_logic := '0';										-- segnale "prodotto completato"
	signal X_Value 		: std_logic_vector(7 downto 0) := (others => '0');		-- segnale di uscita registro X, ingresso moltiplicatore
	signal Y_Value 		: std_logic_vector(7 downto 0) := (others => '0');		-- segnale di uscita registro Y, ingresso moltiplicatore
	signal Prod_Value 	: std_logic_vector(15 downto 0) := (others => '0');		-- segnale uscita moltiplicatore, ingresso registro P
	signal P_Value 		: std_logic_vector(15 downto 0) := (others => '0');		-- segnale di uscita registro P, ingresso Display
	
	signal display_en			: std_logic_vector(3 downto 0) := (others => '1');
	signal dot_en				: std_logic_vector(3 downto 0) := (others => '0');
	signal data_to_display		: std_logic_vector(15 downto 0) := (others => '0');
	
	

begin

	reset_n <= not reset;
	done 	<= prod_done;
	
	data_to_display_process : process(clock, reset, loadX, loadY)
	begin
		if (reset = '1') then
			display_en <= "1111";
			data_to_display <= (others => '0');
		elsif (clock = '1' and clock'event) then
			if (loadX = '1') then
				display_en <= "0011";
				data_to_display <= x"00" & X_Value;
			elsif (loadY = '1') then
				display_en <= "1100";
				data_to_display <= Y_Value & x"00";
			else
				display_en <= "1111";
				data_to_display <= P_Value;
			end if;
		end if;
	
	end process;

	DISPLAY : driver_7seg
		generic map (	
			clock_freq_hz => 50000000,
			refresh_freq_hz => 50000
		)
		port map (	
			reset_n			=> reset_n,
			clock 			=> clock,
			display_en 		=> display_en,
			data 			=> data_to_display,
			dot_en 			=> dot_en,
			display_on_n 	=> display_on_n,
			segment_on_n	=> segment_on_n,
			dot_on_n		=> dot_on_n
		);

	X : buffer_register
		generic map (8)
		port map (
			clock			=> clock,
			reset_n 		=> reset_n,
			load_data 		=> loadX,
			data_in 		=> data_in,
			data_out	 	=> X_Value
		);
		
	Y : buffer_register
		generic map (8)
		port map (
			clock			=> clock,
			reset_n 		=> reset_n,
			load_data 		=> loadY,
			data_in 		=> data_in,
			data_out	 	=> Y_Value
		);
		
	MUL : multiplier
		generic map (8)
		port map (
			clock 			=> clock,
			reset_n 		=> reset_n,
			start 			=> start,
			truncate		=> mul_by_zero,
			done 			=> prod_done,
			base 				=> X_Value,
			exp 				=> Y_Value,
			result 			=> Prod_Value
		);
		
	Prod : buffer_register
		generic map (16)
		port map (
			clock			=> clock, 
			reset_n 		=> reset_n,
			load_data 		=> '1',
			data_in 		=> Prod_Value,
			data_out	 	=> P_Value
		);
		
end behavioral_structural;
