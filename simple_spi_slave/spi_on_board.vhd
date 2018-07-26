library ieee;
use ieee.std_logic_1164.all;

entity spi_on_board is
	port (
		-- lato user
		clock 			: in std_logic;
		reset 			: in std_logic;
		load_data 		: in std_logic;
		data_in 		: in std_logic_vector (7 downto 0);
		
		-- lato spi
		sck				: in std_logic;
		sdi				: in std_logic;
		sdo				: out std_logic;
		ss_n			: in std_logic;
		
		-- lato display
		busy			: out std_logic;
		display_on_n 	: out std_logic_vector(3 downto 0);
		segment_on_n	: out std_logic_vector(6 downto 0);
		dot_on_n		: out std_logic
	);
end spi_on_board;
		

architecture structural of spi_on_board is

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
	
	
	component spi_slave is
		generic (
			nbit 	: natural := 8;
			cpha    : std_logic := '0'
		);
		port	(
			-- lato "user-logic"
			clock		: in std_logic;
			reset_n 	: in std_logic;
			data_in 	: in std_logic_vector(nbit-1 downto 0);
			load_data	: in std_logic;
			data_out 	: out std_logic_vector(nbit-1 downto 0);
			busy		: out std_logic;
			
			-- lato "master"
			sck		: in std_logic;
			sdi		: in std_logic;
			sdo		: out std_logic;
			ss_n	: in std_logic
		);
	end component;

	signal reset_n : std_logic;
	signal data : std_logic_vector(15 downto 0);

begin

	reset_n <= not reset;
	--~ data (7 downto 0) <= data_in;

	display_driver : driver_7seg
		generic map (	
			clock_freq_hz	=> 50000000,
			refresh_freq_hz => 50000
		)
		port map (
			reset_n			=>	reset_n,
			clock 			=>	clock,
			display_en 		=>	"1100",
			data 			=>	data,
			dot_en 			=>	"0000",
			display_on_n 	=>	display_on_n,
			segment_on_n	=>	segment_on_n,
			dot_on_n		=>	dot_on_n
		);
	
	
	spi_unit : spi_slave
		generic map (
			nbit => 8,
			cpha => '0'
		)
		port map (
			-- lato "user-logic"
			clock		=>	clock,
			reset_n 	=>	reset_n,
			data_in 	=>	data_in,
			load_data	=>	load_data,
			data_out 	=>	data (15 downto 8),
			busy		=>	busy,
			
			-- lato "master"
			sck		=>	sck,
			sdi		=>	sdi,
			sdo		=>	sdo,
			ss_n	=>	ss_n
		);

end;
