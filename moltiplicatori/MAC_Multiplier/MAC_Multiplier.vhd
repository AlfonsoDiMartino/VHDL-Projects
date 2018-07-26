----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:56:51 11/11/2015 
-- Design Name: 
-- Module Name:    MAC_Multiplier - Behavioral 
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

entity Mac_multiplier is
	generic( N : natural := 4);
	port (
			X : in std_logic_vector(N-1 downto 0);
			Y : in std_logic_vector(N-1 downto 0);
			--C_in : in std_logic_vector(N-1 downto 0);
			P : out std_logic_vector((2*N)-1 downto 0)
			);			
end Mac_multiplier;

architecture Structural of MAC_Multiplier is

component MAC_row 
	generic (N : natural);
	port (
			X : in std_logic_vector(N-1 downto 0); 		
			Y_in : in std_logic;									
			S_in : in std_logic_vector(N-1 downto 0);		 
			C_in : in std_logic;									
			S_out : out std_logic_vector(N-1 downto 0);	
			P_out : out std_logic
			);			
end component MAC_row;

signal tmp_sum : std_logic_vector(((N*N)+N)-1 downto 0);
signal tmp_product : std_logic_vector(N-1 downto 0);

begin

tmp_sum (N-1 downto 0) <= ( others => '0');

MAC_ROW_WATERFALL : for i in N-1 downto 0 generate
	Inst_MAC_row: MAC_row 
		GENERIC MAP(N => N)
		PORT MAP(
					X => X,
					Y_in => Y(i),
					S_in => tmp_sum(((i+1)*N)-1 downto (i*N)),
					C_in => '0',
					S_out => tmp_sum((((i+1)*N)+N)-1 downto (i*N)+N),
					P_out => tmp_product(i)
					);
end generate;

P(N-1 downto 0) <= tmp_product;
P((2*N)-1 downto N) <= tmp_sum(tmp_sum'high downto tmp_sum'high - (N-1));
 
end Structural;

