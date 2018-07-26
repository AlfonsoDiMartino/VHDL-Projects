
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity M2_matrix is
	port(
			x : in std_logic_vector(11 downto 0);
			y : in std_logic_vector(11 downto 0);
			z : in std_logic;
			u : out std_logic_vector(11 downto 0);
			v : out std_logic_vector(11 downto 0)
			);
end M2_matrix;

architecture Behavioral of M2_matrix is

COMPONENT half_adder
	PORT(
		add_1 : IN std_logic;
		add_2 : IN std_logic;          
		carry : OUT std_logic;
		sum : OUT std_logic
		);
	END COMPONENT;
	
COMPONENT full_adder
	PORT(
		add_1 : IN std_logic;
		add_2 : IN std_logic;
		carry_in : IN std_logic;          
		carry_out : OUT std_logic;
		sum : OUT std_logic
		);
	END COMPONENT;

signal tmp_u, tmp_v : std_logic_vector(11 downto 0) := (others => '0');
	
begin

u <= tmp_u;
v <= tmp_v;

C_1: half_adder PORT MAP(
		add_1 => x(0),
		add_2 => y(0),
		carry => tmp_v(0),
		sum => tmp_u(0)
	);

C_2: half_adder PORT MAP(
		add_1 => x(1),
		add_2 => y(1),
		carry => tmp_v(1),
		sum => tmp_u(1)
	);
	
C_3: half_adder PORT MAP(
		add_1 => x(2),
		add_2 => y(2),
		carry => tmp_v(2),
		sum => tmp_u(2)
	);
	
C_4: half_adder PORT MAP(
		add_1 => x(3),
		add_2 => y(3),
		carry => tmp_v(3),
		sum => tmp_u(3)
	);
	
C_5: half_adder PORT MAP(
		add_1 => x(4),
		add_2 => y(4),
		carry => tmp_v(4),
		sum => tmp_u(4)
	);
	
C_6: half_adder PORT MAP(
		add_1 => x(5),
		add_2 => y(5),
		carry => tmp_v(5),
		sum => tmp_u(5)
	);

C_7: half_adder PORT MAP(
		add_1 => x(6),
		add_2 => y(6),
		carry => tmp_v(6),
		sum => tmp_u(6)
	);

C_8: half_adder PORT MAP(
		add_1 => x(7),
		add_2 => y(7),
		carry => tmp_v(7),
		sum => tmp_u(7)
	);
	
C_9: half_adder PORT MAP(
		add_1 => x(8),
		add_2 => y(8),
		carry => tmp_v(8),
		sum => tmp_u(8)
	);
	
C_10: full_adder PORT MAP(
		add_1 => x(9),
		add_2 => y(9),
		carry_in => z,
		carry_out => tmp_v(9),
		sum => tmp_u(9)
	);
	
C_11: half_adder PORT MAP(
		add_1 => x(10),
		add_2 => y(10),
		carry => tmp_v(10),
		sum => tmp_u(10)
	);
	
C_12: half_adder PORT MAP(
		add_1 => x(11),
		add_2 => y(11),
		carry => tmp_v(11),
		sum => tmp_u(11)
	);
	
end Behavioral;

