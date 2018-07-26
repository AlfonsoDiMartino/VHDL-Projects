--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:26:44 12/21/2015
-- Design Name:   
-- Module Name:   /home/ssaa/Dropbox/Universita/magistrale/ASE/progettiISE/simple_spi_slave/tb_sck_filter.vhd
-- Project Name:  simple_spi_slave
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: sck_filter
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
 
ENTITY tb_sck_filter IS
END tb_sck_filter;
 
ARCHITECTURE behavior OF tb_sck_filter IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT sck_filter
    PORT(
         clock : IN  std_logic;
         reset_n : IN  std_logic;
         en_in : IN  std_logic;
         en_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clock : std_logic := '0';
   signal reset_n : std_logic := '0';
   signal en_in : std_logic := '0';

 	--Outputs
   signal en_out : std_logic;

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: sck_filter PORT MAP (
          clock => clock,
          reset_n => reset_n,
          en_in => en_in,
          en_out => en_out
        );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		reset_n <= '1';
		en_in <= '1', '0' after 20* clock_period, '1' after 35*clock_period, '0' after 50*clock_period;
      -- insert stimulus here 

      wait;
   end process;

END;
