----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:23:48 11/10/2015 
-- Design Name: 
-- Module Name:    clocked_adder - Behavioral 
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
generic( n : in natural := 8);
    Port ( I : in  STD_LOGIC_VECTOR (n-1 downto 0);
           clk : in  STD_LOGIC;
           load : in  STD_LOGIC;
			  clear : in STD_LOGIC;
           Q : out  STD_LOGIC_VECTOR (n-1 downto 0));
end component buffer_register;

component carry_skip_adder
	generic( N : natural := 8; M : natural :=4; P : natural := 2);
    Port ( X : in  STD_LOGIC_VECTOR (N-1 downto 0);
           Y : in  STD_LOGIC_VECTOR (N-1 downto 0);
           carry_in : in  STD_LOGIC;
           carry_out : out  STD_LOGIC;
           sum : out  STD_LOGIC_VECTOR (N-1 downto 0));
end component carry_skip_adder;

signal tmp_addendo1,tmp_addendo2,tmp_somma : std_logic_vector(N-1 downto 0);
signal tmp_carry_in, tmp_carry_out : std_logic;
signal tmp_somma_register : std_logic_vector(N-1 downto 0);

begin

tmp_carry_in <= carry_in;
carry_out <= tmp_carry_out;
sum <= tmp_somma_register;

ADD1 : buffer_register
	GENERIC MAP (n => N)
	PORT MAP(
		I => X,
		clk => clock,
		load => '1',
		clear => '0',
		Q => tmp_addendo1
	);

ADD2 : buffer_register
	GENERIC MAP (n => N)
	PORT MAP(
		I => Y,
		clk => clock,
		load => '1',
		clear => '0',
		Q => tmp_addendo2
	);
RISULTATO : buffer_register
	GENERIC MAP (n => N)
	PORT MAP(
		I => tmp_somma,
		clk => clock,
		load => '1',
		clear => '0',
		Q => tmp_somma_register
	);
SOMMATORE : carry_skip_adder
	GENERIC MAP(N => N , M => M , P => P)
	PORT MAP(
		X => tmp_addendo1,
		Y => tmp_addendo2,
		carry_in => tmp_carry_in,
		carry_out => tmp_carry_out,
		sum => tmp_somma
	);
end Behavioral;

