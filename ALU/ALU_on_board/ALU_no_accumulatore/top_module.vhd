library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_module is
	Generic (N : natural := 8);
    Port ( reset : in  STD_LOGIC; --button 0
			  clock : in  STD_LOGIC;
           data_in : in  STD_LOGIC_VECTOR (N-1 downto 0);
           switch_mode : in  STD_LOGIC; --button 1
			  button_2 : in STD_LOGIC;
			  button_3 : in STD_LOGIC;
           anodes : out  STD_LOGIC_VECTOR (3 downto 0);
           cathodes : out  STD_LOGIC_VECTOR (6 downto 0);
           dots : out  STD_LOGIC;
           led : out  STD_LOGIC_VECTOR (7 downto 0));
end top_module;

architecture Behavioral of top_module is

COMPONENT buffer_register
	GENERIC( N : natural := 8);
	PORT(
		I : IN std_logic_vector(N-1 downto 0);
		clk : IN std_logic;
		load : IN std_logic;
		clear_n : IN std_logic;          
		Q : OUT std_logic_vector(N-1 downto 0)
		);
	END COMPONENT;
	
COMPONENT button_debouncer
	GENERIC (lazy : natural);
	PORT(
		clock : IN std_logic;
		reset_n : IN std_logic;
		key : IN std_logic;          
		pulse : OUT std_logic
		);
	END COMPONENT;
	
COMPONENT reg_counter
	PORT(
		clock : IN std_logic;
		reset_n : IN std_logic;
		count_in : IN std_logic;          
		count_out : OUT std_logic_vector(1 downto 0)
		);
	END COMPONENT;
	
COMPONENT ALU
	GENERIC ( N : integer := 8);
	PORT(
		clock		: in std_logic;
		reset_n		: in std_logic;
		start 	: in std_logic;
		operand1	: in std_logic_vector(N-1 downto 0);
		operand2	: in std_logic_vector(N-1 downto 0);
		conf		: in std_logic_vector(2 downto 0);
		status		: out std_logic_vector(1 downto 0);
		result		: out std_logic_vector(2*N-1 downto 0)
	);
END COMPONENT;

	
COMPONENT control_unit
	GENERIC ( N : natural := 8);
	PORT(
		clock : IN std_logic;
		reset_n : IN std_logic;
		button_2 : IN std_logic;
		button_3 : IN std_logic;
		data_in : IN std_logic_vector(N-1 downto 0);
		count_in : IN std_logic_vector(1 downto 0);
		result : IN std_logic_vector(15 downto 0);
		status_alu: in STD_LOGIC_VECTOR(1 downto 0);
		op_status : out STD_LOGIC; 
		done : out STD_LOGIC;
		load_op1 : OUT std_logic;
		load_op2 : OUT std_logic;
		start : OUT std_logic;
		display_en : OUT std_logic_vector(3 downto 0);
		operation_sel : OUT std_logic_vector(2 downto 0);
		data_out : OUT std_logic_vector(2*N-1  downto 0);
		led 	: out STD_LOGIC_VECTOR (1 downto 0)
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


alias led_done is led(0);
alias led_status_op is led(1);
alias led_code_op is led(5 downto 3);
alias led_mode is led (7 downto 6);

signal tmp_count_in, tmp_start, tmp_done, tmp_op : std_logic :='0';
signal tmp_count_button : std_logic_vector (1 downto 0) := (others =>'0');
signal tmp_load_op1, tmp_load_op2 : std_logic := '0';
signal tmp_operation_sel : std_logic_vector (2 downto 0);
signal tmp_op1, tmp_op2 : std_logic_vector (N-1 downto 0) := (others => '0');
signal tmp_result, tmp_data_out : std_logic_vector (2*N-1 downto 0) := (others => '0');
signal tmp_led : std_logic_vector (1 downto 0) := (others => '0');
signal tmp_status : std_logic_vector (1 downto 0) := (others => '0');
begin

led_done <= tmp_done;
led_status_op <= tmp_op;
led_code_op <= tmp_operation_sel;
led_mode <= tmp_led;

BUFFER_OP1: buffer_register 
	GENERIC MAP(N)
	PORT MAP(
		I => data_in,
		clk => clock,
		load => tmp_load_op1,
		clear_n => not reset,
		Q => tmp_op1
	);
	
BUFFER_OP2: buffer_register 
	GENERIC MAP(N)		
	PORT MAP(
		I => data_in,
		clk => clock,
		load => tmp_load_op2,
		clear_n => not reset,
		Q => tmp_op2
	);
	
Inst_button_debouncer: button_debouncer 
	GENERIC MAP(25)
	PORT MAP(
		clock => clock,
		reset_n => not reset,
		key => switch_mode,
		pulse => tmp_count_in
	);
	
	
Inst_reg_counter: reg_counter 
	PORT MAP(
		clock => clock,
		reset_n => not reset,
		count_in => tmp_count_in,
		count_out => tmp_count_button
	);
	
Inst_ALU: ALU
	GENERIC MAP(N)
	PORT MAP(
		clock	=> clock,
		reset_n => not reset,
		start => tmp_start,
		operand1	=> tmp_op1,
		operand2	=> tmp_op2,
		conf => tmp_operation_sel,
		status => tmp_status,
		result => tmp_result
	); 
	
Inst_control_unit: control_unit 
	GENERIC MAP(N)
	PORT MAP(
		clock => clock,
		reset_n => not reset,
		button_2 => button_2,
		button_3 => button_3,
		data_in => data_in,
		count_in => tmp_count_button,
		result => tmp_result,
		status_alu => tmp_status,
		op_status => tmp_op,
		done => tmp_done,
		load_op1 => tmp_load_op1,
		load_op2 => tmp_load_op2,
		start => tmp_start,
		display_en => open,
		operation_sel => tmp_operation_sel,
		data_out => tmp_data_out,
		led 	=> tmp_led

	);

Inst_display: display 
	PORT MAP(
		display_enable => "1111",
		clk => clock,
		data_in => tmp_data_out(15 downto 0),
		dots => "1111",
		reset_n => not reset,
		anodi => anodes,
		catodi => cathodes,
		punto => dots
	);
	


end Behavioral;

