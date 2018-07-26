library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ffJK is
	 Generic (rs_clk_delay : time := 10 ns;
				  gate_delay : time := 10 ns);
    Port ( CLK : in  STD_LOGIC;
           J : in  STD_LOGIC;
           K : in  STD_LOGIC;
           Preset : in  STD_LOGIC;
           Clear : in  STD_LOGIC;
           Qo : out  STD_LOGIC;
           Qno : out  STD_LOGIC);
end ffJK;

architecture Structural of ffJK is

COMPONENT RS_Clocked_Preset
	GENERIC (gate_delay : time := 10 ns);
	PORT(
		CLK : IN std_logic;
		Preset : IN std_logic;
		Clear : IN std_logic;
		S : IN std_logic;
		R : IN std_logic;          
		Q : OUT std_logic;
		Qn : OUT std_logic
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

signal tmp_R, tmp_S : std_logic := '0';
signal tmp_Q, tmp_Qn : std_logic := '0';
	
begin

Qo <= tmp_Q;
Qno <= tmp_Qn;

	G1 : myAND 
	GENERIC MAP(delay => gate_delay)
	PORT MAP(
			input_A => J,
			input_B => tmp_Qn,
			output => tmp_S
		);	

	G2 : myAND 
	GENERIC MAP(delay => gate_delay)
	PORT MAP(
			input_A => K,
			input_B => tmp_Q,
			output => tmp_R
		);	

	
	RS_CLK_PRESET : RS_Clocked_Preset 
	GENERIC MAP(gate_delay => rs_clk_delay)
	PORT MAP(
		CLK => CLK,
		Preset => Preset,
		Clear => Clear,
		S => tmp_S,
		R => tmp_R,
		Q => tmp_Q,
		Qn => tmp_Qn 
	);
	

end Structural;

