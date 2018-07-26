----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:16:06 01/16/2016 
-- Design Name: 
-- Module Name:    register_accumulatore - Behavioral 
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

entity register_accumulatore is
	generic( N : natural := 8);
    Port ( I : in  STD_LOGIC_VECTOR (N/2-1 downto 0);
			  accumulatore : in STD_LOGIC_VECTOR (N-1 downto 0);
           clk : in  STD_LOGIC;
           load_I : in  STD_LOGIC;
			  load_Acc: in STD_LOGIC;
			  clear_n : in STD_LOGIC;
           Q : out  STD_LOGIC_VECTOR (N-1 downto 0));

end register_accumulatore;

architecture Behavioral of register_accumulatore is
	 
constant zero: std_logic_vector(N/2 -1 downto 0) := (others =>'0');
signal Q_tmp : std_logic_vector(n-1 downto 0);
signal tmp_i: std_logic_vector (N-1 downto 0) := (others =>'0');

begin
	tmp_i <= zero & I;
	process (I,clk,load_I,load_Acc,clear_n)


	begin
	if (clear_n = '0') then
		Q_tmp <= (Q_tmp'range =>'0');
	elsif (clk = '1' and clk'event) then
		if (load_I = '1') then
			Q_tmp <= tmp_i;
		elsif (load_Acc ='1') then
			Q_tmp <= accumulatore;
		end if;
	end if;		 
	end process;
	Q <= Q_tmp;

end Behavioral;

