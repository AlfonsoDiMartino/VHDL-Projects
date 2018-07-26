----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:55:00 11/12/2015 
-- Design Name: 
-- Module Name:    mac_multiplier - Behavioral 
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

entity mac_multiplier is
	generic (nbit : integer := 4);
	port (	x, y : in std_logic_vector(nbit-1 downto 0);
			prod : out std_logic_vector ((2*nbit)-1 downto 0));
end mac_multiplier;

architecture structural of mac_multiplier is
	component mac_row
		generic (nbit : natural := 4);
		port (	x : in std_logic_vector (nbit-1 downto 0);
				y : in std_logic;
			sumin : in std_logic_vector (nbit-1 downto 0);
			sumout : out std_logic_vector (nbit-1 downto 0);
			cout : out std_logic);
	end component;
	type sgn_mtx is array(0 to nbit) of std_logic_vector(nbit downto 0);
	signal intermediate : sgn_mtx;
begin
	intermediate(0) <= (intermediate(0)'range => '0');
	row_array :	for i in 0 to nbit-1 generate
		row : mac_row
				generic map (nbit => nbit)
				port map (	x => x,
							y => y(i),
							sumin => intermediate(i)(nbit downto 1),
							sumout => intermediate(i+1)(nbit-1 downto 0),
							cout => intermediate(i+1)(nbit));
		prod(i) <= intermediate(i+1)(0);
	end generate;
	prod((2*nbit)-1 downto nbit-1) <= intermediate(nbit)(nbit downto 0);
end structural;
