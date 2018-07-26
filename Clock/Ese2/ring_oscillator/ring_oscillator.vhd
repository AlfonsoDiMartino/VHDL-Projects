library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ring_oscillator is
    Port ( en : in  STD_LOGIC;
           osc : out  STD_LOGIC);
end ring_oscillator;

architecture Behavioral of ring_oscillator is


COMPONENT inverter_chain
	GENERIC(N : natural; delay : time);
	PORT(
		i : IN std_logic;          
		o : OUT std_logic
		);
	END COMPONENT;
	
COMPONENT nand_gate
	GENERIC(delay : time);
	PORT(
		in_1 : IN std_logic;
		in_2 : IN std_logic;          
		o : OUT std_logic
		);
	END COMPONENT;

constant ritardo_nand : time := 300 ps;
constant ritardo_inverter : time := 100 ps;
constant numero_inverter : natural := 22;

signal input_chain, output_chain : std_logic := '0';

begin
	
	osc <= output_chain;
	
inv_chain_inst: inverter_chain 
	GENERIC MAP (numero_inverter,ritardo_inverter)
	PORT MAP (
		i => input_chain,
		o => output_chain
	);

Inst_nand_gate: nand_gate 
	GENERIC MAP(ritardo_nand)
	PORT MAP(
		in_1 => en,
		in_2 => output_chain,
		o => input_chain
	);
			
				
end Behavioral;

