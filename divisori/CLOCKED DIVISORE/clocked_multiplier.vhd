
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity clocked_MULTIPLIER is
	generic (N : natural := 8);
	port( 
			X : in std_logic_Vector(N-1 downto 0);
			Y : in std_logic_Vector(N-1 downto 0);
			PROD : out std_logic_vector((2*N)-1 downto 0);
			clock : in std_logic
			);
			
end clocked_MULTIPLIER;

architecture Behavioral of clocked_MULTIPLIER is

	
COMPONENT div_wrapper
	GENERIC (nbit : natural := 8);
	PORT(
		clock : IN std_logic;
		reset_n : IN std_logic;
		start : IN std_logic;
		X : IN std_logic_vector(nbit-1 downto 0);
		Y : IN std_logic_vector(nbit-1 downto 0);          
		mul_by_zero : OUT std_logic;
		done : OUT std_logic;
		Prod : OUT std_logic_vector(2*nbit -1 downto 0)
		);
	END COMPONENT;
	
	
component buffer_register 
generic(nbit : in natural := 8);
    Port ( data_in : in  STD_LOGIC_VECTOR (nbit-1 downto 0);
           clock : in  STD_LOGIC;
           load_data : in  STD_LOGIC;
			  reset_n : in STD_LOGIC;
           data_out : out  STD_LOGIC_VECTOR (nbit-1 downto 0));
end component buffer_register;



signal tmp_mult1,tmp_mult2 : std_logic_vector(N-1 downto 0);
signal tmp_prod_register, tmp_prod : std_logic_vector((2*N)-1 downto 0);

begin


PROD <= tmp_prod_register;

MULT1 : buffer_register
	GENERIC MAP (N)
	PORT MAP(
		data_in => X,
		clock => clock,
		load_data => '1',
		reset_n => '1',
		data_out => tmp_mult1
	);

MULT2 : buffer_register
	GENERIC MAP (N)
	PORT MAP(
		data_in => Y,
		clock => clock,
		load_data => '1',
		reset_n => '1',
		data_out => tmp_mult2
	);
	
	
RISULTATO : buffer_register
	GENERIC MAP (2*N)
	PORT MAP(
		data_in => tmp_prod,
		clock => clock,
		load_data => '1',
		reset_n => '1',
		data_out => tmp_prod_register
	);
	
Inst_div_wrapper: div_wrapper 
	GENERIC MAP (N)
	PORT MAP(
		clock => clock,
		reset_n => '1',
		start => '1',
		mul_by_zero => open,
		done => open,
		X => tmp_mult1,
		Y => tmp_mult2,
		Prod => tmp_prod
	);	

end Behavioral;
