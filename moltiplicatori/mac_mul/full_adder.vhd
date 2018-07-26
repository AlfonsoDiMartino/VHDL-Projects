----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:33:45 11/10/2015 
-- Design Name: 
-- Module Name:    full_adder - Behavioral 
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

entity full_adder is
    Port (	add_1 : in  STD_LOGIC;
		add_2 : in  STD_LOGIC;
		carry_in : in  STD_LOGIC;
		carry_out : out  STD_LOGIC;
		sum : out  STD_LOGIC);
end full_adder;

architecture structural of full_adder is
begin
	carry_out <= (add_1 and add_2 ) or (carry_in and add_1) or (carry_in and add_2);
	sum <= add_1 xor add_2 xor carry_in;
end structural;
