library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity nand_gate is
	 Generic (delay : time := 110 ns);
    Port ( in_1 : in  STD_LOGIC;
			  in_2 : in  STD_LOGIC; 	
           o : out  STD_LOGIC);
end nand_gate;

architecture Behavioral of nand_gate is

begin
	o <= in_1 nand in_2 after delay; 
end Behavioral;

