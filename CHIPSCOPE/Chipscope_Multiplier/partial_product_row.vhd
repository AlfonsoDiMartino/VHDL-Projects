----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:43:38 12/17/2015 
-- Design Name: 
-- Module Name:    partial_product_row - Behavioral 
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

entity partial_product_row is
	generic( N : in natural := 8);
    Port ( a : in  STD_LOGIC_VECTOR (N-1 downto 0);
           b : in  STD_LOGIC;
           ab : out  STD_LOGIC_VECTOR (N-1 downto 0)
			  );
end partial_product_row;

architecture Behavioral of partial_product_row is

signal tmp_prod : std_logic_vector (N-1 downto 0) := (others => '0');

begin

row_product :  for i in N-1 downto 0 generate
		tmp_prod(i) <= a(i) and b;					
	end generate;
	
ab <= tmp_prod;

end Behavioral;

