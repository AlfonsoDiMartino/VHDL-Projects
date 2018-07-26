library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity restoring_cu is
	generic (
		N : natural := 8
	);
	port (
		clock 		: in std_logic;
		reset_n 	: in std_logic;
		start 		: in std_logic;		-- avvia il processo di moltiplicazione
		done 		: out std_logic;	-- quando alto indica la fine del processo di calcolo
	
		count_in	: in std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0) := (others => '0');	-- segnale "passo corrente"
		
		lshift_A 	: out std_logic;	-- comando shift per registro A
		lshift_Q 	: out std_logic;	-- comando shift per registro Q
		subtract 	: out std_logic;	-- comando di sottrazione per addizionatore
		
		enable_A 	: out std_logic;	-- abilita/disabilita load in registro A
		enable_M 	: out std_logic;	-- abilita/disabilita load in registro M
		enable_Q	: out std_logic;	-- abilita/disabilita load in registro Q
		enable_cnt	: out std_logic; 	-- comando incrementa conteggio
		
		reset_A_n 	: out std_logic;	-- reset registro A (attivo basso)
		reset_M_n 	: out std_logic;	-- reset registro M (attivo basso)
		reset_Q_n 	: out std_logic;	-- reset registro Q (attivo basso)
		reset_cnt_n	: out std_logic		-- comando reset conteggio
	);
end restoring_cu;


architecture behavioral of restoring_cu is

	type state is (
		sleeping,	-- stato inattivo, in attesa del prossimo avvio 
		init,		-- stato di inizzializzazione dei registri coinvolti nel calcolo
		lshiftA,	-- stato in cui viene shiftato A ed incrementato il contatore
		operation
	);
	signal curr_state : state := sleeping;
	signal next_state : state := sleeping;
	
	constant max_count		: std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0) := (others => '1');	-- costante "tutti uno", usato per confrontare count e determinare lo stato della macchina
	constant zero_M			: std_logic_vector(N-1 downto 0) := (others => '0'); 							-- segnale zero usato per confrontare M

begin

	stp : process (clock)
	begin
		if (clock = '1' and clock'event) then
			curr_state <= next_state;
		end if;
	end process;

	scp : process (clock, reset_n, curr_state, start, count_in)
	begin
		
		done 		<= '0';
		lshift_A 	<= '0';
		lshift_Q 	<= '0';
		subtract 	<= '1';
		enable_A 	<= '0';
		enable_M 	<= '0';
		enable_Q	<= '0';
		enable_cnt	<= '0';
		reset_A_n 	<= '1';
		reset_M_n 	<= '1';
		reset_Q_n 	<= '1';
		reset_cnt_n	<= '1';
		
		if (reset_n = '0') then
			next_state <= sleeping;
			reset_A_n 	<= '0';
			reset_M_n 	<= '0';
			reset_Q_n 	<= '0';
			reset_cnt_n	<= '0';
		
		else
		
			case curr_state is
				
				when sleeping =>
					done 		<= '1';
					
					if (start = '1') then
						next_state <= init;
					else
						next_state <= sleeping;
					end if;
					
				when init =>
					reset_A_n 	<= '0';
					reset_cnt_n	<= '0';
					enable_M 	<= '1';
					enable_Q	<= '1';
					next_state	<= lshiftA;
				
				when lshiftA =>
					lshift_A	<= '1';
					next_state <= operation;
				
				when operation =>
					enable_cnt	<= '1';
					enable_A <= '1'; -- A viene abilitato, ma esternamente il comando di "enable" di
									 -- A è in and con Q_Lsb = not sum_msb
					
					lshift_Q	<= '1';
					if (count_in = max_count) then
						next_state <= sleeping;
					else
						next_state <= lshiftA;
					end if;
									
			end case;
		
		end if;
	
	end process;
	

end behavioral;
		
		

