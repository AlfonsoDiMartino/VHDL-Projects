----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:19:17 11/11/2015 
-- Design Name: 
-- Module Name:    MAC_Cell - Behavioral 
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

entity MAC_cell is
    Port ( x_in : in  STD_LOGIC;
           y_in : in  STD_LOGIC;
           s_in : in  STD_LOGIC;
           c_in : in  STD_LOGIC;
           s_out : out  STD_LOGIC;
           c_out : out  STD_LOGIC
           --x_out : out  STD_LOGIC;
			  --y_out : out STD_LOGIC
			  );
end MAC_cell;

architecture Structural of MAC_cell is

component full_adder 
    Port ( add_1 : in  STD_LOGIC;
           add_2 : in  STD_LOGIC;
           carry_in : in  STD_LOGIC;
           carry_out : out  STD_LOGIC;
			  sum : out  STD_LOGIC
			 );
end component full_adder;

signal tmp_and : std_logic;			 

begin
tmp_and <= x_in and y_in;

FA : full_adder
	port map (
		add_1 => s_in,
		add_2 => tmp_and,
		carry_in => c_in,
		carry_out => c_out,
		sum => s_out
		);
--x_out <= x_in;
--y_out <= y_in;		

end Structural;
