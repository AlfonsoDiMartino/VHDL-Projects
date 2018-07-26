----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:21:29 11/10/2015 
-- Design Name: 
-- Module Name:    skip_logic - Behavioral 
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

entity skip_logic is
	generic (M: natural :=4); 
    Port ( p : in  STD_LOGIC_VECTOR (M-1 downto 0);
           carry_0: in STD_LOGIC;           
			  carry_1 : in  STD_LOGIC;
			  carry_out : out  STD_LOGIC);
end skip_logic;

architecture Behavioral of skip_logic is

COMPONENT And_N
	generic (N: natural :=4);
	PORT(
		a : IN std_logic_vector(N-1 downto 0);          
		and_a : OUT std_logic
		);
	END COMPONENT;

COMPONENT mux2_1
	PORT(
		a : IN std_logic;
		b : IN std_logic;
		sel : IN std_logic;          
		o : OUT std_logic
		);
	END COMPONENT;

	


	signal temp_sel: std_logic;

begin

	Inst_And_N: And_N 
	generic map( N => M)
	PORT MAP(
		a => p,
		and_a => temp_sel
	);
	
	Inst_mux2_1: mux2_1 PORT MAP(
		a => carry_0,
		b => carry_1,
		sel => temp_sel,
		o => carry_out
	);


end Behavioral;

