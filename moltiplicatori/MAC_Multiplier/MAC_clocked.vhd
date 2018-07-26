----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:53:09 11/12/2015 
-- Design Name: 
-- Module Name:    MAC_clocked - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity MAC_clocked is
	generic (N : natural := 4);
	port( 
			M1 : in std_logic_Vector(N-1 downto 0);
			M2 : in std_logic_Vector(N-1 downto 0);
			PROD : out std_logic_vector(2*N-1 downto 0);
			clock : in std_logic
			);
			
end MAC_clocked;

architecture Behavioral of MAC_clocked is

component buffer_register 
generic( n : natural := 4);
    Port ( I : in  STD_LOGIC_VECTOR (n-1 downto 0);
           clk : in  STD_LOGIC;
           load : in  STD_LOGIC;
			  clear : in STD_LOGIC;
           Q : out  STD_LOGIC_VECTOR (n-1 downto 0));
end component buffer_register;




COMPONENT Mac_multiplier
	generic( N : natural := 4);
	port (
			X : in std_logic_vector(N-1 downto 0);
			Y : in std_logic_vector(N-1 downto 0);
			P : out std_logic_vector((2*N)-1 downto 0)
			);			
	END COMPONENT;

signal tmp_mult1,tmp_mult2 : std_logic_vector(N-1 downto 0);
signal tmp_prod : std_logic_vector(2*N-1 downto 0);
signal tmp_prod_register : std_logic_vector(2*N-1 downto 0);

begin


PROD <= tmp_prod_register;

MULT1 : buffer_register
	GENERIC MAP (n => N)
	PORT MAP(
		I => M1,
		clk => clock,
		load => '1',
		clear => '0',
		Q => tmp_mult1
	);

MULT2 : buffer_register
	GENERIC MAP (n => N)
	PORT MAP(
		I => M2,
		clk => clock,
		load => '1',
		clear => '0',
		Q => tmp_mult2
	);
RISULTATO : buffer_register
	GENERIC MAP (n => 2*N)
	PORT MAP(
		I => tmp_prod,
		clk => clock,
		load => '1',
		clear => '0',
		Q => tmp_prod_register
	);
	

	
Inst_Mac_multiplier: Mac_multiplier 
		GENERIC MAP (N => N)
		PORT MAP(
		X => tmp_mult1,
		Y => tmp_mult2,
		P => tmp_prod
	);
end Behavioral;


