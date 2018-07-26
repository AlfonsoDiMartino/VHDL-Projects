--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:13:45 01/15/2016
-- Design Name:   
-- Module Name:   /home/pietro/Scrivania/ISE_PROJECT/Divisore_restoring/tb.vhd
-- Project Name:  Divisore_restoring
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: restoring_divider
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
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb IS
END tb;
 
ARCHITECTURE behavior OF tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT restoring_divider
    PORT(
         clock : IN  std_logic;
         reset_n : IN  std_logic;
         start : IN  std_logic;
         div_by_zero : OUT  std_logic;
         done : OUT  std_logic;
         D : IN  std_logic_vector(7 downto 0);
         V : IN  std_logic_vector(7 downto 0);
         Q : OUT  std_logic_vector(7 downto 0);
         R : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clock : std_logic := '0';
   signal reset_n : std_logic := '0';
   signal start : std_logic := '0';
   signal D : std_logic_vector(7 downto 0) := (others => '0');
   signal V : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal div_by_zero : std_logic;
   signal done : std_logic;
   signal Q : std_logic_vector(7 downto 0);
   signal R : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: restoring_divider PORT MAP (
          clock => clock,
          reset_n => reset_n,
          start => start,
          div_by_zero => div_by_zero,
          done => done,
          D => D,
          V => V,
          Q => Q,
          R => R
        );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 

   
	stim_process : process
		variable test_q : integer := 0;
		variable test_q_slv : std_logic_vector(7 downto 0) := (others => '0');
		variable test_r : integer := 0;
		variable test_r_slv : std_logic_vector(7 downto 0) := (others => '0');
		variable err_cnt : integer := 0;
	begin
	
		wait for 50 ns;
		reset_n <= '1';
		wait for 30 ns;
		
		--~ D <= x"06";
		--~ V <= x"02";
		--~ start <= '1', '0' after 2*clock_period;
		
		for i in 0 to 255 loop
			D <= std_logic_vector(to_unsigned(i, 8));
			for j in 0 to 255 loop
				V <= std_logic_vector(to_unsigned(j,8));
				start <= '1', '0' after clock_period;
				wait for 20*clock_period;
				
				if (j /= 0) then
				
					test_q := i / j;
					test_q_slv := std_logic_vector(to_unsigned(test_q, 8));
					test_r := i - (test_q * j);
					test_r_slv := std_logic_vector(to_unsigned(test_r, 8));
					
					assert (Q = test_q_slv)
						report "Errore di calcolo del quoziente con "
								& "dividendo (x) =" & integer'image(i) & " (" 
								& std_logic'image(D(7)) & std_logic'image(D(6)) & std_logic'image(D(5)) & std_logic'image(D(4)) 
								& std_logic'image(D(3)) & std_logic'image(D(2)) & std_logic'image(D(1)) & std_logic'image(D(0))
								& "), divisore (y) =" & integer'image(j) & " (" 
								& std_logic'image(V(7)) & std_logic'image(V(6)) & std_logic'image(V(5)) & std_logic'image(V(4)) 
								& std_logic'image(V(3)) & std_logic'image(V(2)) & std_logic'image(V(1)) & std_logic'image(V(0))
								& "), Q =" 
								& std_logic'image(Q(7)) & std_logic'image(Q(6)) & std_logic'image(Q(5)) & std_logic'image(Q(4)) 
								& std_logic'image(Q(3)) & std_logic'image(Q(2)) & std_logic'image(Q(1)) & std_logic'image(Q(0))
								& ", test_Q ="
								& std_logic'image(test_q_slv(7)) & std_logic'image(test_q_slv(6)) & std_logic'image(test_q_slv(5)) & std_logic'image(test_q_slv(4)) 
								& std_logic'image(test_q_slv(3)) & std_logic'image(test_q_slv(2)) & std_logic'image(test_q_slv(1)) & std_logic'image(test_q_slv(0))
						severity error;
						
					if (Q /= test_q_slv) then
						err_cnt := err_cnt +1;
					end if;
					
					
					assert (R = test_r_slv)
						report "Errore di calcolo del resto con "
								& "dividendo (x) =" & integer'image(i) & " (" 
								& std_logic'image(D(7)) & std_logic'image(D(6)) & std_logic'image(D(5)) & std_logic'image(D(4)) 
								& std_logic'image(D(3)) & std_logic'image(D(2)) & std_logic'image(D(1)) & std_logic'image(D(0))
								& "), divisore (y) =" & integer'image(j) & " (" 
								& std_logic'image(V(7)) & std_logic'image(V(6)) & std_logic'image(V(5)) & std_logic'image(V(4)) 
								& std_logic'image(V(3)) & std_logic'image(V(2)) & std_logic'image(V(1)) & std_logic'image(V(0))
								& "), R =" 
								& std_logic'image(R(7)) & std_logic'image(R(6)) & std_logic'image(R(5)) & std_logic'image(R(4)) 
								& std_logic'image(R(3)) & std_logic'image(R(2)) & std_logic'image(R(1)) & std_logic'image(R(0))
								& ", test_R ="
								& std_logic'image(test_r_slv(7)) & std_logic'image(test_r_slv(6)) & std_logic'image(test_r_slv(5)) & std_logic'image(test_r_slv(4)) 
								& std_logic'image(test_r_slv(3)) & std_logic'image(test_r_slv(2)) & std_logic'image(test_r_slv(1)) & std_logic'image(test_r_slv(0))
						severity error;
						
					if (R /= test_r_slv) then
						err_cnt := err_cnt +1;
					end if;
				
				else
					assert div_by_zero = '1'
						report "La divisione per zero non ha prodotto un div_by_zero"
						severity error;
					
					if (div_by_zero /= '1') then
						err_cnt := err_cnt +1;
					end if;
				
				end if;
			
			end loop;
		end loop;
		
		assert false
			report "Si sono verificati " & integer'image(err_cnt) & " errori"
			severity error;
			
			wait;
	end process;
	

end;
