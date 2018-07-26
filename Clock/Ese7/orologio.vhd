library ieee;
use ieee.std_logic_1164.all;

entity orologio is
	port (
		clock 		: in std_logic;
		reset_n 	: in std_logic;
		load_min	: in std_logic;
		min_in		: in std_logic_vector(7 downto 0);
		load_ore	: in std_logic;
		ore_in		: in std_logic_vector(7 downto 0);
		
		ore			: out std_logic_vector(4 downto 0);
		min			: out std_logic_vector(5 downto 0);
		sec			: out std_logic_vector(1 downto 0)		-- i secondi sono riportati in multipli di 15 sec
															-- 00 : 0 secondi
															-- 01 : 15 secondi
															-- 10 : 30 secondi
															-- 11 : 45 secondi
	);
end orologio;


architecture structural of orologio is
	--~-------------------------------------------------------------------------------------------
	--~ componenti 
	--~-------------------------------------------------------------------------------------------
	component generic_counter is
		generic (
			N : integer := 8
		);
		port (
			clock 		: in std_logic;
			reset_n 	: in std_logic;
			enable 		: in std_logic;
			load 		: in std_logic;
			count_in 	: in std_logic_vector(N-1 downto 0);
			count_max 	: in std_logic_vector(N-1 downto 0);
			count_out 	: out std_logic_vector(N-1 downto 0);
			done 		: out std_logic
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
	
	--~-------------------------------------------------------------------------------------------
	--~ segnali
	--~-------------------------------------------------------------------------------------------
	 --~ tipo array usato per definire i conteggi massimi
	type cnt_mtx_t is array (0 to 8) of std_logic_vector(5 downto 0);
	--~ segnale array contenente i conteggi massimi di tutti i contatori
	signal cnt_max_mtx : cnt_mtx_t := (
		"110001", -- 49
		"110010", -- 49
		"110010", -- 49
		"010100", -- 19
		"010100", -- 19
		"001111", -- 15
		"000100", -- 5
		"111100", -- 59
		"011000" -- 23
	);
	
	--~ segnale array contenente i conteggi in uscita di tutti i contatori
	signal cnt_out_mtx : cnt_mtx_t := (
		"000000",
		"000000",
		"000000",
		"000000",
		"000000",
		"000000",
		"000000",
		"000000",
		"000000"
	);
	
	--~ segnale array contenente i conteggi in uscita di tutti i contatori
	signal cnt_in_mtx : cnt_mtx_t := (
		"000000",
		"000000",
		"000000",
		"000000",
		"000000",
		"000000",
		"000000",
		"000000",
		"000000"
	);
	
	--~ array di segnali "load"
	signal load : std_logic_vector (0 to 8) := (others => '0');
	
	--~ array di segnali "enable"
	signal done : std_logic_vector (0 to 9) := (others => '0');
	signal en : std_logic_vector (0 to 9) := (others => '0');

begin

	en(0)			<= '1';
	load(8)			<= load_ore;
	load(7) 	 	<= load_min;
	cnt_in_mtx(8)	<= ore_in(5 downto 0);
	cnt_in_mtx(7)	<= min_in(5 downto 0);
	ore				<= cnt_out_mtx(8)(4 downto 0);
	min				<= cnt_out_mtx(7)(5 downto 0);
	sec				<= cnt_out_mtx(6)(1 downto 0);

	counter_chain : for i in 0 to 8 generate
		cnt : generic_counter
			generic map (
				N => 6
			)
			port map (
				clock 		=> clock,
				reset_n 	=> reset_n,
				enable 		=> en(i),
				load 		=> load(i),
				count_in 	=> cnt_in_mtx(i),
				count_max 	=> cnt_max_mtx(i),
				count_out 	=> cnt_out_mtx(i),
				done 		=> done(i)
			);
			
		filter : sck_filter
			port map (
				clock	 	=> clock,
				reset_n 	=> reset_n,
				en_in		=> done(i),
				en_out 		=> en(i+1)
			);
	end generate;	


end structural;
