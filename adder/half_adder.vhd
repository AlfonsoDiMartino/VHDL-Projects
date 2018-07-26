library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity half_adder is
    Port ( add_1 : in  STD_LOGIC;
           add_2 : in  STD_LOGIC;
           carry : out  STD_LOGIC;
           sum : out  STD_LOGIC);
end half_adder;

architecture Behavioral of half_adder is

begin

carry <= add_1 and add_2;
sum <= (add_1 xor add_2);

end Behavioral;

