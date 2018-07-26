LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY tb_esercizio_3 IS
END tb_esercizio_3;
 
ARCHITECTURE behavior OF tb_esercizio_3 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT esercizio_3
    PORT(
         clk_base : OUT  std_logic;
         forma_clk : OUT  std_logic
        );
    END COMPONENT;
    

 	--Outputs
   signal clk_base : std_logic;
   signal forma_clk : std_logic;

   -- Clock period definitions

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: esercizio_3 PORT MAP (
          clk_base => clk_base,
          forma_clk => forma_clk
        );

   -- Clock process definitions
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
--      wait for 100 ns;	

--      wait for clk_base_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
