library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity robertson_cu is
	generic (
		N : natural := 8
	);
	port (
		clock 		: in std_logic;
		reset_n 	: in std_logic;
		start 		: in std_logic;		-- avvia il processo di moltiplicazione
		done 		: out std_logic;	-- quando alto indica la fine del processo di calcolo
		
		reset_count	: out std_logic;	-- comando reset conteggio
		count		: out std_logic; 	-- comando incrementa conteggio
		count_in	: in std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0) := (others => '0');	-- segnale "passo corrente"
		
		Q_lsb 		: in std_logic;		-- lsb del registro Q
		sel_mux_F	: out std_logic;	-- segnale selezione per multiplexer segno  (sel_mux=0 => out = 0)
		shift 		: out std_logic;	-- comando shift per registri A e Q
		subtract 	: out std_logic;		-- comando di sottrazione per addizionatore
		
		enable_A 	: out std_logic;	-- abilita/disabilita load in registro A
		enable_F 	: out std_logic;	-- abilita/disabilita load in registro F
		enable_M 	: out std_logic;	-- abilita/disabilita load in registro M
		enable_Q	: out std_logic;	-- abilita/disabilita load in registro Q
		reset_A_n 	: out std_logic;	-- reset registro A (attivo basso)
		reset_F_n 	: out std_logic;	-- reset registro F (attivo basso)
		reset_M_n 	: out std_logic;	-- reset registro M (attivo basso)
		reset_Q_n 	: out std_logic		-- reset registro Q (attivo basso)
	);
end robertson_cu;


architecture behavioral of robertson_cu is

	type state is (
		sleeping,			-- stato stabile in cui la macchina è a riposo in attesa dell'inizio di una nuova operazione
		init,				-- stato di inizializzazione di registri e contatori
		add_increment,		-- stato in cui viene effettuata una addizione (o sottrazione) ed un incremento
		rshift				-- stato in cui viene effettuato lo shift sui registri A e Q e
							-- vengono verificate le condizioni della macchina per determinare
							-- se eseguire ancora operazioni, se eseguire il passo di correzione o se terminare
							-- il calcolo
	);
	
	signal curr_state 		: state := sleeping;																-- stato corrente della macchina
	signal next_state 		: state := sleeping;																-- stato prossimo della macchina
	constant zero_count		: std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0) := (others => '0');	-- costante "tutti zero", usato per confrontare count e determinare lo stato della macchina
	constant one_count 		: std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0) := (others => '1');	-- costante "tutti uno", usato per confrontare count e determinare lo stato della macchina
	constant zero_M			: std_logic_vector(N-1 downto 0) := (others => '0'); 							-- segnale zero usato per confrontare M

begin

	process (clock, reset_n, start)
	begin
		if (clock='1' and clock'event) then
			curr_state <= next_state;
		end if;
	end process;

	process (reset_n, start, curr_state, count_in, Q_lsb)
	begin
		
		done 		<= '0';
		enable_A 	<= '0';
		enable_F 	<= '0';
		enable_M 	<= '0';
		enable_Q	<= '0';
		reset_A_n 	<= '0';
		reset_F_n 	<= '0';
		reset_M_n 	<= '0';
		reset_Q_n 	<= '0';
		reset_count	<= '0';
		sel_mux_F	<= '0';
		shift 		<= '0';
		subtract 	<= '0';
		count		<= '0';
			
		if (reset_n = '0') then
			next_state	<= sleeping;
			
		else
			
			case curr_state is
				when sleeping		=>
					done		<= '1';
					reset_A_n 	<= '1';
					reset_F_n 	<= '1';
					reset_M_n 	<= '1'; 
					reset_Q_n 	<= '1';
					if (start = '1') then
						next_state <= init;
					else
						next_state <= sleeping;
					end if;
					
				when init			=>
					enable_M 	<= '1';
					enable_Q	<= '1';
					reset_M_n 	<= '1'; 
					reset_Q_n 	<= '1';
					next_state 	<= add_increment;					
					
					
				when add_increment	=>
					if (count_in = one_count) then
						subtract 	<= '1';
						sel_mux_F	<= '1';
					end if;
					reset_count	<= '1';
					reset_A_n 	<= '1';
					reset_F_n 	<= '1';
					reset_M_n 	<= '1';
					reset_Q_n 	<= '1';
					count		<= '1';
					if (Q_lsb = '1') then
						enable_A 	<= '1';
					end if;
					enable_F 	<= '1';
					next_state <= rshift;
					
					
				when rshift			=>
					reset_A_n 	<= '1';
					reset_F_n 	<= '1';
					reset_M_n 	<= '1';
					reset_Q_n 	<= '1';
					reset_count	<= '1';
					shift 		<= '1';
					if (count_in = zero_count) then
						next_state 	<= sleeping;
					else
						next_state <= add_increment;
					end if;
				
			end case;
		end if;
	end process;


end behavioral;
		
		
