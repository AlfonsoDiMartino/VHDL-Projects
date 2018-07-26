--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 

 
ENTITY tb_adder IS
END tb_adder;
 
ARCHITECTURE behavior OF tb_adder IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT adder
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
   uut: adder PORT MAP (
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
		--TEST 1 no overflow 
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
		assert (sum="11111110" and carry_out='1') report "Error3!" severity error;
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
