library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity booth_cu is
	generic (
		N : natural := 8
	);
	port (
		clock 			: in std_logic;
		
		reset_n 		: in std_logic;
		start 			: in std_logic;			-- avvia il processo di moltiplicazione
		done 			: out std_logic;		-- flag fine del processo di calcolo
		
		count_in		: in std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0) := (others => '0');	-- segnale "passo corrente"
		Q_lsb 			: in std_logic_vector(1 downto 0);														-- due bit lsb del registro Q

		shift 			: out std_logic;	-- abilita/disabilita shift per registri A e Q
		subtract 		: out std_logic;	-- abilita/disabilita sottrazione
		
		enable_A 		: out std_logic;	-- abilita/disabilita load in registro A
		enable_M 		: out std_logic;	-- abilita/disabilita load in registro M
		enable_Q		: out std_logic;	-- abilita/disabilita load in registro Q
		enable_count	: out std_logic; 	-- abilita/disabilita incremento conteggio

		reset_A_n 		: out std_logic;	-- reset registro A (attivo basso)
		reset_M_n 		: out std_logic;	-- reset registro M (attivo basso)
		reset_Q_n 		: out std_logic;	-- reset registro Q (attivo basso)
		reset_count_n	: out std_logic		-- reset contatore (attivo basso)
	);
end booth_cu;


architecture behavioral of booth_cu is

	type state is (
		sleeping,			-- stato stabile in cui la macchina è a riposo in attesa dell'inizio di una nuova operazione
		init,				-- stato di inizializzazione di registri e contatori
		choice,				-- stato in cui vengono controllati Q_0 e Q_-1 per decidere le operazioni da fare
		rshift				-- stato in cui viene effettuato lo shift sui registri A e Q e
							-- vengono verificate le condizioni della macchina per determinare
							-- se eseguire ancora operazioni o se terminare il calcolo
	);
	
	signal curr_state 		: state := sleeping;																-- stato corrente della macchina
	signal next_state 		: state := sleeping;																-- stato prossimo della macchina
	
	constant max_count		: std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0) := (others => '1');	-- costante "tutti uno", usato per confrontare count e determinare lo stato della macchina

begin

	subtract <= Q_lsb(1) and not Q_lsb(0);
	
	process (clock, reset_n, start)
	begin
		if (clock='1' and clock'event) then
			curr_state <= next_state;
		end if;
	end process;

	process (reset_n, start, curr_state, count_in, Q_lsb)
	begin
		done 			<= '0';
		shift 			<= '0';
		enable_A 		<= '0';
		enable_M 		<= '0';
		enable_Q		<= '0';
		enable_count	<= '0';
		reset_A_n 		<= '1';
		reset_M_n 		<= '1';
		reset_Q_n 		<= '1';
		reset_count_n	<= '1';

		if (reset_n = '0') then
			next_state	<= sleeping;
			reset_A_n 		<= '0';
			reset_M_n 		<= '0';
			reset_Q_n 		<= '0';
			reset_count_n	<= '0';
		else
			case curr_state is
				when sleeping		=>
					done 			<= '1';
					if (start = '1') then
						next_state <= init;
					else
						next_state <= sleeping;
					end if;
					
				when init			=>
					reset_A_n 		<= '0';
					reset_count_n	<= '0';
					enable_M 		<= '1';
					enable_Q		<= '1';
					next_state 		<= choice;
					
				when choice	=>
					enable_A <= Q_lsb(1) xor Q_lsb(0);
					next_state <= rshift;
					
				when rshift =>
					enable_count 	<= '1';
					shift 			<= '1';
					if (count_in = max_count) then
						next_state 	<= sleeping;
					else
						next_state <= choice;
					end if;
				
			end case;
		end if;
	end process;


end behavioral;
