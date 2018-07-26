LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
  
ENTITY tb_ese_2 IS
END tb_ese_2;
 
ARCHITECTURE behavior OF tb_ese_2 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT esercizio_2
    PORT(
         start : IN  std_logic;
         reset_n : IN  std_logic;
         output : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal start : std_logic := '0';
   signal reset_n : std_logic := '0';

 	--Outputs
   signal output : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   --constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: esercizio_2 PORT MAP (
          start => start,
          reset_n => reset_n,
          output => output
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
     wait for 100 ns;	

	start <= '1';
	reset_n <= '1';
      -- insert stimulus here 

      wait;
   end process;

END;
