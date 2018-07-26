library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity driver_7seg is
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
end driver_7seg;


architecture structural of driver_7seg is

	component clock_filter is
		generic (	freq_in_hz : integer := 50000000;
					freq_out_hz : integer := 500);
		
		port (	reset_n		: in std_logic;
				clock_in	: in std_logic;
				clock_out	: out std_logic
		);
	end component;
	
	
	-- contatore modulo 4
	component counter is
		port	(	reset_n 	: in std_logic;
					clock		: in std_logic;
					enable		: in std_logic;
					count_out	: out std_logic_vector(1 downto 0)
		);
	end component;
	
	
	-- componente selector, "demux" a due ingressi e 4 uscite selezionabili
	-- l'uscita non selezionata e' a livello logico alto
	-- l'uscita è portata a livello logico basso quando selezionata
	component selector is
		port (	display_en		: in std_logic_vector(3 downto 0);
				display_sel		: in std_logic_vector(1 downto 0);
				display_on_n	: out std_logic_vector(3 downto 0)
		);
	end component;

	-- component mux 4 ingressi 1 uscita, generico per parallelismo di dati di ingresso/uscita
	component gen_mux4to1 is
		generic (nbit : natural := 4);											-- parallelismo dei dati
		port	(	data_in		: in std_logic_vector ((nbit*4)-1 downto 0);	-- dati in ingresso
					data_sel	: in std_logic_vector (1 downto 0);				-- comando selezione
					data_out	: out std_logic_vector (nbit-1 downto 0)		-- dati in uscita
		);
	end component;
	
	-- component mux 4 ingressi 1 uscita
	component mux4to1 is
		port	(	data_in		: in std_logic_vector(3 downto 0);		-- dati in ingresso
					data_sel	: in std_logic_vector(1 downto 0);		-- comando selezione
					data_out	: out std_logic							-- dati in uscita
		);
	end component;
	
	component hex_decoder is
		port	(	data_in : in std_logic_vector(3 downto 0);
					seg_on_n : out std_logic_vector(6 downto 0)
		);
	end component;




	signal pulse : std_logic := '0';
	signal sel : std_logic_vector (1 downto 0) := "00";
	signal to_decoder : std_logic_vector (3 downto 0) := "0000";
	signal dot_on : std_logic := '0';

begin

	dot_on_n <= not dot_on;
		
	filter : clock_filter
		generic map (	freq_in_hz => clock_freq_hz,
						freq_out_hz => refresh_freq_hz)
		port map (	reset_n	=> reset_n,
					clock_in => clock,
					clock_out => pulse
		);

	cnt : counter 
		port map (	reset_n => reset_n,
					clock => clock,
					enable => pulse,
					count_out => sel);

	display_selector : selector
		port map (	display_en	=> display_en,
					display_sel => sel,
					display_on_n => display_on_n
		);
		
	data_mux : gen_mux4to1
		generic map (4)
		port map (	data_in => data,
					data_sel => sel,
					data_out => to_decoder
		);
		
	dot_mux : mux4to1
		port map (	data_in => dot_en,
					data_sel => sel,
					data_out  => dot_on
		);
		
	decoder : hex_decoder
		port map (	data_in => to_decoder,
					seg_on_n => segment_on_n
		);

end;
