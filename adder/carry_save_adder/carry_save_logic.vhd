----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:34:09 11/10/2015 
-- Design Name: 
-- Module Name:    carry_save_logic - Behavioral 
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

entity carry_save_logic is
	 generic (N: natural := 8);
    Port ( x : in  STD_LOGIC_VECTOR (N-1 downto 0);
           y : in  STD_LOGIC_VECTOR (N-1 downto 0);
           z : in  STD_LOGIC_VECTOR (N-1 downto 0);
           cs : out  STD_LOGIC_VECTOR (N-1 downto 0);
           t : out  STD_LOGIC_VECTOR (N-1 downto 0));
end carry_save_logic;



architecture Behavioral of carry_save_logic is


COMPONENT full_adder
	PORT(
		add_1 : IN std_logic;
		add_2 : IN std_logic;
		carry_in : IN std_logic;          
		carry_out : OUT std_logic;
		sum : OUT std_logic
		);
	END COMPONENT;


begin




CSL: for i in N-1 downto 0

	generate
	
	Inst_full_adder: full_adder PORT MAP(
		add_1 => x(i),
		add_2 => y(i),
		carry_in => z(i),
		carry_out => cs(i),
		sum => t(i)
	);



	end generate;



end Behavioral;

