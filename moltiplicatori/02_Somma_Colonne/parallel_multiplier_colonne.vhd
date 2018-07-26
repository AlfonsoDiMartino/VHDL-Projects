----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:47:56 12/19/2015 
-- Design Name: 
-- Module Name:    parallel_multiplier_colonne - Behavioral 
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

entity parallel_multiplier_colonne is
	Generic( N : natural := 8);
    Port ( X : in  STD_LOGIC_VECTOR (7 downto 0);
           Y : in  STD_LOGIC_VECTOR (7 downto 0);
           PROD : out  STD_LOGIC_VECTOR (15 downto 0)
			  );
end parallel_multiplier_colonne;

architecture Behavioral of parallel_multiplier_colonne is

COMPONENT partial_prod_matrix
	PORT(
		a : IN std_logic_vector(7 downto 0);
		b : IN std_logic_vector(7 downto 0);          
		ab : OUT std_logic_vector(63 downto 0)
		);
	END COMPONENT;
	
COMPONENT M0_matrix
	PORT(
		p_m : IN std_logic_vector(63 downto 1);          
		u : OUT std_logic_vector(13 downto 0);
		v : OUT std_logic_vector(12 downto 0);
		w : OUT std_logic_vector(8 downto 0);
		t : OUT std_logic
		);
	END COMPONENT;

COMPONENT M1_matrix
	PORT(
		x : IN std_logic_vector(12 downto 0);
		y : IN std_logic_vector(12 downto 0);
		z : IN std_logic_vector(8 downto 0);
		k : IN std_logic;          
		u : OUT std_logic_vector(12 downto 0);
		v : OUT std_logic_vector(12 downto 0);
		w : OUT std_logic
		);
	END COMPONENT;
	
COMPONENT M2_matrix
	PORT(
		x : IN std_logic_vector(11 downto 0);
		y : IN std_logic_vector(11 downto 0);
		z : IN std_logic;          
		u : OUT std_logic_vector(11 downto 0);
		v : OUT std_logic_vector(11 downto 0)
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


signal tmp_partial_product_matrix : std_logic_vector(63 downto 0) := (others =>'0');

-- segnali i-o di M0_matrix
signal tmp_partial_product_matrix_M0 : std_logic_vector(62 downto 0) := (others =>'0');
signal tmp_u_M0 : std_logic_vector(13 downto 0) := (others =>'0');
signal tmp_v_M0 : std_logic_vector(12 downto 0) := (others =>'0');
signal tmp_w_M0 : std_logic_vector(8 downto 0) := (others =>'0');
signal tmp_t_M0 : std_logic := '0';	

-- segnali i-o di M1_matrix
signal tmp_x_M1 : std_logic_vector(12 downto 0) := (others =>'0');
signal tmp_y_M1 : std_logic_vector(12 downto 0) := (others =>'0');
signal tmp_z_M1 : std_logic_vector(8 downto 0) := (others =>'0');
signal tmp_k_M1 : std_logic := '0';	
signal tmp_u_M1 : std_logic_vector(12 downto 0) := (others =>'0');
signal tmp_v_M1 : std_logic_vector(12 downto 0) := (others =>'0');
signal tmp_w_M1 : std_logic :='0';

-- segnali i-o di M2_matrix
signal tmp_x_M2 : std_logic_vector(11 downto 0) := (others =>'0');
signal tmp_y_M2 : std_logic_vector(11 downto 0) := (others =>'0');
signal tmp_z_M2 : std_logic := '0';	
signal tmp_u_M2 : std_logic_vector(11 downto 0) := (others =>'0');
signal tmp_v_M2 : std_logic_vector(11 downto 0) := (others =>'0');

-- seganli i-o di RCA
signal tmp_x_RCA : std_logic_vector(11 downto 0) := (others => '0');
signal tmp_y_RCA : std_logic_vector(11 downto 0) := (others => '0');
signal tmp_sum_RCA : std_logic_vector(11 downto 0) := (others => '0');

signal tmp_p0, tmp_p1, tmp_p2, tmp_p3 : std_logic := '0';

begin
	
tmp_partial_product_matrix_M0 <=tmp_partial_product_matrix(63 downto 1);  

-- segnali di ingresso di M1_matrix
tmp_x_M1 <= tmp_u_M0(13 downto 1);
tmp_y_M1 <= tmp_v_M0;
tmp_z_M1 <= tmp_w_M0;
tmp_k_M1 <= tmp_t_M0;

-- segnali di ingresso di M2
tmp_x_M2 <= tmp_u_M1(12 downto 1);
tmp_y_M2 <= tmp_v_M1(11 downto 0);
tmp_z_M2 <= tmp_w_M1;

-- segnali di ingresso RCA
tmp_x_RCA <= tmp_v_M1(12) & tmp_u_M2(11 downto 1);
tmp_y_RCA <= tmp_v_M2;

-- prodotti già calcolati 
tmp_p0 <= tmp_partial_product_matrix(0);
tmp_p1 <= tmp_u_M0(0);
tmp_p2 <= tmp_u_M1(0);
tmp_p3 <= tmp_u_M2(0);
	
Inst_partial_prod_matrix: partial_prod_matrix PORT MAP(
		a => X,
		b => Y,
		ab => tmp_partial_product_matrix 
	);
		
Inst_M0_matrix: M0_matrix PORT MAP(
		p_m => tmp_partial_product_matrix_M0,
		u => tmp_u_M0,
		v => tmp_v_M0,
		w => tmp_w_M0,
		t => tmp_t_M0
	);	
	
Inst_M1_matrix: M1_matrix PORT MAP(
		x => tmp_x_M1,
		y => tmp_y_M1,
		z => tmp_z_M1,
		k => tmp_k_M1,
		u => tmp_u_M1,
		v => tmp_v_M1,
		w => tmp_w_M1 
	);	

Inst_M2_matrix: M2_matrix PORT MAP(
		x => tmp_x_M2,
		y => tmp_y_M2,
		z => tmp_z_M2,
		u => tmp_u_M2,
		v => tmp_v_M2
	);	
	
Inst_ripple_carry_adder: ripple_carry_adder 
	GENERIC MAP(12)
	PORT MAP(
		x => tmp_x_RCA,
		y => tmp_y_RCA,
		carry_in => '0',
		carry_out => open,
		sum => tmp_sum_RCA
	);
	
PROD <= tmp_sum_RCA & tmp_p3 & tmp_p2 & tmp_p1 & tmp_p0;	
	
end Behavioral;

