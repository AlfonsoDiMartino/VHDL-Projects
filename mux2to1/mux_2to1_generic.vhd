----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:29:34 11/07/2015 
-- Design Name: 
-- Module Name:    mux_2to1_generic - Behavioral 
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
use work.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux_2to1_generic is
	generic(N:natural := 4);
	port (	X : in std_logic_vector (N-1 downto 0);
				Y : in std_logic_vector (N-1 downto 0);
				S : in std_logic;
				Z : out std_logic_vector(N-1 downto 0)
				);
end mux_2to1_generic;

architecture Behavioral of mux_2to1_generic is

component mux2_1 
	port (
			a : in std_logic;
			b : in std_logic;
			sel : in std_logic;
			o : out std_logic
			);
end component mux2_1;

--signal tmp_X : std_logic_vector (N-1 downto 0) := (others => '0');
--signal tmp_Y :  std_logic_vector (N-1 downto 0) := (others => '0';
--signal 
begin
ciclo_mux : for i in N-1 downto 0 generate
	mux_2to1_inst : mux2_1
		port map(
					a => X(i),
					b => Y(i),
					sel => S,
					o => Z(i)
					);	
end generate;					

end Behavioral;

