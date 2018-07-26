library ieee;
use ieee.std_logic_1164.all;


entity spi_slave is
	generic (
		nbit 	: natural := 8;
		cpha    : std_logic := '0'
		-- cpol cpha
		--	0	0		rx su rising edge, tx su falling edge
		--	0	1		rx su falling edge, tx su rising edge
		-- le altre due modalita' non sono supportate
		--	1	0		rx su falling edge, tx su rising edge
		--	1	1		rx su rising edge, tx su falling edge
		-- cpol    : std_logic := '0';
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
end spi_slave;


architecture structural of spi_slave is

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
	
	component sck_filter is 
		port (
			clock	 	: in std_logic;
			reset_n 	: in std_logic;
			en_in		: in std_logic;
			en_out 		: out std_logic
		);
	end component;

	component left_shift_register is
		generic (
			nbit : natural := 8;
			edge : std_logic := '1'
		);
		port (
			clock			: in std_logic;
			reset_n 		: in std_logic;
			load_data 		: in std_logic;
			shift			: in std_logic;
			parallel_in 	: in std_logic_vector(nbit-1 downto 0);
			parallel_out 	: out std_logic_vector(nbit-1 downto 0);
			serial_in 		: in std_logic;
			serial_out 		: out std_logic
		);
	end component;

	-- segnali controllo
	signal shift 			: std_logic := '0';		-- comando shift (not ss_n) abilita/disabilita ricezione/trasmissione
	signal tx_load  		: std_logic := '0';		-- abilita/disabilita caricamento dati da tx_buffer in shift register
	signal rx_load			: std_logic := '0';		-- abilita/disabilita caricamento dati da shift_register a rx_buffer
	
	-- segnali dati
	signal Tx_Buff_to_Shift : std_logic_vector(nbit-1 downto 0) := (others => '0');	
	signal Shift_to_Rx_Buff : std_logic_vector(nbit-1 downto 0) := (others => '0');
	
begin

	shift <= not ss_n;
	busy <= not ss_n;
	
	TX_LOAD_FILTER : sck_filter 
		port map (
			clock	 	=> clock,
			reset_n 	=> reset_n,
			en_in		=> shift,
			en_out 		=> tx_load
		);
	
	TX_BUFF : buffer_register
		generic map (
			nbit => nbit,
			edge => '1'
		)
		port map (
			clock			=> clock,
			reset_n 		=> reset_n,
			load_data 		=> load_data,
			data_in 		=> data_in,
			data_out	 	=> Tx_Buff_to_Shift
		);
	
	SHIFT_REGISTER : left_shift_register
		generic map (
			nbit => nbit,
			edge => cpha
		)
		port map(
			clock 			=> sck,
			reset_n 		=> reset_n,
			load_data	 	=> tx_load,
			shift 			=> shift,
			parallel_in 	=> Tx_Buff_to_Shift,
			parallel_out	=> Shift_to_Rx_Buff,
			serial_in 		=> sdi,
			serial_out 		=> sdo
		);
		
	RX_LOAD_FILTER : sck_filter 
		port map (
			clock	 	=> clock,
			reset_n 	=> reset_n,
			en_in		=> ss_n,
			en_out 		=> rx_load
		);
		
	RX_BUFF : buffer_register
		generic map (
			nbit => nbit,
			edge => '1'
		)
		port map (
			clock			=> clock,
			reset_n 		=> reset_n,
			load_data 		=> rx_load,
			data_in 		=> Shift_to_Rx_Buff,
			data_out	 	=> data_out
		);
		
		
end structural;
