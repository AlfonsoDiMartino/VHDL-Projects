library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cu_exp is
	 Generic (N : natural := 8);
    Port ( start 	: in  STD_LOGIC;
           clock : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
			  EXP : in STD_LOGIC_VECTOR (N-1 downto 0);
           count_done : in  STD_LOGIC;
           sel_acc : out  STD_LOGIC;
           sel_base : out  STD_LOGIC;
           load_acc : out  STD_LOGIC;
           load_base : out  STD_LOGIC;
			  load_t_ff : out  STD_LOGIC;
			  reset_acc_n : out  STD_LOGIC;
			  reset_base_n : out  STD_LOGIC;
			  reset_t_ff_n : out  STD_LOGIC;
           count_en : out  STD_LOGIC;
			  reset_count_n : out STD_LOGIC;
			  done : out  STD_LOGIC
           );
end cu_exp;

architecture Behavioral of cu_exp is

	type state is (sleeping, init, operation);
	signal curr_state, next_state : state := sleeping;
	constant zero_EXP			: std_logic_vector(N-1 downto 0) := (others => '0'); 							-- segnale zero usato per confrontare EXP
		
begin

	stp : process (clock)
	begin
		if (clock = '1' and clock'event) then
			curr_state <= next_state;
		end if;
	end process;

	scp : process (clock, reset_n, curr_state, start, EXP, count_done)
		begin
		
         sel_acc 			<= '0';
         sel_base 		<= '0';
         load_acc 		<= '0';
         load_base		<= '0';
			load_t_ff		<= '0';
			reset_acc_n 	<= '1';
			reset_base_n	<= '1';
			reset_t_ff_n	<= '1';
         count_en 		<= '0';
			reset_count_n	<= '1';
			done 				<= '0';
			
			if (reset_n = '0') then
				next_state <= sleeping;
				reset_acc_n 	<= '0';
				reset_base_n 	<= '0';
				reset_count_n 	<= '0';
				reset_t_ff_n 	<= '0';
				
			else
				case curr_state is
					
					when sleeping =>
						load_t_ff	<= '0';
						done	<= '1';
						
						if(EXP = zero_EXP) then
							sel_acc 		<= '0'; 
							sel_base 	<= '0';
							load_acc		<= '1';
							load_base	<= '1';
						end if;
						
						if (start = '1') then 
							next_state <= init;
						else
							next_state <= sleeping;
						end if;
						
					when init =>
						sel_acc 		<= '0';
						sel_base		<= '1';
						load_acc		<=	'1';
						load_base	<= '1';
						reset_t_ff_n <= '0';
						count_en		<= '1';
						
						next_state 	<= operation;
						
					when operation =>
						sel_acc		<= '1';
						sel_base		<= '1';
						load_acc		<= '1';
						load_base	<= '1';
						load_t_ff	<= '1';
						count_en		<= '0';
						if (count_done = '1') then
							count_en		<= '0';	
							load_acc		<=	'0';
							load_t_ff	<= '0';
							next_state	<= sleeping;
						else
							count_en		<= '1';
							next_state <= operation;
						end if;	
				end case;		
			end if;	
				
		end process;	
end Behavioral;
