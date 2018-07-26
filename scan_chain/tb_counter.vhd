library ieee;
use ieee.std_logic_1164.all;
  
entity tb_counter is
end tb_counter;
 
architecture behavior of tb_counter is 

	-- component declaration for the unit under test (uut)
	component countermod10
		port ( 	areset_n : in std_logic;
				pulse : in  std_logic;
				clock : in  std_logic;
				scan_en : in std_logic;
				scan_in : in std_logic;
				count : out  std_logic_vector (3 downto 0));
	end component;


	--inputs
	signal reset : std_logic := '0';
	signal pulse : std_logic := '0';
	signal clock : std_logic := '0';
	signal scan_en : std_logic := '0';
	signal scan_in : std_logic := '0';

	--outputs
	signal count : std_logic_vector(3 downto 0);
 
begin

	-- instantiate the unit under test (uut)
	uut: countermod10
		port map (	areset_n => reset,
					pulse => pulse,
					clock => clock,
					scan_en => scan_en,
					scan_in => scan_in,
					count => count);
        
	clock_proc : process
	begin
		clock <= '1';
		wait for 1 ns;
		clock <= '0';
		wait for 1 ns;
	end process;

	-- stimulus process
	stim_proc: process
	begin		
		wait for 50 ns;
		reset <= '1';

		-- insert stimulus here
		pulse <= 	'1' after 10 ns,
					'0' after 150 ns;

		wait for 50 ns;
		scan_en <= '1',
					'0' after 20 ns;
					
		scan_in <=	'1' after 5 ns,
					'0' after 10 ns,
					'0' after 15 ns,
					'0' after 20 ns;
		
		wait for 20 ns;
		pulse <=	'1',
					'0' after 35 ns;

		wait for 20 ns;
		scan_en <= '1',
					'0' after 8 ns;
		scan_in <= 	'1',
					'0' after 2 ns,
					'1' after 4 ns,
					'0' after 6 ns;

		wait for 20 ns;
		

		wait;
	end process;

end;
