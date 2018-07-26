----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:59:06 11/23/2015 
-- Design Name: 
-- Module Name:    control_unit - Behavioral 
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

entity control_unit is
    Port ( clock : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           add1_en : in  STD_LOGIC;
           add2_en : in  STD_LOGIC;
           sum_en : in  STD_LOGIC;
           data_in : in  STD_LOGIC_VECTOR (7 downto 0);
			  carry_in: in STD_LOGIC;
           sum : in  STD_LOGIC_VECTOR (7 downto 0);
           display_en : out  STD_LOGIC_VECTOR (3 downto 0);
           data_out : out  STD_LOGIC_VECTOR (15 downto 0);
			  carry_out : out STD_LOGIC);
end control_unit;

architecture Behavioral of control_unit is

begin
main: process( clock, reset_n, add1_en, add2_en, sum_en, data_in, sum)
begin
	if (reset_n ='0') then
		display_en<=(others =>'0');
		data_out <=(others =>'0');
		
	elsif (clock='1' and clock'event) then
		if (add1_en='1') then
			data_out(7 downto 0) <= data_in;
			display_en <="1111";
		elsif (add2_en='1') then
			data_out(15 downto 8) <= data_in;
			display_en <="1111";
		elsif (sum_en ='1') then
			data_out(7 downto 0) <= sum;
			display_en <= "0011";
			carry_out <= carry_in;
		end if;
	end if;
end process;
		
end Behavioral;

