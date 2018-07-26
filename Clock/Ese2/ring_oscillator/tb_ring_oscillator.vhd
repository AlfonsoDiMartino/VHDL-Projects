LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY tb_ring_oscillator IS
END tb_ring_oscillator;
 
ARCHITECTURE behavior OF tb_ring_oscillator IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ring_oscillator
    PORT(
         en : IN  std_logic;
         osc : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal en : std_logic := '0';

 	--Outputs
   signal osc : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   --constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ring_oscillator PORT MAP (
          en => en,
          osc => osc
        );


 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      --wait for 100 ns;	


      -- insert stimulus here 
		en <= '1' after 5 ns;
      wait;
   end process;

END;
