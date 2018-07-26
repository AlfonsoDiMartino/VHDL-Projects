library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder is
    Port ( add_1 : in  STD_LOGIC;
           add_2 : in  STD_LOGIC;
           carry_in : in  STD_LOGIC;
           carry_out : out  STD_LOGIC;
			  sum : out  STD_LOGIC
			 );
end full_adder;

architecture Behavioral of full_adder is

begin

	carry_out <= (add_1 and add_2 ) or (carry_in and (add_1 xor add_2));
	sum <= add_1 xor add_2 xor carry_in;

end Behavioral;

