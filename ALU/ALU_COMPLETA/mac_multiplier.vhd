library ieee;
use ieee.std_logic_1164.all;

entity mac_multiplier is
	generic (
		N : integer := 8
	);
	port (	
		x		: in std_logic_vector(N-1 downto 0);
		y		: in std_logic_vector(N-1 downto 0);
		prod	: out std_logic_vector ((2*N)-1 downto 0)
	);
end mac_multiplier;

architecture structural of mac_multiplier is

	component mac_row
		generic (N : natural := 4);
		port (	x		: in std_logic_vector (N-1 downto 0);
				y 		: in std_logic;
				sumin	: in std_logic_vector (N-1 downto 0);
				sumout	: out std_logic_vector (N-1 downto 0);
				cout	: out std_logic
		);
	end component;
	
	type sgn_mtx is array(0 to N) of std_logic_vector(N downto 0);
	signal intermediate : sgn_mtx;
	
begin
	intermediate(0) <= (intermediate(0)'range => '0');
	
	row_array :	for i in 0 to N-1 generate
		row : mac_row
				generic map (N => N)
				port map (	
					x 		=>	 x,
					y 		=>	 y(i),
					sumin 	=>	 intermediate(i)(N downto 1),
					sumout 	=>	 intermediate(i+1)(N-1 downto 0),
					cout 	=>	 intermediate(i+1)(N)
				);
		prod(i) <= intermediate(i+1)(0);
	end generate;
	
	prod((2*N)-1 downto N-1) <= intermediate(N)(N downto 0);
	
end structural;

