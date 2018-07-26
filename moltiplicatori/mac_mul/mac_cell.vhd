library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mac_cell is
	port (	x: in std_logic;
		y: in std_logic;
		sin : in std_logic;
		cin : in std_logic;
		sout : out std_logic;
		cout : out std_logic);
end mac_cell;

architecture structural of mac_cell is
	component full_adder
		port (	add_1 : in  STD_LOGIC;
			add_2 : in  STD_LOGIC;
			carry_in : in  STD_LOGIC;
			carry_out : out  STD_LOGIC;
			sum : out  STD_LOGIC);
	end component;
	signal p : std_logic;
begin
	p <= x and y;
	adder : full_adder
		port map (p, sin, cin, cout, sout);
end structural;

