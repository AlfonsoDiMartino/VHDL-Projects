----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:34:10 11/10/2015 
-- Design Name: 
-- Module Name:    mac_row - Behavioral 
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

entity mac_row is
	generic (nbit : natural := 4);
	port (	x : in std_logic_vector (nbit-1 downto 0);
		y : in std_logic;
		sumin : in std_logic_vector (nbit-1 downto 0);
		sumout : out std_logic_vector (nbit-1 downto 0);
		cout : out std_logic);
end mac_row;

architecture structural of mac_row is
	component mac_cell
		port (	x: in std_logic;
			y: in std_logic;
			sin : in std_logic;
			cin : in std_logic;
			sout : out std_logic;
			cout : out std_logic);
	end component;
	
	signal carry : std_logic_vector (nbit downto 0) := (others => '0');
begin

	row :	for i in 0 to nbit-1 generate
			cell :	mac_cell 
				port map (x(i), y, sumin(i), carry(i), sumout(i), carry(i+1));
		end generate;
	
	carry(0) <= '0';
	cout <= carry(nbit);
	
end structural;

