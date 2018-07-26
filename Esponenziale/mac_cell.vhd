library ieee;
use ieee.std_logic_1164.all;

entity mac_cell is
	port (	x 		: in std_logic;
			y		: in std_logic;
			sin		: in std_logic;
			cin		: in std_logic;
			sout	: out std_logic;
			cout	: out std_logic
	);
end mac_cell;

architecture structural of mac_cell is

	component full_adder
		port (	add_1		: in std_logic;
				add_2		: in std_logic;
				carry_in	: in std_logic;
				carry_out	: out std_logic;
				sum			: out std_logic
		);
	end component;
	
	signal p : std_logic;
	
begin
	p <= x and y;
	adder : full_adder
		port map (
			add_1		=>	p,
			add_2		=>	sin,
			carry_in	=>	cin,
			carry_out	=>	cout,
			sum			=>	sout
		);
end structural;

