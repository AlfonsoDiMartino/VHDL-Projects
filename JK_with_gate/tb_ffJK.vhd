LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY tb_ffJK IS
END tb_ffJK;
 
ARCHITECTURE behavior OF tb_ffJK IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ffJK
	 GENERIC (rs_clk_delay : time := 10 ns;
				  gate_delay : time := 10 ns);
    PORT(
         CLK : IN  std_logic;
         J : IN  std_logic;
         K : IN  std_logic;
         Preset : IN  std_logic;
         Clear : IN  std_logic;
         Qo : OUT  std_logic;
         Qno : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal J : std_logic := '0';
   signal K : std_logic := '0';
   signal Preset : std_logic := '0';
   signal Clear : std_logic := '0';

 	--Outputs
   signal Qo : std_logic;
   signal Qno : std_logic;

   -- Clock period definitions
  -- constant CLK_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ffJK 
		GENERIC MAP (	rs_clk_delay => 10 ns,
							gate_delay => 10 ns)
		PORT MAP (
          CLK => CLK,
          J => J,
          K => K,
          Preset => Preset,
          Clear => Clear,
          Qo => Qo,
          Qno => Qno
        );

   -- Clock process definitions
--   CLK_process :process
--   begin
--		CLK <= '0';
--		wait for CLK_period/2;
--		CLK <= '1';
--		wait for CLK_period/2;
--   end process;
-- 

   -- Stimulus process
   stim_proc: process
   begin		
      -- STIMULUS PAR
--     Preset <= '1', '0' after 5 ns;
--	  Clear 	<= '0';
--	  CLK 	<='1' , '0' after 75 ns;
--	J <= '0', '1' after 10 ns, '0' after 20 ns,'1' after 35 ns,'0' after 70 ns, '1' after 80 ns, '0' after 90 ns, '1' after 105 ns, '0' after 140 ns;
--	K <= '0', '1' after 25 ns, '0' after 70 ns, '1' after 95 ns, '0' after 140 ns;
--		
	-- STIMULUS BEHAVIORAL
	CLK 	<= '0', '1' AFTER 20 NS, '0' after 400 ns;
	PRESET 	<= '1' , '0' AFTER 15 NS;
	CLEAR		<= '0'; 
	J <= '0' , '1' AFTER 110 NS, '0' AFTER 160 NS, '1' AFTER 200 NS, '0' AFTER 300 NS, '1' AFTER 340 NS, '0' AFTER 410 NS, '1' AFTER 450 NS;
	k <= '0' , '1' AFTER 30 NS, '0' AFTER 80 NS, '1' AFTER 200 NS, '0' AFTER 300 NS, '1' AFTER 410 NS	;
      wait;
   end process;

END;
