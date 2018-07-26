library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity M1_matrix is
	port(
			x : in std_logic_vector(12 downto 0);
			y : in std_logic_vector(12 downto 0);
			z : in std_logic_vector(8 downto 0);
			k : in std_logic;
			u : out std_logic_vector(12 downto 0);
			v : out std_logic_vector(12 downto 0);
			w : out std_logic
			);
end M1_matrix;


architecture Behavioral of M1_matrix is

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
	
COMPONENT parallel_counter_4
	PORT(
		X : IN std_logic_vector(3 downto 0);          
		C0 : OUT std_logic;
		C1 : OUT std_logic;
		C2 : OUT std_logic
		);
END COMPONENT;
	

signal tmp_u , tmp_v : std_logic_vector(12 downto 0) := (others => '0');
signal tmp_w : std_logic := '0';
signal tmp_in_c_4 : std_logic_vector(3 downto 0) := (others => '0');

begin

tmp_in_c_4 <= x(8)&y(8)&z(5)&k;
u <= tmp_u;
v <= tmp_v;
w <= tmp_w;

HA_1: half_adder PORT MAP(
		add_1 => x(0),
		add_2 => y(0),
		carry => tmp_v(0),
		sum => tmp_u(0)
	);


HA_2: half_adder PORT MAP(
		add_1 => x(1),
		add_2 => y(1),
		carry => tmp_v(1),
		sum => tmp_u(1)
	);
	
HA_3: half_adder PORT MAP(
		add_1 => x(2),
		add_2 => y(2),
		carry => tmp_v(2),
		sum => tmp_u(2)
	);
	
FA_4: full_adder PORT MAP(
		add_1 => x(3),
		add_2 => y(3),
		carry_in => z(0),
		carry_out => tmp_v(3),
		sum => tmp_u(3)
	);
	
FA_5: full_adder PORT MAP(
		add_1 => x(4),
		add_2 => y(4),
		carry_in => z(1),
		carry_out => tmp_v(4),
		sum => tmp_u(4)
	);	
	
FA_6: full_adder PORT MAP(
		add_1 => x(5),
		add_2 => y(5),
		carry_in => z(2),
		carry_out => tmp_v(5),
		sum => tmp_u(5)
	);	
	
FA_7: full_adder PORT MAP(
		add_1 => x(6),
		add_2 => y(6),
		carry_in => z(3),
		carry_out => tmp_v(6),
		sum => tmp_u(6)
	);	
	
FA_8: full_adder PORT MAP(
		add_1 => x(7),
		add_2 => y(7),
		carry_in => z(4),
		carry_out => tmp_v(7),
		sum => tmp_u(7)
	);

C_9: parallel_counter_4 PORT MAP(
		X => tmp_in_c_4,
		C0 => tmp_u(8),
		C1 => tmp_v(8),
		C2 => tmp_w
	);	

FA_10: full_adder PORT MAP(
		add_1 => x(9),
		add_2 => y(9),
		carry_in => z(6),
		carry_out => tmp_v(9),
		sum => tmp_u(9)
	);	
	
FA_11: full_adder PORT MAP(
		add_1 => x(10),
		add_2 => y(10),
		carry_in => z(7),
		carry_out => tmp_v(10),
		sum => tmp_u(10)
	);	
	
FA_12: full_adder PORT MAP(
		add_1 => x(11),
		add_2 => y(11),
		carry_in => z(8),
		carry_out => tmp_v(11),
		sum => tmp_u(11)
	);	
	
HA_13: half_adder PORT MAP(
		add_1 => x(12),
		add_2 => y(12),
		carry => tmp_v(12),
		sum => tmp_u(12)
	);

end Behavioral;

