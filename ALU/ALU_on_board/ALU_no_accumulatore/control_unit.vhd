library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity control_unit is
	 Generic ( N: natural := 8);
    Port ( clock : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           button_2 : in  STD_LOGIC;
           button_3 : in  STD_LOGIC;
           data_in : in  STD_LOGIC_VECTOR (N-1 downto 0);
			  count_in : in STD_LOGIC_VECTOR (1 downto 0);
           result : in  STD_LOGIC_VECTOR (2*N-1 downto 0);
			  status_alu: in STD_LOGIC_VECTOR(1 downto 0);
			  op_status : out STD_LOGIC; 
			  done : out STD_LOGIC;
			  load_op1: out STD_LOGIC;
			  load_op2: out STD_LOGIC;
			  start : out STD_LOGIC;
           display_en : out  STD_LOGIC_VECTOR (3 downto 0);
			  operation_sel : out STD_LOGIC_VECTOR (2 downto 0);
           data_out : out  STD_LOGIC_VECTOR (2*N-1  downto 0);
			  led 	: out STD_LOGIC_VECTOR (1 downto 0)
				);
end control_unit;

architecture Behavioral of control_unit is

constant zero : std_logic_vector (1 downto 0) := "00";
constant uno : std_logic_vector (1 downto 0) := "01";
constant due : std_logic_vector (1 downto 0) := "10";
constant tre : std_logic_vector (1 downto 0) := "11";



begin

main: process (reset_n, clock,button_2, button_3,count_in,result)
begin
	if (reset_n = '0') then -- azzero tutte le uscite
		load_op1 <= '0';
		load_op2 <= '0';
		led <= zero;
		start <= '0';
		done <= '0';
		op_status <= '0';
		operation_sel <= "000";
		data_out <=(others =>'0');
		
	elsif (clock = '1' and clock'event) then
		
		if (count_in = uno) then	-- MODE 1: INSERIMENTO OPERANDI
			led <= uno;
			done <= '0';
			op_status <= '0';
			if (button_2 = '1') then
				load_op1 <= '1';
				data_out(7 downto 0) <= data_in;
			elsif (button_3 = '1') then
				load_op2 <= '1';
				data_out(15 downto 8) <= data_in;
			else
				load_op1 <= '0';
				load_op2 <= '0';
			end if;
			
		elsif (count_in = due) then	-- MODE 2: SCELTA OPERAZIONE
			led <= due;
			if (button_2 = '1') then
				operation_sel <= data_in(2 downto 0);
			elsif (button_3 = '1') then
				start <= '1';
				done <= '1';
				op_status<= status_alu(1);
			else
				start <= '0';
			end if;
			
		elsif (count_in = tre) then	-- MODE 3: VISUALIZZAZIONE
			led <= tre;
			if (button_2 = '1') then
				data_out <= result;
			end if;
		end if;
		
	end if;
end process;


end Behavioral;

