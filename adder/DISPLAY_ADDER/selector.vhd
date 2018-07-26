----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:09:05 11/21/2015 
-- Design Name: 
-- Module Name:    selector - Behavioral 
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

entity selector is
    Port ( data_en : in  STD_LOGIC_VECTOR (3 downto 0);
           sel : in  STD_LOGIC_VECTOR (1 downto 0);
           data_out : out  STD_LOGIC_VECTOR (3 downto 0));
end selector;

architecture Behavioral of selector is

begin

	data_out(0) <= '0' when (data_en(0) = '1' and sel="00") else '1';
	data_out(1) <= '0' when (data_en(1) = '1' and sel="01") else '1';
	data_out(2) <= '0' when (data_en(2) = '1' and sel="10") else '1';
	data_out(3) <= '0' when (data_en(3) = '1' and sel="11") else '1';
	

end Behavioral;

