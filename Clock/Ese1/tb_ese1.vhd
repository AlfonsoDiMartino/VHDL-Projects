
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 

 
ENTITY tb_ese1 IS
END tb_ese1;
 
ARCHITECTURE behavior OF tb_ese1 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ese1
    PORT(
         output : OUT  std_logic
        );
    END COMPONENT;
    

 	--Outputs
   signal output : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
--   constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ese1 PORT MAP (
          output => output
        );


 

   -- Stimulus process
   stim_proc: process
   begin		
     

      wait;
   end process;

END;
