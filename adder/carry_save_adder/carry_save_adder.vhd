library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity carry_save_adder is
	generic (N : natural := 8);
    Port ( X : in  STD_LOGIC_VECTOR (N-1 downto 0);
           Y : in  STD_LOGIC_VECTOR (N-1 downto 0);
           Z : in  STD_LOGIC_VECTOR (N-1 downto 0);
           S : out  STD_LOGIC_VECTOR (N+1 downto 0));
end carry_save_adder;

architecture Structural of carry_save_adder is

component carry_save_logic 
generic(N : natural);
	port( X : in std_logic_vector(N-1 downto 0);
			Y : in std_logic_vector(N-1 downto 0);
			Z : in std_logic_vector(N-1 downto 0);
			CS : out std_logic_vector(N-1 downto 0);
			T : out std_logic_vector(N-1 downto 0)
			);
end component carry_save_logic;

component ripple_carry_adder
	generic(N : natural);
    Port ( x : in  STD_LOGIC_VECTOR (N-1 downto 0);
           y : in  STD_LOGIC_VECTOR (N-1 downto 0);
           carry_in : in  STD_LOGIC;
           carry_out : out  STD_LOGIC;
           sum : out  STD_LOGIC_VECTOR (N-1 downto 0)
			  );
end component ripple_carry_adder;

	
signal tmp_t : std_logic_vector(N downto 0);
signal tmp_cs : std_logic_vector(N-1 downto 0);
signal tmp_somma : std_logic_vector(N+1 downto 0);

begin

CSL_inst : carry_save_logic
	generic map (N=>N)
	port map(
				X => X,
				Y => Y,
				Z => Z,
				CS => tmp_cs,
				T => tmp_t (N-1 downto 0)
				);
				
tmp_somma(0) <= tmp_t(0);
tmp_t(N) <= '0';

RCA : ripple_carry_adder
	generic map (N => N)
	port map(
				X => tmp_cs,
				Y => tmp_t(N downto 1),
				carry_in => '0',
				carry_out => tmp_somma(N+1),
				sum =>tmp_somma (N downto 1)
				);
S <= tmp_somma;
				
end Structural;

