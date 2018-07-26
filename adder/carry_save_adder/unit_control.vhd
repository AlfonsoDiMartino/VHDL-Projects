----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:49:13 11/20/2015 
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
    Port ( data_in : in  STD_LOGIC_VECTOR (7 downto 0);
			  reset_n :in STD_LOGIC;
			  msb: in STD_LOGIC;
			  lsb: in STD_LOGIC;
			  dot: in STD_LOGIC;
			  clock: in STD_LOGIC;
           data_out : out  STD_LOGIC_VECTOR (15 downto 0);
           display_enable : out  STD_LOGIC_VECTOR (3 downto 0);
           dots : out  STD_LOGIC_VECTOR (3 downto 0));
end control_unit;

architecture Behavioral of control_unit is
signal temp_enable, temp_dots: std_logic_vector(3 downto 0):=(others =>'0');
signal temp_out: std_logic_vector(15 downto 0):=(others =>'0');

begin
process(data_in, reset_n, msb, lsb, dot, clock)
begin
	if (reset_n='0') then
		temp_out <= (others =>'0');
		temp_enable <= (others =>'0');
		temp_dots <= (others =>'0');
		
	elsif (clock='1' and clock'event) then
		if (msb='1') then
			temp_out(15 downto 8)<= data_in;
		elsif (lsb='1') then
			temp_out(7 downto 0) <= data_in;
		elsif (dot ='1') then 
			temp_dots <= data_in (7 downto 4);
			temp_enable <= data_in (3 downto 0);
		end if;
	end if;

end process;

dots <= temp_dots;
data_out<= temp_out;
display_enable <= temp_enable;
end Behavioral;

