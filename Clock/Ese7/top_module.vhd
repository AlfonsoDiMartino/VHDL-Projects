
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity top_module is
    Port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           load_min : in  STD_LOGIC;
           load_hour : in  STD_LOGIC;
           data_in : in  STD_LOGIC_VECTOR (7 downto 0);
		   led_out : out std_logic_vector (3 downto 0);
           anodi : out  STD_LOGIC_VECTOR (3 downto 0);
           catodi : out  STD_LOGIC_VECTOR (6 downto 0);
           dots : out  STD_LOGIC);
end top_module;

architecture Structural of top_module is

COMPONENT orologio
	PORT(
		clock: IN std_logic;
		reset_n : IN std_logic;          
		load_min : IN std_logic;          
		min_in : IN std_logic_vector(7 downto 0);
		load_ore : IN std_logic;      
		ore_in : IN std_logic_vector(7 downto 0);
		
		ore : OUT std_logic_vector(4 downto 0);
		min : OUT std_logic_vector(5 downto 0);
		sec : OUT std_logic_vector(1 downto 0)
		);
	END COMPONENT;

COMPONENT display
	PORT(
		display_enable : IN std_logic_vector(3 downto 0);
		clk : IN std_logic;
		data_in : IN std_logic_vector(15 downto 0);
		dots : IN std_logic_vector(3 downto 0);
		reset_n : IN std_logic;          
		anodi : OUT std_logic_vector(3 downto 0);
		catodi : OUT std_logic_vector(6 downto 0);
		punto : OUT std_logic
		);
	END COMPONENT;



COMPONENT decoder_2to4
	PORT(
		data_in : IN std_logic_vector(1 downto 0);          
		data_out : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	
	
COMPONENT convertitore_hex_to_dec
	PORT(
		hex : IN std_logic_vector(7 downto 0);          
		dec : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	
COMPONENT input_filter_hour
	PORT(
		load_in : IN std_logic;
		data_in : IN std_logic_vector(7 downto 0);          
		load_out : OUT std_logic
		);
	END COMPONENT;

COMPONENT input_filter_min
	PORT(
		load_in : IN std_logic;
		data_in : IN std_logic_vector(7 downto 0);          
		load_out : OUT std_logic
		);
	END COMPONENT;	

	
signal tmp_data_in, tmp_data_out : std_logic_vector (15 downto 0) := (others =>'0');	
signal tmp_led : std_logic_vector (3 downto 0) := (others =>'0');
signal tmp_decoder_in : std_logic_vector (1 downto 0) := (others =>'0');
signal filter_load_min, filter_load_hour : std_logic := '0';

begin


Inst_display: display PORT MAP(
		display_enable => "1111",
		clk => clock,
		data_in => tmp_data_out,
		dots => "1011",
		reset_n => not reset,
		anodi => anodi,
		catodi => catodi,
		punto => dots
	);
	
Inst_orologio : orologio
	PORT MAP(
		clock 	=> clock,
		reset_n 	=> not reset,
		load_min => filter_load_min,          
		min_in 	=> data_in,
		load_ore => filter_load_hour,      
		ore_in 	=> data_in,
		
		ore 	=> tmp_data_in(12 downto 8),
		min 	=> tmp_data_in(5 downto 0),
		sec 	=> tmp_decoder_in
		);
		
		
Inst_convertitore_hex_to_dec_min: convertitore_hex_to_dec 
    PORT MAP(
		hex => tmp_data_in (7 downto 0),
		dec => tmp_data_out (7 downto 0)
	);

Inst_convertitore_hex_to_dec_hour: convertitore_hex_to_dec PORT MAP(
		hex => tmp_data_in (15 downto 8),
		dec => tmp_data_out (15 downto 8)
	);

Inst_decoder_2to4: decoder_2to4 
		PORT MAP(
		data_in => tmp_decoder_in,
		data_out => tmp_led
	);
led_out <= tmp_led;

Inst_input_filter_hour: input_filter_hour PORT MAP(
		load_in => load_hour,
		data_in => data_in,
		load_out => filter_load_hour
	);

Inst_input_filter_min: input_filter_min PORT MAP(
		load_in => load_min,
		data_in => data_in,
		load_out => filter_load_min
	);	
		
end Structural;

