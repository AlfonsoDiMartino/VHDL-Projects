library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity tb_restoring_divider is
end tb_restoring_divider;

architecture behavioral of tb_restoring_divider is

	component divider is
		port (
			clock 			: in std_logic;
			reset_n 		: in std_logic;
			start 			: in std_logic;		-- avvia il processo di moltiplicazione
			
			div_by_zero		: out std_logic;	-- indica se il divisore e' zero
			done 			: out std_logic;	-- quando alto indica la fine del processo di calcolo
			
			D				: in std_logic_vector(7 downto 0);			-- dividendo
			V 				: in std_logic_vector(7 downto 0);			-- divisore
			Q				: out std_logic_vector(7 downto 0);			-- quoziente
			R				: out std_logic_vector(7 downto 0)			-- resto
		);
	end component;
	
	for all : divider use entity work.restoring_divider;


	signal clock 			: std_logic := '0';
	signal reset_n 			: std_logic := '0';
	signal start 			: std_logic := '0';												-- avvia il processo di moltiplicazione
	signal D 				: std_logic_vector(7 downto 0) := (others => '0');				-- dividendo
	signal V 				: std_logic_vector(7 downto 0) := (others => '0');				-- divisore
	
	signal div_by_zero		: std_logic;													-- indica se il divisore e' zero
	signal done 			: std_logic;													-- quando alto indica la fine del processo di calcolo
	signal Q	 			: std_logic_vector(7 downto 0);									-- quoziente
	signal R 				: std_logic_vector(7 downto 0);									-- resto

	constant clock_period : time := 10 ns;

begin


	DIV : divider
		port map (
			clock 			=> clock,
			reset_n 		=> reset_n,
			start 			=> start,
			div_by_zero		=> div_by_zero,
			done 			=> done,
			D 				=> D,
			V 				=> V,
			Q			 	=> Q,
			R 				=> R
		);

	clock_process : process
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
	

end behavioral;
