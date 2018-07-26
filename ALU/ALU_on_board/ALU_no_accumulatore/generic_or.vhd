library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity generic_or is
	 Generic (N : natural := 8);
    Port ( x : in  STD_LOGIC_VECTOR (N-1 downto 0);
           or_x : out  STD_LOGIC);
end generic_or;

architecture DataFlow of generic_or is

signal tmp_or_x : std_logic_vector(N downto 0) := (others => '0');

begin

tmp_or_x(0) <= '0';

or_chain : for i in N-1 downto 0 generate
		tmp_or_x(i+1) <= x(i) or tmp_or_x(i);
	end generate;

or_x <= tmp_or_x(N);

end DataFlow;

