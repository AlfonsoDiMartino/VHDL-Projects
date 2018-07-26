library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RS_Clocked_Preset is
	 Generic (gate_delay : time := 10 ns);
    Port ( CLK : in STD_LOGIC;
			  Preset : in  STD_LOGIC;
           Clear : in  STD_LOGIC;
           S : in  STD_LOGIC;
           R : in  STD_LOGIC;
           Q : out  STD_LOGIC;
           Qn : out  STD_LOGIC);
end RS_Clocked_Preset;

architecture Structural of RS_Clocked_Preset is

COMPONENT myNOR3
	GENERIC (delay : time := 10 ns);
	PORT(
		input_A : IN std_logic;
		input_B : IN std_logic;
		input_C : IN std_logic;          
		output : OUT std_logic
		);
	END COMPONENT;

COMPONENT myAND
	GENERIC (delay : time := 10 ns);
	PORT(
		input_A : IN std_logic;
		input_B : IN std_logic;          
		output : OUT std_logic
		);
	END COMPONENT;

signal tmp_Q, tmp_Qn : std_logic := '0';
signal tmp_G1, tmp_G2 : std_logic := '0';

begin

Q	<= tmp_Q;
Qn	<= tmp_Qn;

	G1 : myNOR3 
	GENERIC MAP (delay => gate_delay)
	PORT MAP(
		input_A => Preset,
		input_B => tmp_G1,
		input_C => tmp_Q,
		output => tmp_Qn
	);

	G2 : myNOR3 
	GENERIC MAP (delay => gate_delay)
	PORT MAP(
		input_A => Clear,
		input_B => tmp_G2,
		input_C => tmp_Qn,
		output => tmp_Q
	);

	G3 : myAND 
	GENERIC MAP (delay => gate_delay)
	PORT MAP(
		input_A => CLK,
		input_B => S,
		output => tmp_G1
	);


	G4 : myAND 
	GENERIC MAP (delay => gate_delay)
	PORT MAP(
		input_A => CLK,
		input_B => R,
		output => tmp_G2
	);
	
	
end Structural;

