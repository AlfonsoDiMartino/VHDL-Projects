library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity esercizio_2 is
    Port (	start : in  STD_LOGIC;
			 	reset_n : in STD_LOGIC;
				output : out  STD_LOGIC
			);
end esercizio_2;

architecture Behavioral of esercizio_2 is

COMPONENT ring_oscillator
	PORT(
		en : IN std_logic;          
		osc : OUT std_logic
		);
	END COMPONENT;
	
COMPONENT counter_modN
	GENERIC(count_max : integer);
	PORT(
		clock : IN std_logic;
		reset_n : IN std_logic;
		enable : IN std_logic;          
		done : OUT std_logic
		);
	END COMPONENT;
	
COMPONENT counter_modN_1
	GENERIC(count_max : integer);
	PORT(
		clock : IN std_logic;
		reset_n : IN std_logic;
		enable : IN std_logic;          
		done : OUT std_logic
		);
	END COMPONENT;
	
signal clk_base : std_logic := '0';	
signal tmp_out : std_logic_vector(9 downto 0) := (others => '0');
signal tmp_pattern : std_logic := '0';
signal reset_counter : std_logic := '0';

begin

reset_counter <= not tmp_pattern;

clock_gen: ring_oscillator 
	PORT MAP(
		en => start,
		osc => clk_base
		);

counter_mod5: counter_modN 
	GENERIC MAP(5)
	PORT MAP(
		clock => clk_base,
		reset_n => reset_counter,
		enable => start,
		done => tmp_out(0)
	);	

counter_mod7: counter_modN 
	GENERIC MAP(7)
	PORT MAP(
		clock => clk_base,
		reset_n => reset_counter,
		enable => start,
		done => tmp_out(1)
	);	
	
counter_mod10: counter_modN 
	GENERIC MAP(10)
	PORT MAP(
		clock => clk_base,
		reset_n => reset_counter,
		enable => start,
		done => tmp_out(2)
	);	
	
counter_mod15: counter_modN 
	GENERIC MAP(15)
	PORT MAP(
		clock => clk_base,
		reset_n => reset_counter,
		enable => start,
		done => tmp_out(3)
	);	

counter_mod21: counter_modN 
	GENERIC MAP(21)
	PORT MAP(
		clock => clk_base,
		reset_n => reset_counter,
		enable => start,
		done => tmp_out(4)
	);	
	
counter_mod22: counter_modN 
	GENERIC MAP(22)
	PORT MAP(
		clock => clk_base,
		reset_n => reset_counter,
		enable => start,
		done => tmp_out(5)
	);	

counter_mod31: counter_modN 
	GENERIC MAP(31)
	PORT MAP(
		clock => clk_base,
		reset_n => reset_counter,
		enable => start,
		done => tmp_out(6)
	);	

counter_mod35: counter_modN 
	GENERIC MAP(35)
	PORT MAP(
		clock => clk_base,
		reset_n => reset_counter,
		enable => start,
		done => tmp_out(7)
	);	

counter_mod39: counter_modN 
	GENERIC MAP(39)
	PORT MAP(
		clock => clk_base,
		reset_n => reset_counter,
		enable => start,
		done => tmp_out(8)
	);	

counter_mod47: counter_modN 
	GENERIC MAP(47)
	PORT MAP(
		clock => clk_base,
		reset_n => reset_counter,
		enable => start,
		done => tmp_out(9)
	);	
	
counter_mod56 :	counter_modN_1 
	GENERIC MAP(56)
	PORT MAP(
		clock => clk_base,
		reset_n => reset_n,
		enable => start,
		done => tmp_pattern
	);	

output <= tmp_out(0) xor tmp_out(1) xor tmp_out(2) xor tmp_out(3) xor tmp_out(4) xor tmp_out(5) xor tmp_out(6) xor tmp_out(7) xor tmp_out(8) xor tmp_out(9);
end Behavioral;

