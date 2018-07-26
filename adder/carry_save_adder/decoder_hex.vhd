----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:32:16 11/21/2015 
-- Design Name: 
-- Module Name:    decoder_hex - Behavioral 
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

entity decoder_hex is
    Port ( data_in : in  STD_LOGIC_VECTOR (3 downto 0);
           data_out : out  STD_LOGIC_VECTOR (6 downto 0));
end decoder_hex;

architecture Behavioral of decoder_hex is

begin
	with data_in select
	data_out<=  "1000000" when "0000",	   	--zero
					"1111001" when "0001",			--uno
					"0100100" when "0010",			--due
					"0110000" when "0011",			--tre
					"0011001" when "0100",			--quattro
					"0010010" when "0101",			--cinque
					"0000010" when "0110",			--sei
					"1111000" when "0111",			--sette
					"0000000" when "1000",			--otto
					"0010000" when "1001",			--nove
					"0001000" when "1010",			--A
					"0000011" when "1011",			--B
					"1000110" when "1100",			--C
					"0100001" when "1101",			--D
					"0000110" when "1110",			--E
					"0001110" when "1111",			--F
					"1111111" when others;
end Behavioral;

