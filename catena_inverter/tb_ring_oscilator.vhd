--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:50:21 10/30/2015
-- Design Name:   
-- Module Name:   E:/ring_oscillator/tb_ring_oscilator.vhd
-- Project Name:  ring_oscillator
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ring_oscilator
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_ring_oscilator IS
END tb_ring_oscilator;
 
ARCHITECTURE behavior OF tb_ring_oscilator IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ring_oscilator
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
   uut: ring_oscilator PORT MAP (
          en => en,
          osc => osc
        );


 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	


      -- insert stimulus here 
		en <= '1' after 10 ns, '0' after 50 ns;
      wait;
   end process;

END;
