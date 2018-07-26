----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:18:15 11/21/2015 
-- Design Name: 
-- Module Name:    counterMod4 - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counterMod4 is
    Port ( reset_n : in  STD_LOGIC;
           clock : in  STD_LOGIC;
           enable : in  STD_LOGIC;
           count : out  STD_LOGIC_VECTOR (1 downto 0));
end counterMod4;

architecture Behavioral of counterMod4 is

signal temp_count: std_logic_vector( 1 downto 0) := (others =>'0');

begin

process(reset_n, clock, enable)
begin
	if (reset_n='0') then
		temp_count <= (others=>'0');
		elsif (clock='1' and clock'event) then
			if( enable='1') then
			temp_count<=std_logic_vector (unsigned(temp_count)+1);
		   end if;
	end if;			
end process;

count<= temp_count;

end Behavioral;

