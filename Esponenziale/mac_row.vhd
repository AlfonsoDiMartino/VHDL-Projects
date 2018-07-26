library ieee;
use ieee.std_logic_1164.all;

entity mac_row is
	generic (nbit : natural := 4);
	port (	x		: in std_logic_vector (nbit-1 downto 0);
			y 		: in std_logic;
			sumin	: in std_logic_vector (nbit-1 downto 0);
			sumout	: out std_logic_vector (nbit-1 downto 0);
			cout	: out std_logic
	);
end mac_row;

architecture structural of mac_row is
	component mac_cell
		port (	x 		: in std_logic;
				y		: in std_logic;
				sin		: in std_logic;
				cin		: in std_logic;
				sout	: out std_logic;
				cout	: out std_logic
		);
	end component;
	
	signal carry : std_logic_vector (nbit downto 0) := (others => '0');
	
begin

	row :	for i in 0 to nbit-1 generate
			cell :	mac_cell 
				port map (
					x		=>	x(i),
					y		=>	y,
					sin		=>	sumin(i),
					cin		=>	carry(i),
					sout	=>	sumout(i),
					cout	=>	carry(i+1)
				);
		end generate;
	
	carry(0) <= '0';
	cout <= carry(nbit);
	
end structural;

