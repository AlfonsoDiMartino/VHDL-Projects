library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity esponenziale is
	Generic (N : natural := 8);
    Port ( start : in  STD_LOGIC;
           clock : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           base : in  STD_LOGIC_VECTOR (N-1 downto 0);
           exp : in  STD_LOGIC_VECTOR (N-1 downto 0);
           done : out  STD_LOGIC;
			  truncate : out STD_LOGIC;
           result : out  STD_LOGIC_VECTOR ((2*N)-1 downto 0));
end esponenziale;

architecture Behavioral of esponenziale is

COMPONENT mux_2to1_generic
	GENERIC (N : natural);
	PORT(
		X : IN std_logic_vector(N-1 downto 0);
		Y : IN std_logic_vector(N-1 downto 0);
		S : IN std_logic;          
		Z : OUT std_logic_vector(N-1 downto 0)
		);
	END COMPONENT;

	component buffer_register is
		generic	(
			N : natural := 8
		);
		port (
			clk 	: in  STD_LOGIC;
			load 	: in  STD_LOGIC;
			clear_n : in STD_LOGIC;
			I 		: in  STD_LOGIC_VECTOR (N-1 downto 0);
			Q 		: out  STD_LOGIC_VECTOR (N-1 downto 0)
		);
	end component;
	
COMPONENT generic_counter
	GENERIC (N : integer);
	PORT(
		clock : IN std_logic;
		reset_n : IN std_logic;
		enable : IN std_logic;
		load : IN std_logic;
		count_in : IN std_logic_vector(N-1 downto 0);
		count_max : IN std_logic_vector(N-1 downto 0);          
		count_out : OUT std_logic_vector(N-1 downto 0);
		done : OUT std_logic
		);
	END COMPONENT;	

component mac_multiplier is
	generic (
		N : integer := 8
	);
	port (	
		x		: in std_logic_vector(N-1 downto 0);
		y		: in std_logic_vector(N-1 downto 0);
		prod	: out std_logic_vector ((2*N)-1 downto 0)
	);
end component;
	
COMPONENT generic_or
	GENERIC (N : natural);
	PORT(
		x : IN std_logic_vector(N-1 downto 0);          
		or_x : OUT std_logic
		);
	END COMPONENT;	
	
COMPONENT D_Latch
	PORT(
		i : IN std_logic;
		clock : IN std_logic;
		load : IN std_logic;
		reset_n : IN std_logic;          
		q : OUT std_logic
		);
	END COMPONENT;

COMPONENT cu_exp
	GENERIC (N : natural);
	PORT(
		start : IN std_logic;
		clock : IN std_logic;
		reset_n : IN std_logic;
		EXP : IN std_logic_vector(N-1 downto 0);
		count_done : IN std_logic;          
		sel_acc : OUT std_logic;
		sel_base : OUT std_logic;
		load_acc : OUT std_logic;
		load_base : OUT std_logic;
		load_t_ff : OUT std_logic;
		reset_acc_n : OUT std_logic;
		reset_base_n : OUT std_logic;
		reset_t_ff_n : OUT std_logic;
		count_en : OUT std_logic;
		reset_count_n : OUT std_logic;
		done : OUT std_logic
		);
	END COMPONENT;
	
	
-- seganli uscita dai mux in ingresso ai registri
signal tmp_mux_acc_out : std_logic_vector (2*N -1 downto 0) := (others => '0');
signal tmp_mux_base_out : std_logic_vector (N-1 downto 0) := (others => '0');

-- segnali moltiplicatore
signal tmp_result_mac : std_logic_vector (4*N -1 downto 0) := (others => '0');
signal tmp_base : std_logic_vector (2*N -1 downto 0) := (others => '0');

-- segnale per inizializzazione registri
signal tmp_mux_in_0 : std_logic_vector (2*N-1 downto 0) := (others => '0');
signal sel_acc, sel_base : std_logic := '0';

-- segnali registro accumulatore
signal en_acc, tmp_reset_n_acc  : std_logic := '0';
signal tmp_acc_out : std_logic_vector (2*N -1 downto 0) := (others => '0');

-- segnali registro base
signal en_base, tmp_reset_n_base  : std_logic := '0';
signal tmp_base_out : std_logic_vector (N -1 downto 0) := (others => '0');

-- segnali counter
signal en_counter, tmp_reset_n_counter, tmp_count_done : std_logic := '0';
constant count_in_null : std_logic_vector (N-1 downto 0) := (others => '0');

-- segnali gestione troncamento
signal en_truncate_ff, tmp_reset_n_truncate_ff : std_logic := '0';
signal tmp_truncate_ff_in, tmp_truncate_ff_out : std_logic := '0';
signal tmp_or_2N : std_logic := '0';

signal tmp_result : std_logic_vector (2*N-1 downto 0) := (others => '0');
signal tmp_done : std_logic := '0';


begin


tmp_mux_in_0(0) <= '1';


MUX_ACC: mux_2to1_generic 
	GENERIC MAP (2*N)
	PORT MAP(
		X => tmp_mux_in_0,
		Y => tmp_result,
		S => sel_acc,
		Z => tmp_mux_acc_out
	);
	
MUX_BASE: mux_2to1_generic 
	GENERIC MAP (N)
	PORT MAP(
		X => tmp_mux_in_0(N-1 downto 0),
		Y => base,
		S => sel_base,
		Z => tmp_mux_base_out
	);	

REG_ACCUMULATORE : buffer_register 
	GENERIC MAP (2*N)
	PORT MAP(
		I => tmp_mux_acc_out,
		clk => clock,
		load => en_acc,
		clear_n => tmp_reset_n_acc,
		Q => tmp_acc_out
	);


REG_BASE : buffer_register 
	GENERIC MAP (N)
	PORT MAP(
		I => tmp_mux_base_out,
		clk => clock,
		load => en_base,
		clear_n => tmp_reset_n_base,
		Q => tmp_base_out
	);
	
tmp_base(N-1 downto 0) <= tmp_base_out;
tmp_result <= tmp_result_mac(2*N-1 downto 0);
	
MUL : mac_multiplier 
	GENERIC MAP(2*N)
	PORT MAP(
		x => tmp_base,
		y => tmp_acc_out,
		prod => tmp_result_mac
	);	

OR_2N : generic_or
	GENERIC MAP(2*N)
	PORT MAP(
		x => tmp_result_mac(4*N-1 downto 2*N),
		or_x => tmp_or_2N
	);
	
tmp_truncate_ff_in <= tmp_or_2N or tmp_truncate_ff_out;	
	
TRUNCATE_FF : D_Latch 
	PORT MAP(
		i => tmp_truncate_ff_in,
		clock => clock,
		load => en_truncate_ff,
		reset_n => tmp_reset_n_truncate_ff,
		q => tmp_truncate_ff_out
	);	
	
PROD_COUNT: generic_counter 
	GENERIC MAP(N)
	PORT MAP(
		clock => clock,
		reset_n => tmp_reset_n_counter,
		enable => en_counter,
		load => '0',
		count_in => count_in_null,
		count_max => exp,
		count_out => open,
		done => tmp_count_done
	);
	
EXP_CU: cu_exp 
	GENERIC MAP(N)
	PORT MAP(
		start 			=> start,
		clock 			=> clock,
		reset_n 			=> reset_n,
		EXP 				=> exp,
		count_done 		=> tmp_count_done,
		sel_acc 			=> sel_acc,
		sel_base 		=> sel_base,
		load_acc 		=> en_acc,
		load_base 		=> en_base,
		load_t_ff		=> en_truncate_ff,
		reset_acc_n 	=> tmp_reset_n_acc,
		reset_base_n 	=> tmp_reset_n_base,
		reset_t_ff_n	=> tmp_reset_n_truncate_ff,
		count_en 		=> en_counter,
		reset_count_n 	=> tmp_reset_n_counter,
		done 				=> tmp_done
	);
	
result 	<= tmp_acc_out;
done		<= tmp_done;
truncate <= tmp_truncate_ff_out;

end Behavioral;
