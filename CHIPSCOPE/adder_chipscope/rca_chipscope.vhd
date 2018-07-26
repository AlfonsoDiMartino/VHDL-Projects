library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adder_chipscope is
    Port ( carry_in : in  STD_LOGIC;
           carry_out : out  STD_LOGIC);
end adder_chipscope;

architecture Behavioral of adder_chipscope is

COMPONENT ripple_carry_adder
	GENERIC (N: natural);
	PORT(
		x : IN std_logic_vector(N-1 downto 0);
		y : IN std_logic_vector(N-1 downto 0);
		carry_in : IN std_logic;          
		carry_out : OUT std_logic;
		sum : OUT std_logic_vector(N-1 downto 0)
		);
	END COMPONENT;
	
component vio_addend
  PORT (
    CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
    ASYNC_OUT : OUT STD_LOGIC_VECTOR(127 DOWNTO 0));
end component;	

component vio_sum
  PORT (
    CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
    ASYNC_IN : IN STD_LOGIC_VECTOR(127 DOWNTO 0));
end component;

component i_con
  PORT (
    CONTROL0 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
    CONTROL1 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
    CONTROL2 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0));
end component;



signal CONTROL_ADD_1, CONTROL_ADD_2, CONTROL_SUM : std_logic_vector (35 downto 0) := (others => '0');
signal virtual_out_add_1, virtual_out_add_2, virtual_in_sum : std_logic_vector (127 downto 0) := (others => '0');
	
begin

Inst_ripple_carry_adder: ripple_carry_adder 
	GENERIC MAP(128)
	PORT MAP(
		x => virtual_out_add_1,
		y => virtual_out_add_2,
		carry_in => carry_in,
		carry_out => carry_out,
		sum => virtual_in_sum
	);

VIO_ADD_1_INST : vio_addend
  port map (
    CONTROL => CONTROL_ADD_1,
    ASYNC_OUT => virtual_out_add_1
	);


VIO_ADD_2_INST : vio_addend
  port map (
    CONTROL => CONTROL_ADD_2,
    ASYNC_OUT => virtual_out_add_2
	);
	
VIO_SUM_INST : vio_sum
  port map (
    CONTROL => CONTROL_SUM,
    ASYNC_IN => virtual_in_sum
	);

I_CON_INST : i_con
  port map (
    CONTROL0 => CONTROL_ADD_1,
    CONTROL1 => CONTROL_ADD_2,
    CONTROL2 => CONTROL_SUM
	);
	
end Behavioral;

