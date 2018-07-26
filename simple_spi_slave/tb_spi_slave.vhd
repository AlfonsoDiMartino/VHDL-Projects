
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_spi_slave IS
END tb_spi_slave;
 
ARCHITECTURE behavior OF tb_spi_slave IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT spi_slave
    PORT(
         clock : IN  std_logic;
         reset_n : IN  std_logic;
         data_in : IN  std_logic_vector(7 downto 0);
         load_data : IN  std_logic;
         data_out : OUT  std_logic_vector(7 downto 0);
         busy : OUT  std_logic;
         sck : IN  std_logic;
         sdi : IN  std_logic;
         sdo : OUT  std_logic;
         ss_n : IN  std_logic
        );
    END COMPONENT;
    
   --Inputs
   signal clock : std_logic := '0';
   signal reset_n : std_logic := '0';
   signal data_in : std_logic_vector(7 downto 0) := (others => '0');
   signal load_data : std_logic := '0';
   signal sck : std_logic := '0';
   signal sdi : std_logic := '0';
   signal ss_n : std_logic := '1';

 	--Outputs
   signal data_out : std_logic_vector(7 downto 0);
   signal busy : std_logic;
   signal sdo : std_logic;

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: spi_slave PORT MAP (
          clock => clock,
          reset_n => reset_n,
          data_in => data_in,
          load_data => load_data,
          data_out => data_out,
          busy => busy,
          sck => sck,
          sdi => sdi,
          sdo => sdo,
          ss_n => ss_n
        );

   -- Clock process definitions
   clock_process : process
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
    data_in <= x"AB";
    load_data <= '1', '0' after clock_period;
    ss_n <= '0', '1' after 64 * clock_period;
    
    sck <= 	'1' after 4*clock_period,
			'0' after 8*clock_period,	
			'1' after 12*clock_period,	
			'0' after 16*clock_period,	
			'1' after 20*clock_period,	
			'0' after 24*clock_period,	
			'1' after 28*clock_period,	
			'0' after 32*clock_period,
			'1' after 36*clock_period,	
			'0' after 40*clock_period,
			'1' after 44*clock_period,	
			'0' after 48*clock_period,
			'1' after 52*clock_period,	
			'0' after 56*clock_period,
			'1' after 60*clock_period,	
			'0' after 64*clock_period;
			
	sdi <= 	'1' after 4*clock_period,
			'0' after 12*clock_period,	
			'0' after 20*clock_period,	
			'1' after 28*clock_period,	
			'0' after 36*clock_period,	
			'1' after 44*clock_period,	
			'1' after 52*clock_period,	
			'0' after 60*clock_period;


      wait;
   end process;

END;
