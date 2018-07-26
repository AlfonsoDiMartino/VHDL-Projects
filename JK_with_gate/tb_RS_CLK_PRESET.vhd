LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY tb_RS_CLK_PRESET IS
END tb_RS_CLK_PRESET;
 
ARCHITECTURE behavior OF tb_RS_CLK_PRESET IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT RS_Clocked_Preset
	 GENERIC (gate_delay : time := 10 ns);	
    PORT(
         CLK : IN  std_logic;
         Preset : IN  std_logic;
         Clear : IN  std_logic;
         S : IN  std_logic;
         R : IN  std_logic;
         Q : OUT  std_logic;
         Qn : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal Preset : std_logic := '0';
   signal Clear : std_logic := '0';
   signal S : std_logic := '0';
   signal R : std_logic := '0';

 	--Outputs
   signal Q : std_logic;
   signal Qn : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RS_Clocked_Preset 
		GENERIC MAP(gate_delay => 10 ns)
		PORT MAP (
          CLK => CLK,
          Preset => Preset,
          Clear => Clear,
          S => S,
          R => R,
          Q => Q,
          Qn => Qn
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

      -- insert stimulus here 
		
		Preset <= '1' , '0' after 15 ns;
		Clear <= '0';
		
		S <= '0';
		R <= '0', '1' after 50 ns, '0' after 70 ns;
		
      wait;
   end process;

END;
