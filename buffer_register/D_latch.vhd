----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:36:31 11/05/2015 
-- Design Name: 
-- Module Name:    D_latch - Behavioral 
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

entity D_latch is
    Port ( data_in : in  STD_LOGIC;
           enable : in  STD_LOGIC;
           data_out : out  STD_LOGIC);
end D_latch;

architecture Behavioral of D_latch is
begin
	process(data_in,enable)
	begin
		if (enable='1') then
			data_out <= data_in;
		end if;
end process;		


end Behavioral;

