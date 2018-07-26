--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:32:37 01/15/2016
-- Design Name:   
-- Module Name:   /home/pietro/Scrivania/ISE_PROJECT/Moltiplicatore_Booth/tb_esaustivo.vhd
-- Project Name:  Moltiplicatore_Booth
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: booth_multiplier
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
 
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_esaustivo IS
END tb_esaustivo;
 
ARCHITECTURE behavior OF tb_esaustivo IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT booth_multiplier
    PORT(
         clock : IN  std_logic;
         reset_n : IN  std_logic;
         start : IN  std_logic;
         mul_by_zero : OUT  std_logic;
         done : OUT  std_logic;
         X : IN  std_logic_vector(7 downto 0);
         Y : IN  std_logic_vector(7 downto 0);
         Prod : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clock : std_logic := '0';
   signal reset_n : std_logic := '0';
   signal start : std_logic := '0';
   signal X : std_logic_vector(7 downto 0) := (others => '0');
   signal Y : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal mul_by_zero : std_logic;
   signal done : std_logic;
   signal Prod : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: booth_multiplier PORT MAP (
          clock => clock,
          reset_n => reset_n,
          start => start,
          mul_by_zero => mul_by_zero,
          done => done,
          X => X,
          Y => Y,
          Prod => Prod
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
		variable test_prod : integer := 0;
		variable test_prod_stdlv : std_logic_vector(15 downto 0);
		variable error_cnt : integer := 0;
	begin		
		wait for 100 ns;	
		reset_n <= '1';
		
		--~ -- 5 x 3
		--~ X <= x"05";
		--~ Y <= x"03";
		
		--~ -- -5 x 3
		--~ X <= x"FB";
		--~ Y <= x"03";
		
		--~ -- 5 x -3
		--~ X <= x"05";
		--~ Y <= x"FD";
		
		--~ -- -5 x -3
		--~ X <= x"FB";
		--~ Y <= x"FD";
		--~ 
		--~ -- 0 x 3
		--~ X <= x"00";
		--~ Y <= x"03";
		
		--~ -- 0 x -3
		--~ X <= x"00";
		--~ Y <= x"FD";
		
		--~ -- 3 x 0
		--~ X <= x"03";
		--~ Y <= x"00";
		
		--~ -- -6 x 4
		--~ X <= x"FA";
		--~ Y <= x"04";
		
		-- 127 x 127
		--~ X <= x"7F";
		--~ Y <= x"7F";
		--~ 
		
		-- 47 x -128
		--~ X <= x"2F";
		--~ Y <= x"80";

		
		--~ start <= '1', '0' after clock_period;
		
		
		for i in -128 to 127 loop
			X <= std_logic_vector(to_signed(i, 8));
			for j in -128 to 127 loop
				Y <= std_logic_vector(to_signed(j,8));
				test_prod := i * j;
				test_prod_stdlv := std_logic_vector(to_signed(test_prod, 16));
				
				start <= '1';
				wait for clock_period;
				start <= '0';
				wait for 30*clock_period;
				
				assert (Prod = test_prod_stdlv)
					report 
						"Errore di calcolo con "
						& "i (x) =" & integer'image(i) & " (" 
						& std_logic'image(X(7)) & std_logic'image(X(6)) & std_logic'image(X(5)) & std_logic'image(X(4)) 
						& std_logic'image(X(3)) & std_logic'image(X(2)) & std_logic'image(X(1)) & std_logic'image(X(0))
						& "), j (y) =" & integer'image(j) & " (" 
						& std_logic'image(Y(7)) & std_logic'image(Y(6)) & std_logic'image(Y(5)) & std_logic'image(Y(4)) 
						& std_logic'image(Y(3)) & std_logic'image(Y(2)) & std_logic'image(Y(1)) & std_logic'image(Y(0))
						& "), prod =" 
						& std_logic'image(Prod(15)) & std_logic'image(Prod(14)) & std_logic'image(Prod(13)) & std_logic'image(Prod(12)) 
						& std_logic'image(Prod(11)) & std_logic'image(Prod(10)) & std_logic'image(Prod(9)) & std_logic'image(Prod(8))
						& std_logic'image(Prod(7)) & std_logic'image(Prod(6)) & std_logic'image(Prod(5)) & std_logic'image(Prod(4)) 
						& std_logic'image(Prod(3)) & std_logic'image(Prod(2)) & std_logic'image(Prod(1)) & std_logic'image(Prod(0))
						& ", test_prod ="
						& std_logic'image(test_prod_stdlv(15)) & std_logic'image(test_prod_stdlv(14)) & std_logic'image(test_prod_stdlv(13)) & std_logic'image(test_prod_stdlv(12)) 
						& std_logic'image(test_prod_stdlv(11)) & std_logic'image(test_prod_stdlv(10)) & std_logic'image(test_prod_stdlv(9)) & std_logic'image(test_prod_stdlv(8))
						& std_logic'image(test_prod_stdlv(7)) & std_logic'image(test_prod_stdlv(6)) & std_logic'image(test_prod_stdlv(5)) & std_logic'image(test_prod_stdlv(4)) 
						& std_logic'image(test_prod_stdlv(3)) & std_logic'image(test_prod_stdlv(2)) & std_logic'image(test_prod_stdlv(1)) & std_logic'image(test_prod_stdlv(0))
					severity error;
					
				if (Prod /= test_prod_stdlv) then
					error_cnt := error_cnt + 1;
				end if;
			
			end loop;
		end loop;
		
		assert false
			report "Si sono verificati " & integer'image(error_cnt) & " errori"
			severity error;

		wait;
	end process;

END;
