----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:22:49 11/21/2015 
-- Design Name: 
-- Module Name:    filter - Behavioral 
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

entity filter is
	generic (freq_in : integer := 50000000;		
				freq_out: integer := 500);	
    Port ( clock_in : in  STD_LOGIC;
			  reset_n : in  STD_LOGIC;
           clock_out : out  STD_LOGIC);
end filter;


architecture Behavioral of filter is




signal temp_out: std_logic :='0';

begin

process(clock_in, reset_n)
constant max : integer := (freq_in / freq_out)-1;
variable count: integer :=0;
begin
	if (reset_n ='0') then
		count:=0;
		temp_out<='0';
	elsif (clock_in='1' and clock_in'event) then
		
		if (count=max) then
			count:= 0;
			temp_out<='1';
		else
		count:= count+1;
		temp_out <='0';
		end if;
	end if;


end process;

clock_out <= temp_out;

end Behavioral;

