library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2_1 is
    Port ( a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           sel : in  STD_LOGIC;
           o : out  STD_LOGIC);
end mux2_1;

				
architecture Behavioral of mux2_1 is

begin

o <= (a and sel) or (b and (not sel));

end Behavioral;

