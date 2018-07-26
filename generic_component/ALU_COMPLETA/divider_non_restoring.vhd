library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity divider_non_restoring is
	generic( N : natural := 8);
	port(
			D : in std_logic_vector(N-1 downto 0);
			V : in std_logic_vector(N-1 downto 0);
			Q : out std_logic_vector(N-1 downto 0);
			R : out std_logic_vector(N-1 downto 0);
			clock : in std_logic;
			reset_n : in std_logic;
			start : in std_logic;
			done : out std_logic;
			div_by_zero : out std_logic
		);	
			
end divider_non_restoring;

architecture Behavioral of divider_non_restoring is

COMPONENT CU_Diveder_Non_Restoring
	generic (N : natural);
	PORT(
		clock : IN std_logic;
		reset_n : IN std_logic;
		start : IN std_logic;
--		M_is_zero : IN std_logic;
--		M_is_zero_out : OUT std_logic;
		count_done : IN std_logic;
		S : IN std_logic;  
		S_correzione : in std_logic;		
		done : OUT std_logic;
		reset_count_n : OUT std_logic;
		count_en : OUT std_logic;
		l_shift_A : OUT std_logic;
		l_shift_Q : OUT std_logic;
		subtract : OUT std_logic;
		enable_A : OUT std_logic;
		enable_Q : OUT std_logic;
		enable_M : OUT std_logic;
		reset_A_n : OUT std_logic;
		reset_Q_n : OUT std_logic;
		reset_M_n : OUT std_logic
		);
	END COMPONENT;
	
	
COMPONENT RCA_subtractor
	GENERIC(N: natural);
	PORT(
		x : IN std_logic_vector(N-1 downto 0);
		y : IN std_logic_vector(N-1 downto 0);
		sub_add_n : IN std_logic;          
		sum : OUT std_logic_vector(N-1 downto 0);
		carry_out : OUT std_logic
		);
	END COMPONENT;
	
COMPONENT left_shift_register
	GENERIC(N: natural);
	PORT(
		clock : IN std_logic;
		reset_n : IN std_logic;
		load_data : IN std_logic;
		shift : IN std_logic;
		serial_in : IN std_logic;
		parallel_in : IN std_logic_vector(N-1 downto 0);          
		serial_out : OUT std_logic;
		parallel_out : OUT std_logic_vector(N-1 downto 0)
		);
	END COMPONENT;


COMPONENT counterModN
	GENERIC(N: natural);
	PORT(
		reset_n : IN std_logic;
		clock : IN std_logic;
		enable : IN std_logic;          
		count : OUT std_logic_vector(integer(ceil(log2(real(N)))) downto 0)
		);
	END COMPONENT;


	COMPONENT buffer_register
	GENERIC(N: natural);
	PORT(
		I : IN std_logic_vector(N-1 downto 0);
		clk : IN std_logic;
		load : IN std_logic;
		clear_n : IN std_logic;          
		Q : OUT std_logic_vector(N-1 downto 0)
		);
	END COMPONENT;


COMPONENT M_ZERO_control
	GENERIC (N: natural);
	PORT(
		M : IN std_logic_vector(N-1 downto 0);  
		clock: in STD_LOGIC;
		reset_n: in STD_LOGIC;
		M_zero : OUT std_logic
		);
	END COMPONENT;

	
signal tmp_sub : std_logic := '0';

signal tmp_parallel_out_Q, tmp_parallel_out_M : std_logic_vector (N-1 downto 0) := (others => '0');	
signal tmp_division_by_zero : std_logic := '0';
signal tmp_enable_A, tmp_enable_Q, tmp_enable_M, tmp_enable_count : std_logic := '0';
signal tmp_reset_n_A, tmp_reset_n_Q, tmp_reset_n_M, tmp_reset_n_count : std_logic := '0';
signal tmp_count : std_logic_vector(integer(ceil(log2(real(N)))) downto 0) := (others => '0');
signal tmp_l_shift_A, tmp_l_shift_Q : std_logic := '0';
signal tmp_parallel_in_Q : std_logic_vector(N-1 downto 0) := (others => '0');
signal tmp_s : std_logic := '0';
signal tmp_M_zero: std_logic := '0';

signal tmp_subtractor_in_A, tmp_subtractor_in_M, tmp_out_subtractor : std_logic_vector(N downto 0) := (others => '0');		-- sono sempre un nibble in pi
signal tmp_parallel_out_A, tmp_parallel_in_A : std_logic_vector (N+1 downto 0) := (others => '0');											-- considero n+1 bit
begin

div_by_zero <= tmp_division_by_zero;

Inst_M_ZERO_control: M_ZERO_control 
	GENERIC MAP(N)
	PORT MAP(
		M => V,
		clock => clock,
		reset_n => reset_n,
		M_zero => tmp_division_by_zero
	);


Inst_CU_Diveder_Non_Restoring: CU_Diveder_Non_Restoring 
		generic map (N)
		PORT MAP(
		clock => clock,
		reset_n => reset_n,
		start => start,
		done => done,
--	   M_is_zero => tmp_M_zero,
--		M_is_zero_out => tmp_division_by_zero,
		reset_count_n => tmp_reset_n_count,
		count_en => tmp_enable_count,
		count_done => tmp_count(integer(ceil(log2(real(N))))),
		S =>	tmp_parallel_out_A(N+1),
		S_correzione => tmp_parallel_out_A(N),
		l_shift_A => tmp_l_shift_A,
		l_shift_Q => tmp_l_shift_Q,
		subtract => tmp_sub,
		enable_A => tmp_enable_A,
		enable_Q => tmp_enable_Q,
		enable_M => tmp_enable_M,
		reset_A_n => tmp_reset_n_A,
		reset_Q_n => tmp_reset_n_Q,
		reset_M_n => tmp_reset_n_M 
	);


tmp_subtractor_in_A <= tmp_parallel_out_A(N downto 0);
tmp_subtractor_in_M <= '0'&tmp_parallel_out_M;

Inst_RCA_subtractor: RCA_subtractor 
		GENERIC MAP(N+1) 
		PORT MAP(
		x => tmp_subtractor_in_A,
		y => tmp_subtractor_in_M,
		sub_add_n => tmp_sub,
		sum => tmp_out_subtractor,
		carry_out => open
	);	

tmp_parallel_in_Q <= D;
tmp_parallel_in_A <= '0' & tmp_out_subtractor;

A_l_shift : left_shift_register 
		GENERIC MAP (N+2) 
		PORT MAP(
		clock => clock,
		reset_n => tmp_reset_n_A,
		load_data => tmp_enable_A,
		shift => tmp_l_shift_A,
		serial_in => tmp_parallel_out_Q(N-1),
		parallel_in => tmp_parallel_in_A,
		serial_out => open,
		parallel_out => tmp_parallel_out_A
	);
	

tmp_s <= not tmp_parallel_out_A(N);

Q_l_shift : left_shift_register 
		GENERIC MAP (N) 
		PORT MAP(
		clock => clock,
		reset_n => tmp_reset_n_Q,
		load_data => tmp_enable_Q,
		shift => tmp_l_shift_Q,
		serial_in => tmp_s,
		parallel_in => tmp_parallel_in_Q,
		serial_out => open,
		parallel_out => tmp_parallel_out_Q
	);
	
	
M_reg : buffer_register 
		GENERIC MAP(N) 
		PORT MAP(
		I => V,
		clk => clock,
		load => tmp_enable_M,
		clear_n => tmp_reset_n_M,
		Q => tmp_parallel_out_M
	);	
	
Inst_counterModN: counterModN 
		GENERIC MAP (N) 
		PORT MAP(
		reset_n => tmp_reset_n_count,
		clock => clock,
		enable => tmp_enable_count,
		count => tmp_count
	);

R <= tmp_parallel_out_A(N-1 downto 0);
Q <= tmp_parallel_out_Q;

end Behavioral;

