library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity inverter_chain is
		generic (N : natural := 25;
					delay : time := 100 ps);
    Port ( i : in  STD_LOGIC;
           o : out  STD_LOGIC);
end inverter_chain;

architecture Structural of inverter_chain is

COMPONENT invert
	generic (delay : time);
	PORT(
		i : IN std_logic;          
		inv_o : OUT std_logic
		);
	END COMPONENT;
signal chain_sig : std_logic_vector (N downto 0);	

begin

chain_sig(0) <=i;
o <= chain_sig(N);

chain_for: for j in 0 to N-1 generate

	inverter_inst: invert GENERIC MAP (delay)
		PORT MAP(
		i => chain_sig(j) ,
		inv_o => chain_sig(j+1)
	);
	
end generate;

end Structural;

