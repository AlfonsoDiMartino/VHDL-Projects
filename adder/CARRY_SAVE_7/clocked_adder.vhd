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
	generic (N : natural := 8);
	port( 
			in0 : in std_logic_Vector(N-1 downto 0);
			in1 : in std_logic_Vector(N-1 downto 0);
			in2 : in std_logic_Vector(N-1 downto 0);
			in3 : in std_logic_Vector(N-1 downto 0);
			in4 : in std_logic_Vector(N-1 downto 0);
			in5 : in std_logic_Vector(N-1 downto 0);
			in6 : in std_logic_Vector(N-1 downto 0);
		--	carry_in : in std_logic ;
		-- carry_out : out std_logic;
			sum : out std_logic_vector(N+2 downto 0);
			clock : in std_logic
			);
			
end clocked_adder;

architecture Behavioral of clocked_adder is

COMPONENT buffer_register
	generic( n : natural);
	PORT(
		I : IN std_logic_vector(n-1 downto 0);
		clk : IN std_logic;
		load : IN std_logic;
		clear_n : IN std_logic;          
		Q : OUT std_logic_vector(n-1 downto 0)
		);
	END COMPONENT;

	

COMPONENT adder
	PORT(
		in0 : IN std_logic_vector(7 downto 0);
		in1 : IN std_logic_vector(7 downto 0);
		in2 : IN std_logic_vector(7 downto 0);
		in3 : IN std_logic_vector(7 downto 0);
		in4 : IN std_logic_vector(7 downto 0);
		in5 : IN std_logic_vector(7 downto 0);
		in6 : IN std_logic_vector(7 downto 0);          
		sum : OUT std_logic_vector(10 downto 0)
		);
	END COMPONENT;


signal tmp_addendo1,tmp_addendo2,tmp_addendo3,tmp_addendo4,tmp_addendo5,tmp_addendo6,tmp_addendo7: std_logic_vector(N-1 downto 0);
--signal tmp_carry_out : std_logic;
signal tmp_somma_register, tmp_somma  : std_logic_vector(N+2 downto 0);

begin

--carry_out <= tmp_carry_out;
sum <= tmp_somma_register;

ADDENDO1: buffer_register 
		generic map(8)
		PORT MAP(
		I => in0 ,
		clk => clock,
		load => '1',
		clear_n => '1',
		Q => tmp_addendo1
	);


ADDENDO2 : buffer_register 
		generic map(8)
		PORT MAP(
		I => in1,
		clk => clock,
		load => '1',
		clear_n => '1',
		Q => tmp_addendo2
	);
	
ADDENDO3 : buffer_register 
		generic map(8)
		PORT MAP(
		I => in2,
		clk => clock,
		load => '1',
		clear_n => '1',
		Q => tmp_addendo3
	);
ADDENDO4 : buffer_register 
		generic map(8)
		PORT MAP(
		I => in3,
		clk => clock,
		load => '1',
		clear_n => '1',
		Q => tmp_addendo4
	);
	
ADDENDO5 : buffer_register 
		generic map(8)
		PORT MAP(
		I => in4,
		clk => clock,
		load => '1',
		clear_n => '1',
		Q => tmp_addendo5
	);
	
ADDENDO6 : buffer_register 
		generic map(8)
		PORT MAP(
		I => in5,
		clk => clock,
		load => '1',
		clear_n => '1',
		Q => tmp_addendo6
	);
	
ADDENDO7 : buffer_register 
		generic map(8)
		PORT MAP(
		I => in6,
		clk => clock,
		load => '1',
		clear_n => '1',
		Q => tmp_addendo7
	);
	
RISULTATO : buffer_register
		generic map(11)
		PORT MAP(
		I => tmp_somma,
		clk => clock,
		load => '1',
		clear_n => '1',
		Q => tmp_somma_register
	);
	
Generic_ADDER: 
		adder PORT MAP(
		in0 => tmp_addendo1,
		in1 => tmp_addendo2,
		in2 => tmp_addendo3,
		in3 => tmp_addendo4,
		in4 => tmp_addendo5,
		in5 => tmp_addendo6,
		in6 => tmp_addendo7,
		sum => tmp_somma
	);


end Behavioral;
