--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:30:30 11/12/2015
-- Design Name:   
-- Module Name:   /home/ssaa/Dropbox/Universita/magistrale/ASE/progettiISE/mac_multiplier/tb_mac_multiplier.vhd
-- Project Name:  mac_multiplier
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: mac_multiplier
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
Use ieee.numeric_std.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_mac_multiplier IS
END tb_mac_multiplier;
 
ARCHITECTURE behavior OF tb_mac_multiplier IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT mac_multiplier
    PORT(
         x : IN  std_logic_vector(3 downto 0);
         y : IN  std_logic_vector(3 downto 0);
         prod : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal x : std_logic_vector(3 downto 0) := (others => '0');
   signal y : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal prod : std_logic_vector(7 downto 0);

BEGIN
	-- Instantiate the Unit Under Test (UUT)
   uut: mac_multiplier PORT MAP (
          x => x,
          y => y,
          prod => prod
        );

   -- Stimulus process
   stim_proc: process
		variable tmp : integer;
		variable error_count : integer := 0;
   begin		
      -- hold reset state for 10 ns.
      wait for 10 ns;	
      -- insert stimulus here 
      
      
      for i in 0 to 15 loop
			x <= std_logic_vector(to_unsigned(i, x'length));
			for j in 0 to 15 loop
				tmp := i * j;
				y <= std_logic_vector(to_unsigned(j, y'length));
				wait for 5 ns;
				assert (prod = std_logic_vector(to_unsigned(tmp, prod'length)))
					report	"Errore nel test ciclico  con i=" & integer'image(i)
							& " j=" & integer'image(j)
							& " tmp=" & integer'image(tmp)
					severity error;
				if prod /= std_logic_vector(to_unsigned(tmp, prod'length)) then
					error_count := error_count + 1;
				end if;
			end loop;
		end loop;
		
		assert (1 = 2)
		report "Si sono verificati " & integer'image(error_count) & " errori durante il test";
      
	  
	  -- caso 1: 3 * 1 = 3
	  x <= x"3";
	  y <= x"1";
	  wait for 25 ns;
	  assert (prod = x"03") report "Errore al test case 1" severity error;
	  wait for 25 ns;
	  
	  
	  -- caso 2: 3 * 3 = 9
	  x <= x"3";
	  y <= x"3";
	  wait for 25 ns;
	  assert (prod = x"09") report "Errore al test case 2" severity error;
	  wait for 25 ns;
	  
	  -- caso 3: 3 * 8 = 24 = x18
	  x <= x"3";
	  y <= x"8";
	  wait for 25 ns;
	  assert (prod = x"18") report "Errore al test case 3" severity error;
	  wait for 25 ns;
	  
	  -- caso 4: 8 * 3 = 24
	  x <= x"8";
	  y <= x"3";
	  wait for 25 ns;
	  assert (prod = x"18") report "Errore al test case 4" severity error;
	  wait for 25 ns;
	  
	  -- caso 5: 7 * 7 = 49 = 0x31
	  x <= x"7";
	  y <= x"7";
	  wait for 25 ns;
	  assert (prod = x"31") report "Errore al test case 5" severity error;
	  wait for 25 ns;
	  
	  -- caso 6: 15 * 15 = 225 = 0xE1
	  x <= x"F";
	  y <= x"F";
	  wait for 25 ns;
	  assert (prod = x"E1") report "Errore al test case 6" severity error;
	  wait for 25 ns;
	  
	  -- caso 7: 3 * 0 = 0
	  x <= x"3";
	  y <= x"0";
	  wait for 25 ns;
	  assert (prod = x"00") report "Errore al test case 7" severity error;
	  wait for 25 ns;
	  
	  -- caso 8: 0 * 3 = 0
	  x <= x"0";
	  y <= x"3";
	  wait for 25 ns;
	  assert (prod = x"00") report "Errore al test case 8" severity error;
	  wait for 25 ns;
	  
	  -- caso 9: 0 * 0 = 0
	  x <= x"0";
	  y <= x"0";
	  wait for 25 ns;
	  assert (prod = x"00") report "Errore al test case 9" severity error;
	  wait for 25 ns;
	  
	  
	  -- caso 10: 10 * 5 = 50 = 0x32
	  x <= x"A";
	  y <= x"5";
	  wait for 25 ns;
	  assert (prod = x"32") report "Errore al test case 10" severity error;
	  wait for 25 ns;
	  
	  
	  

      wait;
   end process;

END;
