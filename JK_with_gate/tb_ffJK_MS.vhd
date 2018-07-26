LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
  
ENTITY tb_ffJK_MS IS
END tb_ffJK_MS;
 
ARCHITECTURE behavior OF tb_ffJK_MS IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ffJK_MS
    GENERIC	( rs_clk_delay		: time := 10 ns;
				  gate_delay 		: time := 10 ns;
				  not_gate_delay 	: time := 10 ns
				 );
	 PORT(
         CLK : IN  std_logic;
         Preset : IN  std_logic;
         Clear : IN  std_logic;
         J : IN  std_logic;
         K : IN  std_logic;
         Qo : OUT  std_logic;
         Qno : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal Preset : std_logic := '0';
   signal Clear : std_logic := '0';
   signal J : std_logic := '0';
   signal K : std_logic := '0';

 	--Outputs
   signal Qo : std_logic;
   signal Qno : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 80 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ffJK_MS 
		GENERIC MAP (rs_clk_delay => 10 ns, gate_delay => 10 ns, not_gate_delay => 10 ns)
		PORT MAP (
          CLK => CLK,
          Preset => Preset,
          Clear => Clear,
          J => J,
          K => K,
          Qo => Qo,
          Qno => Qno
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- STIMULUS PAR

      -- STIMULUS BEHAVIORAL
		
		PRESET	<= '1' , '0' AFTER 80 NS;
		CLEAR		<= '0';
		
		J 	<= '0', '1' AFTER 260 NS, '0' AFTER 800 NS;
		K	<= '0' , '1' AFTER 100 NS , '0' AFTER 	240 NS , '1' AFTER 420 NS, '0' AFTER 850 NS;

      wait;
   end process;

END;
