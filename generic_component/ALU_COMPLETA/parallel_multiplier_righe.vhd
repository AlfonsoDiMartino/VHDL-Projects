----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:09:12 12/18/2015 
-- Design Name: 
-- Module Name:    parallel_multiplier_righe - Behavioral 
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

entity parallel_multiplier_righe is
	 generic	(N : natural := 8);
    port ( X : in  STD_LOGIC_VECTOR (N-1 downto 0);
           Y : in  STD_LOGIC_VECTOR (N-1 downto 0);
           PROD : out  STD_LOGIC_VECTOR ((2*N)-1 downto 0)
			 );
end parallel_multiplier_righe;

architecture Behavioral of parallel_multiplier_righe is
	
	COMPONENT partial_prod_matrix
	GENERIC (N : natural);
	PORT(
		a : IN std_logic_vector(N-1 downto 0);
		b : IN std_logic_vector(N-1 downto 0);          
		ab : OUT std_logic_vector((N*N)-1 downto 0)
		);
	END COMPONENT;
	
	COMPONENT partial_sum_row
	GENERIC (N : natural);
	PORT(
		X : IN std_logic_vector(N-1 downto 0);
		Y : IN std_logic_vector(N-1 downto 0);          
		SUM : OUT std_logic_vector(N-1 downto 0);
		P : OUT std_logic
		);
	END COMPONENT;

	
signal tmp_partial_prod_matrix : std_logic_vector((N*N)-1 downto 0) := (others => '0');
signal tmp_sum_in :  std_logic_vector((N*N)-1 downto 0) := (others => '0');
signal tmp_p : std_logic_vector(N-1 downto 0) := (others => '0');

alias first_row is tmp_partial_prod_matrix(N-1 downto 0);


begin

tmp_p(0) <= tmp_partial_prod_matrix(0);
tmp_sum_in(N-1 downto 0) <= '0' & tmp_partial_prod_matrix (N-1 downto 1);

Inst_partial_prod_matrix: partial_prod_matrix 
	GENERIC MAP(N)
	PORT MAP(
		a => X,
		b => Y,
		ab => tmp_partial_prod_matrix
	);
		
Others_row : for i in N-2 downto 0 generate
	Inst_partial_sum_row_Others: partial_sum_row 
	GENERIC MAP(N)
	PORT MAP(
		X => tmp_sum_in((N*(i+1))-1 downto (N*i)),
		Y => tmp_partial_prod_matrix((N*(i+2))-1 downto (N*(i+1))),
		SUM => tmp_sum_in((N*(i+2))-1 downto (N*(i+1))),
		P => tmp_p(i+1)
	);	
end generate;	

PROD <= tmp_sum_in((N*N)-1 downto N*(N-1)) & tmp_p;

end Behavioral;

