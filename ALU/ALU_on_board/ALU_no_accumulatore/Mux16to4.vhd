----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:57:30 11/21/2015 
-- Design Name: 
-- Module Name:    Mux16to4 - Behavioral 
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

entity Mux16to4 is
    Port ( I : in  STD_LOGIC_VECTOR (15 downto 0);
           sel : in  STD_LOGIC_VECTOR (1 downto 0);
           O : out  STD_LOGIC_VECTOR (3 downto 0));
end Mux16to4;

architecture Behavioral of Mux16to4 is

alias parte0 is I(3 downto 0);
alias parte1 is I(7 downto 4);
alias parte2 is I(11 downto 8);
alias parte3 is I(15 downto 12);

begin

	with sel select
		O<= parte0 when "00",
			parte1 when "01",
			parte2 when "10",
			parte3 when "11",
			"XXXX" when others;


end Behavioral;

