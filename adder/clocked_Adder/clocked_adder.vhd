library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clocked_adder is
	generic (N : natural := 8; M : natural := 4; P :natural := 2 );
	port( 
			X : in std_logic_Vector(N-1 downto 0);
			Y : in std_logic_Vector(N-1 downto 0);
			carry_in : in std_logic ;
			carry_out : out std_logic;
			sum : out std_logic_vector(N-1 downto 0);
			clock : in std_logic
			);
			
end clocked_adder;

architecture Behavioral of clocked_adder is

component buffer_register 
generic(N : in natural);
    Port ( I : in  STD_LOGIC_VECTOR (N-1 downto 0);
           clk : in  STD_LOGIC;
           load : in  STD_LOGIC;
			  clear_n : in STD_LOGIC;
           Q : out  STD_LOGIC_VECTOR (N-1 downto 0));
end component buffer_register;



COMPONENT adder
	generic(N : natural);
	PORT(
		x : IN std_logic_vector(N-1 downto 0);
		y : IN std_logic_vector(N-1 downto 0);
		carry_in : IN std_logic;          
		carry_out : OUT std_logic;
		sum : OUT std_logic_vector(N-1 downto 0)
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
	

signal tmp_addendo1,tmp_addendo2,tmp_somma : std_logic_vector(N-1 downto 0) := (others => '0');
signal tmp_carry_in, tmp_carry_out, tmp_carry_out_register : std_logic := '0';
signal tmp_somma_register : std_logic_vector(N-1 downto 0) := (others => '0');

begin

--tmp_carry_in <= carry_in;
carry_out <= tmp_carry_out_register;
sum <= tmp_somma_register;

ADDENDO1 : buffer_register
	GENERIC MAP (N)
	PORT MAP(
		I => X,
		clk => clock,
		load => '1',
		clear_n => '1',
		Q => tmp_addendo1
	);

ADDENDO2 : buffer_register
	GENERIC MAP (N)
	PORT MAP(
		I => Y,
		clk => clock,
		load => '1',
		clear_n => '1',
		Q => tmp_addendo2
	);
	

CARRY_IN_REGISTER : D_Latch PORT MAP(
		i => carry_in,
		clock => clock,
		load => '1',
		reset_n => '1',
		q => tmp_carry_in
	);


CARRY_OUT_REGISTER : D_Latch PORT MAP(
		i => tmp_carry_out,
		clock => clock,
		load => '1',
		reset_n => '1',
		q => tmp_carry_out_register
	); 

RISULTATO : buffer_register
	GENERIC MAP (N)
	PORT MAP(
		I => tmp_somma,
		clk => clock,
		load => '1',
		clear_n => '1',
		Q => tmp_somma_register
	);	
	
Generic_ADDER: adder 
		GENERIC MAP(N)
		PORT MAP(
		x => tmp_addendo1 ,
		y => tmp_addendo2,
		carry_in => tmp_carry_in,
		carry_out => tmp_carry_out,
		sum => tmp_somma
	);

end Behavioral;
