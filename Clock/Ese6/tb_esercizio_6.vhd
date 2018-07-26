LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY tb_esercizio_6 IS
END tb_esercizio_6;
 
ARCHITECTURE behavior OF tb_esercizio_6 IS 
 
 
    COMPONENT esercizio_6
    PORT(
         Clock_in : IN  std_logic;
         Clock0 : OUT  std_logic;
         Clock1 : OUT  std_logic;
         Clock2 : OUT  std_logic;
         Clock3 : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Clock_in : std_logic := '0';

 	--Outputs
   signal Clock0 : std_logic;
   signal Clock1 : std_logic;
   signal Clock2 : std_logic;
   signal Clock3 : std_logic;

   -- Clock period definitions
   constant Clock_in_period : time := 10 ns;
   
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: esercizio_6 PORT MAP (
          Clock_in => Clock_in,
          Clock0 => Clock0,
          Clock1 => Clock1,
          Clock2 => Clock2,
          Clock3 => Clock3
        );

   -- Clock process definitions
   Clock_in_process :process
   begin
		Clock_in <= '0';
		wait for Clock_in_period/2;
		Clock_in <= '1';
		wait for Clock_in_period/2;
   end process;
 
  
 

   -- Stimulus process
   stim_proc: process
   begin		
    

      wait;
   end process;

END;
