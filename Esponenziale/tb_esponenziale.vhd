LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY tb_esponenziale IS
END tb_esponenziale;
 
ARCHITECTURE behavior OF tb_esponenziale IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT esponenziale
    PORT(
         start : IN  std_logic;
         clock : IN  std_logic;
         reset_n : IN  std_logic;
         base : IN  std_logic_vector(7 downto 0);
         exp : IN  std_logic_vector(7 downto 0);
         done : OUT  std_logic;
         truncate : OUT  std_logic;
         result : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal start : std_logic := '0';
   signal clock : std_logic := '0';
   signal reset_n : std_logic := '0';
   signal base : std_logic_vector(7 downto 0) := (others => '0');
   signal exp : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal done : std_logic;
   signal truncate : std_logic;
   signal result : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: esponenziale PORT MAP (
          start => start,
          clock => clock,
          reset_n => reset_n,
          base => base,
          exp => exp,
          done => done,
          truncate => truncate,
          result => result
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

		start 	<= '1', '0' after clock_period;
		reset_n 	<= '1';
		base		<= x"05";
		exp		<= x"05";

      -- insert stimulus here 

      wait;
   end process;

END;
