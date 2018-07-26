library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ripple_carry_adder is
	generic ( N : natural := 8);
    Port ( x : in  STD_LOGIC_VECTOR (N-1 downto 0);
           y : in  STD_LOGIC_VECTOR (N-1 downto 0);
           carry_in : in  STD_LOGIC;
           carry_out : out  STD_LOGIC;
           sum : out  STD_LOGIC_VECTOR (N-1 downto 0)
			  );
end ripple_carry_adder;

architecture structural of ripple_carry_adder is

	component full_adder 
		Port ( add_1 : in  STD_LOGIC;
			   add_2 : in  STD_LOGIC;
			   carry_in : in  STD_LOGIC;
			   carry_out : out  STD_LOGIC;
				  sum : out  STD_LOGIC
				 );
	end component full_adder;

	signal tmp_carry : std_logic_vector (N downto 0) := (others => '0');

begin

	tmp_carry(0) <= carry_in;
	carry_out <= tmp_carry(N);

	full_adder_waterfall : for i in N-1 downto 0 generate
		full_adder_inst : full_adder
			port map(
						add_1 => x(i),
						add_2 => y(i),
						carry_in => tmp_carry(i),
						carry_out => tmp_carry(i+1),
						sum => sum(i)
						);					
	end generate;

end structural;
