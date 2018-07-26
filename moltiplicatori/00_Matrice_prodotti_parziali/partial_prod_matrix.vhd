----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:51:55 12/17/2015 
-- Design Name: 
-- Module Name:    partial_prod_matrix - Behavioral 
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

entity partial_prod_matrix is
	generic(N : in natural := 8);
	port(
			a : in std_logic_vector (N-1 downto 0);
			b : in std_logic_vector (N-1 downto 0);
			ab : out std_logic_vector ((N*N)-1 downto 0)
		 );	
end partial_prod_matrix;


architecture Behavioral of partial_prod_matrix is

COMPONENT partial_product_row
	GENERIC(N : natural);
	PORT(
		a : IN std_logic_vector(N-1 downto 0);
		b : IN std_logic;          
		ab : OUT std_logic_vector(N-1 downto 0)
		);
	END COMPONENT;

signal tmp_prod : std_logic_vector((N*N)-1 downto 0) := (others => '0');

begin

matrix : for i in N-1 downto 0 generate

	Inst_partial_product_row: partial_product_row 
		GENERIC MAP(N)
		PORT MAP(
		a => a,
		b => b(i),
		ab => tmp_prod((N*(i+1))-1 downto (i*N))
	);
end generate;

ab <= tmp_prod;

end Behavioral;

