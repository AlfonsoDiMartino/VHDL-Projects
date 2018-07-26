library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity CU_Diveder_Non_Restoring is
	generic (N : natural := 8);
	port (
		clock 		: in std_logic;
		reset_n 	: in std_logic;
		start 		: in std_logic;		-- avvia il processo di moltiplicazione
		done 		: out std_logic;	-- quando alto indica la fine del processo di calcolo
		 			
--		M_is_zero	: in std_logic;							-- segnale di errore division by 0
--		M_is_zero_out: out std_logic;
		reset_count_n	: out std_logic;	-- comando reset conteggio (attivo basso)
		count_en		: out std_logic; 		-- comando incrementa conteggio
		count_done	: in std_logic;		-- mi dice quando sono arrivato all'ultimo passo
		S		 		: in std_logic;		-- segnale di segno
		S_correzione : in std_logic; -- segnale di segno di correzione
		l_shift_A 		: out std_logic;	-- comando shift per registri A 
		l_shift_Q 		: out std_logic;
		subtract 	: out std_logic;		-- comando di sottrazione per addizionatore
		
		enable_A 	: out std_logic;	-- abilita/disabilita load in registro A
		enable_Q		: out std_logic;	-- abilita/disabilita load in registro Q
		enable_M 	: out std_logic;	-- abilita/disabilita load in registro M
		
		reset_A_n 	: out std_logic;	-- reset registro A (attivo basso)
		reset_Q_n 	: out std_logic;		-- reset registro Q (attivo basso)
		reset_M_n 	: out std_logic	-- reset registro M (attivo basso)
		
	);
end CU_Diveder_Non_Restoring;


architecture behavioral of CU_Diveder_Non_Restoring is

	type state is (
		sleeping,			-- stato stabile in cui la macchina è a riposo in attesa dell'inizio di una nuova operazione
		init,					-- stato di inizializzazione di registri e contatori
		lshift,				-- stato in cui viene effettuato lo shift sui registri A e Q e
		operation,		-- stato in cui viene effettuata una addizione (o sottrazione) 
		setQ
		
							-- vengono verificate le condizioni della macchina per determinare
							-- se eseguire ancora operazioni, se eseguire il passo di correzione o se terminare
							-- il calcolo
	);
	
	signal curr_state 		: state := sleeping;																-- stato corrente della macchina
	signal next_state 		: state := sleeping;																-- stato prossimo della macchina
   constant zero_M			: std_logic_vector(N-1 downto 0) := (others => '0'); 							-- segnale zero usato per confrontare M

begin

	process (clock, reset_n, start)
	
	
	begin
	
		if (clock='1' and clock'event) then
			curr_state <= next_state;
		end if;
	end process;

process (reset_n, start, curr_state, S, count_done, S_correzione)
begin
		enable_A 	<= '0';
		enable_Q		<= '0';
		enable_M 	<= '0';
		reset_A_n 	<= '1';
		reset_Q_n 	<= '1';
		reset_M_n 	<= '1';
		reset_count_n	<= '1';
		l_shift_A 		<= '0';
		l_shift_Q	<= '0';
		count_en 	<= '0';
		done 		<= '0';
	--   M_is_zero_out <= '0';
		subtract <= not S;
			
		if (reset_n = '0') then
		
			reset_A_n 	<= '0';
			reset_Q_n 	<= '0';
			reset_M_n 	<= '0';
			reset_count_n	<= '0';
			next_state	<= sleeping;
			done 		<= '0';
		
		else
			case curr_state is
			
			when sleeping =>

				done <= '1';
			
				if (start = '1') then
					next_state <= init;
				else
					next_state <= sleeping;
				end if;
				
			when init =>

				enable_M <= '1';
				enable_Q <= '1';
				reset_A_n 	<= '0';
				subtract <= '1';
				reset_count_n <= '0';
				next_state <= lshift;
				
			when lshift =>
				if (count_done = '1') then
					if( S_correzione = '1') then
						enable_A   <= '1';
						subtract  <= '0';
						next_state <= sleeping;
					else
						next_state <= sleeping;
					end if;
				else	
					l_shift_A <= '1';
					next_state <= operation;
				end if;
				
			when operation =>
				enable_A <= '1';
				count_en <= '1';
				next_state <= setQ;
				
			when setQ =>
				l_shift_Q <= '1';
				next_state <= lshift;
			
			end case;
		end if;
end process;

end behavioral;		