library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ffT is
	 Generic( rs_clk_delay : time := 10 ns;
				  gate_delay : time := 10 ns);
    Port ( CLK : in  STD_LOGIC;
           Preset : in  STD_LOGIC;
           Clear : in  STD_LOGIC;
           T : in  STD_LOGIC;
           Q : out  STD_LOGIC;
           Qn : out  STD_LOGIC);
end ffT;

architecture Structural of ffT is

COMPONENT ffJK
	GENERIC (rs_clk_delay : time := 10 ns;
				gate_delay : time := 10 ns);
	PORT(
		CLK : IN std_logic;
		J : IN std_logic;
		K : IN std_logic;
		Preset : IN std_logic;
		Clear : IN std_logic;          
		Qo : OUT std_logic;
		Qno : OUT std_logic
		);
	END COMPONENT;

begin

	JK : ffJK 
	GENERIC MAP (
		rs_clk_delay => 10 ns,gate_delay => 10 ns)
	PORT MAP(
		CLK => CLK,
		J => T,
		K => T,
		Preset => Preset,
		Clear => Clear,
		Qo => Q,
		Qno => Qn
	);

end Structural;

