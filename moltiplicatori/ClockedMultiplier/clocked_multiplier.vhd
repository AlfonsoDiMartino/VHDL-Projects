
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clocked_MULTIPLIER is
	generic (N : natural := 8; M : natural := 4; P :natural := 2 );
	port( 
			X : in std_logic_Vector(N-1 downto 0);
			Y : in std_logic_Vector(N-1 downto 0);
			PROD : out std_logic_vector((2*N)-1 downto 0);
			clock : in std_logic
			);
			
end clocked_MULTIPLIER;

architecture Behavioral of clocked_MULTIPLIER is


COMPONENT multiplier
	generic (nbit : natural := 8);
	PORT(
		x : IN std_logic_vector(nbit-1 downto 0);
		y : IN std_logic_vector(nbit-1 downto 0);          
		prod : OUT std_logic_vector((2*nbit)-1 downto 0)
		);
	END COMPONENT;




component buffer_register 
generic( n : in natural := 8);
    Port ( I : in  STD_LOGIC_VECTOR (n-1 downto 0);
           clk : in  STD_LOGIC;
           load : in  STD_LOGIC;
			  clear_n : in STD_LOGIC;
           Q : out  STD_LOGIC_VECTOR (n-1 downto 0));
end component buffer_register;



signal tmp_mult1,tmp_mult2 : std_logic_vector(N-1 downto 0);
signal tmp_prod_register, tmp_prod : std_logic_vector((2*N)-1 downto 0);

begin


PROD <= tmp_prod_register;

MULT1 : buffer_register
	GENERIC MAP (n => N)
	PORT MAP(
		I => X,
		clk => clock,
		load => '1',
		clear_n => '1',
		Q => tmp_mult1
	);

MULT2 : buffer_register
	GENERIC MAP (n => N)
	PORT MAP(
		I => Y,
		clk => clock,
		load => '1',
		clear_n => '1',
		Q => tmp_mult2
	);
	
	
RISULTATO : buffer_register
	GENERIC MAP (n => 2*N)
	PORT MAP(
		I => tmp_prod,
		clk => clock,
		load => '1',
		clear_n => '1',
		Q => tmp_prod_register
	);
	
MOLTIPLICATORE: multiplier 
		generic map(nbit => 8)
		PORT MAP(
		x => tmp_mult1,
		y => tmp_mult2,
		prod => tmp_prod
	);



end Behavioral;
