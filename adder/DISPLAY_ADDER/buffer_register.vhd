----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:18:41 11/10/2015 
-- Design Name: 
-- Module Name:    buffer_register - Behavioral 
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

entity buffer_register is
generic( n : natural := 8);
    Port ( I : in  STD_LOGIC_VECTOR (n-1 downto 0);
           clk : in  STD_LOGIC;
           load : in  STD_LOGIC;
			  clear : in STD_LOGIC;
           Q : out  STD_LOGIC_VECTOR (n-1 downto 0));
end buffer_register;

architecture Behavioral of buffer_register is

signal Q_tmp : std_logic_vector(n-1 downto 0);
begin
	process (I,clk,load,clear)
	


	begin
	if (clear = '0') then
		Q_tmp <= (Q_tmp'range =>'0');
	elsif (clk = '1' and clk'event) then
		if (load = '1') then
			Q_tmp <= I;
		end if;
	end if;		 
	end process;
	Q <= Q_tmp;
end Behavioral;

