--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:47:48 11/22/2015
-- Design Name:   
-- Module Name:   C:/Users/Pietro/Desktop/ISE_MyProjects/SKIP_ADDER/tb_skip_adder.vhd
-- Project Name:  SKIP_ADDER
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: carry_skip_adder
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
 
ENTITY tb_skip_adder IS
END tb_skip_adder;
 
ARCHITECTURE behavior OF tb_skip_adder IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT carry_skip_adder
    PORT(
         X : IN  std_logic_vector(7 downto 0);
         Y : IN  std_logic_vector(7 downto 0);
         carry_in : IN  std_logic;
         carry_out : OUT  std_logic;
         sum : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal X : std_logic_vector(7 downto 0) := (others => '0');
   signal Y : std_logic_vector(7 downto 0) := (others => '0');
   signal carry_in : std_logic := '0';

 	--Outputs
   signal carry_out : std_logic;
   signal sum : std_logic_vector(7 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: carry_skip_adder PORT MAP (
          X => X,
          Y => Y,
          carry_in => carry_in,
          carry_out => carry_out,
          sum => sum
        );

   

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;
		--TEST 1 no overflow no
		X <="00001011";
		Y <="01011001";
		wait for 10 ns;
		assert (sum="01100100" and carry_out='0') report "Error1!" severity error;
		wait for 20 ns;
		
		--TEST 2 overflow si
		X <="11001011";
		Y <="10111001";
		wait for 10 ns;
		assert (sum="10000100" and carry_out='1') report "Error2!" severity error;
		wait for 20 ns;
		
      --TEST 3 massimo valore
		X <="11111111";
		Y <="11111111";
		wait for 10 ns;
		assert (sum="11111110" and carry_out='1' and carry_out='1') report "Error3!" severity error;
		wait for 20 ns;
		
		--TEST 4 massimo e minimo
		X <="11111111";
		Y <="00000000";
		wait for 10 ns;
		assert (sum="11111111" and carry_out='0') report "Error4!" severity error;
		wait for 20 ns;
		
		--TEST 5 massimo e minimo piu carry_in alto
		carry_in <='1';
		X <="11111111";
		Y <="00000000";
		wait for 10 ns;
		assert (sum="00000000" and carry_out='1') report "Error5!" severity error;
		wait for 20 ns;
		
		

      wait;
   end process;

END;
