----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:48:19 12/30/2015 
-- Design Name: 
-- Module Name:    M_ZERO_control - Behavioral 
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

entity M_ZERO_control is
	generic( N: natural := 8);
    Port ( M : in  STD_LOGIC_VECTOR (N-1 downto 0);
			clock: in STD_LOGIC;
			reset_n: in STD_LOGIC;
           M_zero : out  STD_LOGIC);
end M_ZERO_control;

architecture Behavioral of M_ZERO_control is
--signal tmp_out: std_logic :='0';
constant zero : std_logic_vector (N-1 downto 0) := (others => '0');
begin

main: process (M, clock, reset_n)
 begin
 if reset_n = '0' then
	M_zero <= '0';
 elsif (clock= '1' and clock'event) then
	if M = zero then
		M_zero <= '1';
    else
		M_zero <= '0';
   end if;
 end if;

end process;

--ciclo: for i in 0 to N-1 generate
--	tmp_out <= M(i) or tmp_out;
--end generate;
--
--M_zero <= not tmp_out;

end Behavioral;

