library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ffJK_MS is
	 Generic ( rs_clk_delay : time := 10 ns;
				  gate_delay : time := 10 ns;
				  not_gate_delay : time := 10 ns);
    Port ( CLK : in  STD_LOGIC;
           Preset : in  STD_LOGIC;
           Clear : in  STD_LOGIC;
           J : in  STD_LOGIC;
           K : in  STD_LOGIC;
           Qo : out  STD_LOGIC;
           Qno : out  STD_LOGIC);
end ffJK_MS;

architecture Behavioral of ffJK_MS is

COMPONENT ffJK
	GENERIC (  rs_clk_delay : time := 10 ns;
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

signal not_CLK : std_logic := '0';
signal tmp_Q, tmp_Qn : std_logic := '0';

begin

not_CLK <= not CLK after not_gate_delay;

	Master : ffJK PORT MAP(
		CLK => CLK,
		J => J,
		K => K,
		Preset => Preset,
		Clear => Clear,
		Qo => tmp_Q,
		Qno => tmp_Qn
	);

	Slave : ffJK PORT MAP(
		CLK => not_CLK,
		J => tmp_Q,
		K => tmp_Qn,
		Preset => Preset,
		Clear => Clear,
		Qo => Qo,
		Qno => Qno
	);


end Behavioral;

