----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:20:57 10/30/2015 
-- Design Name: 
-- Module Name:    And_N - Behavioral 
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

entity And_N is
	generic (N: natural :=8);
    Port ( a : in  STD_LOGIC_VECTOR (N-1 downto 0);
				b: in std_logic;
           and_a : out  STD_LOGIC_VECTOR (N-1 downto 0));
end And_N;

architecture Behavioral of And_N is
signal temp_and : std_logic_vector(N-1 downto 0) := (others =>'0');


begin



main: process (a,b, temp_and)
begin
for i in N-1 downto 0 loop
temp_and(i) <= a(i) and not b;
end loop;

and_a <=temp_and;

end process;


end Behavioral;

