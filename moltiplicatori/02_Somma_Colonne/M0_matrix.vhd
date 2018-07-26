library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity M0_matrix is
	port(
			p_m : in std_logic_vector(63 downto 1);	-- matrice dei prodotti parziali
			u : out std_logic_vector(13 downto 0);		-- in M1 devo ricordare : u <= u(N-1 downto 1) , mentre u(0) è p1
			v : out std_logic_vector(12 downto 0);		-- carry_1
			w : out std_logic_vector(8 downto 0);		-- carry_2
			t : out std_logic									-- carry_3
		);
end M0_matrix;


architecture Behavioral of M0_matrix is

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

COMPONENT parallel_counter_5
	PORT(
		X : IN std_logic_vector(4 downto 0);          
		C0 : OUT std_logic;
		C1 : OUT std_logic;
		C2 : OUT std_logic
		);
	END COMPONENT;

COMPONENT parallel_counter_6
	PORT(
		X : IN std_logic_vector(5 downto 0);          
		C0 : OUT std_logic;
		C1 : OUT std_logic;
		C2 : OUT std_logic
		);
	END COMPONENT;
	
COMPONENT parallel_counter_7
	PORT(
		X : IN std_logic_vector(6 downto 0);          
		C0 : OUT std_logic;
		C1 : OUT std_logic;
		C2 : OUT std_logic
		);
	END COMPONENT;
	
COMPONENT parallel_counter_8
	PORT(
		X : IN std_logic_vector(7 downto 0);          
		C0 : OUT std_logic;
		C1 : OUT std_logic;
		C2 : OUT std_logic;
		C3 : OUT std_logic
		);
	END COMPONENT;
	
signal tmp_in_c_3, tmp_in_c_11 : std_logic_vector(3 downto 0) := (others => '0');
signal tmp_in_c_4, tmp_in_c_10 : std_logic_vector(4 downto 0) := (others => '0');
signal tmp_in_c_5, tmp_in_c_9 : std_logic_vector(5 downto 0) := (others => '0');
signal tmp_in_c_6, tmp_in_c_8 : std_logic_vector(6 downto 0) := (others => '0');
signal tmp_in_c_7 : std_logic_vector(7 downto 0) := (others => '0');
	
begin

tmp_in_c_3 <= p_m(3)&p_m(10)&p_m(17)&p_m(24);
tmp_in_c_4 <= p_m(4)&p_m(11)&p_m(18)&p_m(25)&p_m(32);
tmp_in_c_5 <= p_m(5)&p_m(12)&p_m(19)&p_m(26)&p_m(33)&p_m(40);
tmp_in_c_6 <= p_m(6)&p_m(13)&p_m(20)&p_m(27)&p_m(34)&p_m(41)&p_m(48);
tmp_in_c_7 <= p_m(7)&p_m(14)&p_m(21)&p_m(28)&p_m(35)&p_m(42)&p_m(49)&p_m(56);
tmp_in_c_8 <= p_m(15)&p_m(22)&p_m(29)&p_m(36)&p_m(43)&p_m(50)&p_m(57);
tmp_in_c_9 <= p_m(23)&p_m(30)&p_m(37)&p_m(44)&p_m(51)&p_m(58);
tmp_in_c_10 <= p_m(31)&p_m(38)&p_m(45)&p_m(52)&p_m(59);
tmp_in_c_11 <= p_m(39)&p_m(46)&p_m(53)&p_m(60);

u(13) <= p_m(63);

C_1: half_adder PORT MAP(
		add_1 => p_m(1),
		add_2 => p_m(8),
		carry => v(0),
		sum => u(0)
	);


C_2: full_adder PORT MAP(
		add_1 => p_m(2),
		add_2 => p_m(9),
		carry_in => p_m(16),
		carry_out => v(1),
		sum => u(1)
	);
	
C_3: parallel_counter_4 PORT MAP(
		X => tmp_in_c_3,
		C0 => u(2),
		C1 => v(2),
		C2 => w(0)
	);	


C_4: parallel_counter_5 PORT MAP(
		X => tmp_in_c_4,
		C0 => u(3),
		C1 => v(3),
		C2 => w(1)
	);
	
C_5: parallel_counter_6 PORT MAP(
		X => tmp_in_c_5,
		C0 => u(4),
		C1 => v(4),
		C2 => w(2)
	);

C_6: parallel_counter_7 PORT MAP(
		X => tmp_in_c_6,
		C0 => u(5),
		C1 => v(5),
		C2 => w(3)
	);

C_7: parallel_counter_8 PORT MAP(
		X => tmp_in_c_7,
		C0 => u(6),
		C1 => v(6),
		C2 => w(4),
		C3 => t
	);
	
C_8: parallel_counter_7 PORT MAP(
		X => tmp_in_c_8,
		C0 => u(7),
		C1 => v(7),
		C2 => w(5)
	);
	
C_9: parallel_counter_6 PORT MAP(
		X => tmp_in_c_9,
		C0 => u(8),
		C1 => v(8),
		C2 => w(6)
	);

C_10: parallel_counter_5 PORT MAP(
		X => tmp_in_c_10,
		C0 => u(9),
		C1 => v(9),
		C2 => w(7)
	);

C_11: parallel_counter_4 PORT MAP(
		X => tmp_in_c_11,
		C0 => u(10),
		C1 => v(10),
		C2 => w(8)
	);	
	
C_12: full_adder PORT MAP(
		add_1 => p_m(47),
		add_2 => p_m(54),
		carry_in => p_m(61),
		carry_out => v(11),
		sum => u(11)
	);

C_13: half_adder PORT MAP(
		add_1 => p_m(55),
		add_2 => p_m(62),
		carry => v(12),
		sum => u(12)
	);
		
end Behavioral;

