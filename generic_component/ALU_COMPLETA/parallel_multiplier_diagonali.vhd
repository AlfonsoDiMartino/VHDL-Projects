----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:09:12 12/18/2015 
-- Design Name: 
-- Module Name:    parallel_multiplier_diagonali - Behavioral 
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

entity parallel_multiplier_diagonali is
	 generic	(N : natural := 8);
    port ( X : in  STD_LOGIC_VECTOR (N-1 downto 0);
           Y : in  STD_LOGIC_VECTOR (N-1 downto 0);
           PROD : out  STD_LOGIC_VECTOR ((2*N)-1 downto 0)
			 );
end parallel_multiplier_diagonali;

architecture Behavioral of parallel_multiplier_diagonali is
	
	COMPONENT partial_prod_matrix
	GENERIC (N : natural);
	PORT(
		a : IN std_logic_vector(N-1 downto 0);
		b : IN std_logic_vector(N-1 downto 0);          
		ab : OUT std_logic_vector((N*N)-1 downto 0)
		);
	END COMPONENT;
	
	COMPONENT partial_sum_diagonal
	generic (N : natural);
	PORT(
		X : IN std_logic_vector(N-2 downto 0);
		Y : IN std_logic_vector(N-1 downto 0);          
		SUM : OUT std_logic_vector(N-2 downto 0);
		COUT : OUT std_logic;
		S : OUT std_logic
		);
	END COMPONENT;

	COMPONENT ripple_carry_adder
	GENERIC (N : natural);
	PORT(
		x : IN std_logic_vector(N-1 downto 0);
		y : IN std_logic_vector(N-1 downto 0);
		carry_in : IN std_logic;          
		carry_out : OUT std_logic;
		sum : OUT std_logic_vector(N-1 downto 0)
		);
	END COMPONENT;


	
	
signal tmp_partial_prod_matrix : std_logic_vector((N*N)-1 downto 0) := (others => '0');
signal tmp_Y_in:  std_logic_vector((N*N)-1 downto 0) := (others => '0');
signal tmp_s, tmp_cout, tmp_somma_finale : std_logic_vector(N-2 downto 0) := (others => '0');
alias first_row is tmp_partial_prod_matrix(N-1 downto 0);
signal tmp: std_logic_vector (N-2 downto 0) := (others => '0');
signal tmp_sum: std_logic_vector (N*(N-1)-1 downto 0);
signal tmp_cout_finale: std_logic;

begin

--disposizione per diagonali della matrice dei prodotti parziali
a: for i in 0 to N-1 generate
	b: for j in 0 to N-1 generate
		tmp_Y_in (i*N+j) <= tmp_partial_prod_matrix (i+j*N);
	end generate;
end generate;


Inst_partial_prod_matrix: partial_prod_matrix 
	GENERIC MAP(N)
	PORT MAP(
		a => X,
		b => Y,
		ab => tmp_partial_prod_matrix
	);
	
tmp_sum (N*(N-1)-1 downto N*(N-2)+1) <= tmp_Y_in (N*N-2 downto N*(N-1));	

Mul: for i in N-2 downto 0 generate	
Inst_partial_sum_diagonal: partial_sum_diagonal 
		GENERIC MAP(N)
		PORT MAP(
		X => tmp_sum((i+1)*(N-2)+ i+1+ (N-2) downto (i+1)*(N-2)+ i+1),
		Y => tmp_Y_in(((i+1)*N)-1 downto (i*N)),
		SUM => tmp_sum(i*(N-2)+ i+ (N-2) downto i*(N-2)+ i),
		COUT => tmp_cout(i),
		S => tmp_s(i)
	);
end generate;

	
tmp <= tmp_Y_in(N*N-1) & tmp_s(N-2 downto 1);

Inst_ripple_carry_adder: ripple_carry_adder 
	generic map(N-1)
	PORT MAP(
		x => tmp,
		y => tmp_cout,
		carry_in => '0',
		carry_out =>tmp_cout_finale ,
		sum => tmp_somma_finale
	);


PROD <= tmp_cout_finale & tmp_somma_finale & tmp_s(0) & tmp_sum(N-2 downto 0) ;

end Behavioral;
