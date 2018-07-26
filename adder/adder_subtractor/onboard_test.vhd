library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity onboard_test is
	port (	clock		: in std_logic;
			-- segnali "utente"
			reset			: in std_logic;
			loadX			: in std_logic;
			loadY			: in std_logic;
			sub_add_n		: in std_logic;
			data_in 		: in std_logic_vector(7 downto 0);
			-- segnali di controllo per il display
			display_on_n	: out std_logic_vector(3 downto 0);
			dot_on_n		: out std_logic;
			segment_on_n	: out std_logic_vector(6 downto 0);
			-- segnale di controllo led overflow
			carry_out		: out  std_logic;
			overflow		: out std_logic
	);
end onboard_test;


architecture structural of onboard_test is

	component driver_7seg is
		generic (	clock_freq_hz	: integer := 50000000;			-- frequenza clock board
					refresh_freq_hz : integer := 500);				-- frequenza refresh display
					
		port (	reset_n				: in std_logic;							-- reset asincrono (attivo basso)
				clock 				: in std_logic;							-- clock
				display_en 			: in std_logic_vector(3 downto 0);		-- segnale di enable, ogni bit abilita un diverso display
				data 				: in std_logic_vector(15 downto 0);		-- ingresso dati
				dot_en 				: in std_logic_vector (3 downto 0);		-- segnale di enable per i punti
				
				display_on_n 		: out std_logic_vector(3 downto 0);	-- segnale di accensione/spegnimento per i display (attivo basso)
				segment_on_n		: out std_logic_vector(6 downto 0);	-- segnale di accensione/spegnimento per i segmenti (attivo basso)
				dot_on_n			: out std_logic						-- segnale di accensione/spegnimento per i punti (attivo basso)
		);
	end component;
	
	
	
	component generic_adder_subtractor is
		generic (nibbles : natural := 2);
		port ( x 			: in  std_logic_vector ((nibbles * 4)-1 downto 0);
			   y 			: in  std_logic_vector ((nibbles * 4)-1 downto 0);
			   sub_add_n 	: in  std_logic;
			   sum 			: out  std_logic_vector ((nibbles * 4)-1 downto 0);
			   carry_out	: out  std_logic;
			   overflow 	: out  std_logic
		);
	end component;
	
	
	
	component user_interface is
		port (	clock		: in std_logic;
				-- segnali "utente"
				reset		: in std_logic;
				loadX		: in std_logic;
				loadY		: in std_logic;
				data_in 	: in std_logic_vector(7 downto 0);
				-- segnali di controllo per il driver del display
				reset_n		: out std_logic;
				display_data: out std_logic_vector(15 downto 0);
				-- segnali per l'adder
				X 			: out std_logic_vector(7 downto 0);
				Y			: out std_logic_vector(7 downto 0);
				sum			: in std_logic_vector(7 downto 0)
		);
	end component;
	
	
	-- segnali di controllo ed input per il driver display a 7 segmenti
	signal display_en 	: std_logic_vector (3 downto 0) := "0011";
	signal dot_en		: std_logic_vector (3 downto 0) := "0000";
	signal display_data : std_logic_vector (15 downto 0) := x"0000";
	signal reset_n		: std_logic := '1';

	
	-- segnali di input/output per l'adder/subtractor
	signal X 	: std_logic_vector(7 downto 0) := x"00";
	signal Y	: std_logic_vector(7 downto 0) := x"00";
	signal sum	: std_logic_vector(7 downto 0) := x"00";

begin

	ui : user_interface
		port map (	clock => clock,
					-- segnali "utente"
					reset => reset,
					loadX => loadX,
					loadY => loadY,
					data_in => data_in,
					-- segnali di controllo per il driver del display
					reset_n => reset_n,
					display_data => display_data,
					-- segnali per l'adder
					X => X,
					Y => Y,
					sum => sum
		);
		
	adder : generic_adder_subtractor
		generic map (2)
		port map ( x => X,
				   y => Y,
				   sub_add_n => sub_add_n,
				   sum => sum,
				   carry_out => carry_out,
				   overflow  => overflow
		);
		
	driver : driver_7seg
		generic map (50000000, 5000)
		port map (	reset_n	 => reset_n,
					clock => clock,
					display_en => display_en,
					data => display_data,
					dot_en => dot_en,
					display_on_n => display_on_n,
					segment_on_n => segment_on_n,
					dot_on_n => dot_on_n
		);

end structural;

