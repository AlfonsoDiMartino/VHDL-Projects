----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:28:45 12/11/2015 
-- Design Name: 
-- Module Name:    adder - Behavioral 
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

entity adder is
    Port ( in0 : in  STD_LOGIC_VECTOR(7 downto 0);
           in1 : in  STD_LOGIC_VECTOR(7 downto 0);
           in2 : in  STD_LOGIC_VECTOR(7 downto 0);
           in3 : in  STD_LOGIC_VECTOR(7 downto 0);
           in4 : in  STD_LOGIC_VECTOR(7 downto 0);
           in5 : in  STD_LOGIC_VECTOR(7 downto 0);
           in6 : in  STD_LOGIC_VECTOR(7 downto 0);
           sum : out  STD_LOGIC_VECTOR(10 downto 0)
			  );
end adder;

architecture Behavioral of adder is


	
COMPONENT stored_carry_encoder_7to3
	PORT(
		in_0 : IN std_logic_vector(7 downto 0);
		in_1 : IN std_logic_vector(7 downto 0);
		in_2 : IN std_logic_vector(7 downto 0);
		in_3 : IN std_logic_vector(7 downto 0);
		in_4 : IN std_logic_vector(7 downto 0);
		in_5 : IN std_logic_vector(7 downto 0);
		in_6 : IN std_logic_vector(7 downto 0);          
		u : OUT std_logic_vector(7 downto 0);
		v : OUT std_logic_vector(8 downto 0);
		w : OUT std_logic_vector(9 downto 0)
		);
	END COMPONENT;

	


COMPONENT stored_carry_encoder_3to2
	PORT(
		u : IN std_logic_vector(7 downto 0);
		v : IN std_logic_vector(7 downto 0);
		w : IN std_logic_vector(7 downto 0);          
		t : OUT std_logic_vector(7 downto 0);
		cs : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;



COMPONENT ripple_carry_adder
	GENERIC(N : natural);
	PORT(
		x : IN std_logic_vector(N-1 downto 0);
		y : IN std_logic_vector(N-1 downto 0);
		carry_in : IN std_logic;          
		carry_out : OUT std_logic;
		sum : OUT std_logic_vector(N-1 downto 0)
		);
	END COMPONENT;


COMPONENT carry_sum
	PORT(
		u : IN std_logic_vector(1 downto 0);
		v : IN std_logic;
		w : IN std_logic_vector(1 downto 0);          
		sum : OUT std_logic_vector(2 downto 0)
		);
	END COMPONENT;

	
-- SEGNALI IN USCITA AL BLOCCO 7to3
signal tmp_u : std_logic_vector (7 downto 0);
signal tmp_v : std_logic_vector (8 downto 0);
signal tmp_w : std_logic_vector (9 downto 0);

-- SEGNALI IN USCITA AL BLOCCO 3to2
signal tmp_t : std_logic_vector (7 downto 0);
signal tmp_cs : std_logic_vector (7 downto 0);

-- SEGNALE IN INGRESSO AL BLOCCO rca
signal tmp_x : std_logic_vector(7 downto 0);

-- SEGNALI IN USCITA AL BLOCCO rca
signal tmp_rca_cout : std_logic;
signal tmp_rca_sum : std_logic_vector(7 downto 0);

-- SEGNALI IN INGRESSO AL BLOCCO somma_carry
signal tmp_somma_carry_u : std_logic_vector(1 downto 0);
signal tmp_somma_carry_w : std_logic_vector(1 downto 0);

-- SEGNALE IN USCITA AL BLOCCO somma_carry
signal tmp_somma_carry_sum : std_logic_vector(2 downto 0);

begin

tmp_x <= '0' & tmp_t(7 downto 1);

Inst_stored_carry_encoder_7to3: stored_carry_encoder_7to3 PORT MAP(
		in_0 => in0,
		in_1 => in1,
		in_2 => in2,
		in_3 => in3,
		in_4 => in4,
		in_5 => in5,
		in_6 => in6,
		u => tmp_u,
		v => tmp_v,
		w => tmp_w
	);

	Inst_stored_carry_encoder_3to2: stored_carry_encoder_3to2 PORT MAP(
		u => tmp_u,
		v => tmp_v(7 downto 0),
		w => tmp_w(7 downto 0),
		t => tmp_t,
		cs => tmp_cs
	);

	Inst_ripple_carry_adder: ripple_carry_adder 
	GENERIC MAP(8)
	PORT MAP(
		x => tmp_x,
		y => tmp_cs,
		carry_in => '0',
		carry_out => tmp_rca_cout,
		sum => tmp_rca_sum
	);
	
	tmp_somma_carry_u <= tmp_rca_cout & tmp_rca_sum(7);
	tmp_somma_carry_w <= tmp_w(9) & tmp_w(8);
	
	Inst_carry_sum: carry_sum PORT MAP(
		u => tmp_somma_carry_u,
		v => tmp_v(8),
		w => tmp_somma_carry_w,
		sum => tmp_somma_carry_sum
	);



sum <= tmp_somma_carry_sum & tmp_rca_sum(6 downto 0) & tmp_t(0);

end Behavioral;

