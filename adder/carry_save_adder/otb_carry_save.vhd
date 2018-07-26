library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity otb_carry_save is
	generic (N : natural := 8);
	port (
		-- lato user
		clock 		: in std_logic;
		reset 		: in std_logic;
		count 		: in std_logic;
		mode 		: in std_logic;
		data_in 	: in std_logic_vector(7 downto 0);
		
		-- lato display
		display_on_n	: out std_logic_vector(3 downto 0);
		segment_on_n	: out std_logic_vector(6 downto 0);
		dot_on_n		: out std_logic
	);
end otb_carry_save;


architecture structural of otb_carry_save is

	component button_debouncer is
		generic (lazy : natural := 26); 		-- lazy indica quanto il pulsante è pigro. più è alto
												-- più tempo dovrà intercorrere tra una pressione e la
												-- successiva affinché possano essere rilevate
		port (
			clock		: in std_logic;
			reset_n		: in std_logic;
			key			: in std_logic;
			pulse		: out std_logic
		);
	end component;


	component reg_counter is
		port (
			clock		: in std_logic;
			reset_n		: in std_logic;
			count_in	: in std_logic;
			count_out	: out std_logic_vector(1 downto 0)
		);
	end component;
	
	component decoder is
		port (
			sel 		: in std_logic_vector (1 downto 0);
			data_out 	: out std_logic_vector (2 downto 0)
		);
	end component;
	
	component mux is
		port (
			in0 : in std_logic_vector(7 downto 0);
			in1 : in std_logic_vector(7 downto 0);
			in2 : in std_logic_vector(7 downto 0);
			sel : in std_logic_vector(1 downto 0);
			data_out : out std_logic_vector(7 downto 0)
		);
	end component;
	
	component buffer_register is
		generic( n : natural := 8);
		port (
			i 		: in std_logic_vector (n-1 downto 0);
			clk		: in std_logic;
			load	: in std_logic;
			clear_n	: in std_logic;
			q		: out std_logic_vector (n-1 downto 0)
		);
	end component;
	
	component carry_save_adder is
		generic(N : natural);
		port (
			X : in std_logic_vector(N-1 downto 0);
			Y : in std_logic_vector(N-1 downto 0);
			Z : in std_logic_vector(N-1 downto 0);
			
			S : out std_logic_vector(N+1 downto 0)
		);
	end component;


	component driver_7seg is
		generic (	clock_freq_hz : integer := 50000000;
					refresh_freq_hz : integer := 500);
					
		port (	reset_n		: in std_logic;
				clock 		: in std_logic;
				display_en 	: in std_logic_vector(3 downto 0);
				data 		: in std_logic_vector(15 downto 0);
				dot_en 		: in std_logic_vector (3 downto 0);
				
				display_on_n 		: out std_logic_vector(3 downto 0);
				segment_on_n		: out std_logic_vector(6 downto 0);
				dot_on_n			: out std_logic
		);
	end component;
	
	signal reset_n : std_logic;

	signal reg_enable	: std_logic_vector(2 downto 0) := (others => '0');
	signal addendum0	: std_logic_vector(7 downto 0) := (others => '0');
	signal addendum1	: std_logic_vector(7 downto 0) := (others => '0');
	signal addendum2	: std_logic_vector(7 downto 0) := (others => '0');
	
	signal count_in		: std_logic := '0';
	signal count_out	: std_logic_vector(1 downto 0) := (others => '0');
	signal mux_out		: std_logic_vector(7 downto 0) := (others => '0');
	signal sum_out		: std_logic_vector(9 downto 0) := (others => '0');
	
	
	signal display_en		: std_logic_vector (3 downto 0) := (others => '0');
	signal dot_en			: std_logic_vector (3 downto 0)	:= (others => '0');
	signal data_to_display 	: std_logic_vector (15 downto 0)	:= (others => '0');
	
begin

	reset_n <= not reset;
	
	butt :  button_debouncer
		generic map(lazy => 25)
		port map (
			clock		=> clock,
			reset_n		=> reset_n,
			key			=> count,
			pulse		=> count_in
		);

	reg_enable_counter :  reg_counter
		port map (
			clock		=>	clock,
			reset_n		=>	reset_n,
			count_in	=>	count_in, 
			count_out	=>	count_out
		);
	
	reg_enable_decoder : decoder
		port map (
			sel 		=>	count_out,
			data_out 	=>	reg_enable
		);
		
	reg_mux : mux
		port map (
			in0			=>	addendum0,
			in1			=>	addendum1,
			in2			=>	addendum2,
			sel			=>	count_out,
			data_out	=>	mux_out
		);

	reg_0 : buffer_register
		generic map(8)
		port map (
			i 		=>	data_in,
			clk		=>	clock,
			load	=>	reg_enable(0),
			clear_n	=>	reset_n,
			q		=>	addendum0
		);
		
	reg_1 : buffer_register
		generic map(8)
		port map (
			i 		=>	data_in,
			clk		=>	clock,
			load	=>	reg_enable(1),
			clear_n	=>	reset_n,
			q		=>	addendum1
		);
		
	reg_2 : buffer_register
		generic map(8)
		port map (
			i 		=>	data_in,
			clk		=>	clock,
			load	=>	reg_enable(2),
			clear_n	=>	reset_n,
			q		=>	addendum2
		);
		
	carry_adder : carry_save_adder
		generic map (N)
		port map (
			X		=>	addendum0,
			Y		=>	addendum1,
			Z		=>	addendum2,
			S		=>	sum_out
		);

	with mode select
		display_en <=	"1111" when '0',
						"1011" when others;
	with mode select
		data_to_display <=	"000000" & sum_out when '0',
							"00" & count_out & "0000" & mux_out when others;
	
	display_driver : driver_7seg
		generic map (50000000, 5000)
		port map (
			reset_n			=>	reset_n,
			clock 			=>	clock,
			display_en 		=>	display_en,
			data 			=>	data_to_display,
			dot_en 			=>	dot_en,
			display_on_n 	=>	display_on_n,
			segment_on_n	=>	segment_on_n,
			dot_on_n		=>	dot_on_n
		);
	

end;
