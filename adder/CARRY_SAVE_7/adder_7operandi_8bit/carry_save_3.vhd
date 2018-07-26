----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:53:02 12/11/2015 
-- Design Name: 
-- Module Name:    carry_save_3 - Behavioral 
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

entity carry_save_3 is
    Port ( x0 : in  STD_LOGIC;
			  x1 : in  STD_LOGIC;
			  x2 : in  STD_LOGIC;
           y0 : out  STD_LOGIC;
			  y1: out STD_LOGIC);
end carry_save_3;

architecture Behavioral of carry_save_3 is

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



FA: full_adder PORT MAP(
		add_1 => x0,
		add_2 => x1,
		carry_in => x2,
		carry_out => y1,
		sum => y0
	);
	

end Behavioral;

