LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY tb_ffT IS
END tb_ffT;
 
ARCHITECTURE behavior OF tb_ffT IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ffT
--	 Generic( rs_clk_delay : time := 10 ns;
--				  gate_delay : time := 10 ns);
    PORT(
         CLK : IN  std_logic;
         Preset : IN  std_logic;
         Clear : IN  std_logic;
         T : IN  std_logic;
         Q : OUT  std_logic;
         Qn : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal Preset : std_logic := '0';
   signal Clear : std_logic := '0';
   signal T : std_logic := '0';

 	--Outputs
   signal Q : std_logic;
   signal Qn : std_logic;

   -- Clock period definitions
--   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ffT 
--		GENERIC MAP (rs_clk_delay => 10 ns, gate_delay => 10 ns)
		PORT MAP (
          CLK => CLK,
          Preset => Preset,
          Clear => Clear,
          T => T,
          Q => Q,
          Qn => Qn
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
		T 			<= '0' , '1' AFTER 15 NS;
		CLK		<= '0' , '1' AFTER 20 NS;
		PRESET	<= '1' , '0' AFTER 5 NS;
		CLEAR		<= '0';
     
      -- STIMULUS BEHAVIORAL
--		CLK 	<= '0' , '1' AFTER 20 NS;
--		PRESET <= '1' , '0' AFTER 15 NS;
--	  
--		T		<= '0' , '1' AFTER 50 NS, '0' AFTER 150 NS;
      wait;
   end process;

END;
