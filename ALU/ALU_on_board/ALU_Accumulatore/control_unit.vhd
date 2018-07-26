----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:59:06 11/23/2015 
-- Design Name: 
-- Module Name:    control_unit - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control_unit is
	 Generic ( N: natural := 8);
    Port ( clock : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           button_2 : in  STD_LOGIC;
           button_3 : in  STD_LOGIC;
           data_in : in  STD_LOGIC_VECTOR (N-1 downto 0);
			  count_in : in STD_LOGIC_VECTOR (1 downto 0);
           result : in  STD_LOGIC_VECTOR (4*N-1 downto 0);
			  load_op1: out STD_LOGIC;
			  load_op2: out STD_LOGIC;
			  load_acc : out STD_LOGIC;
			  load_result: out STD_LOGIC;
			  start : out STD_LOGIC;
			  operation_sel : out STD_LOGIC_VECTOR (2 downto 0);
			  data_or : out STD_LOGIC_VECTOR (2*N-1 downto 0);
           data_out : out  STD_LOGIC_VECTOR (2*N-1 downto 0);
			  data_accumul : out STD_LOGIC_VECTOR (2*N-1 downto 0);
			  status_alu : in STD_LOGIC_VECTOR(1 downto 0);
			  op_status: out STD_LOGIC;
			  done 	: out STD_LOGIC;
			  led 	: out STD_LOGIC_VECTOR (1 downto 0)
				);
end control_unit;

architecture Behavioral of control_unit is

constant zero : std_logic_vector (1 downto 0) := "00";
constant uno : std_logic_vector (1 downto 0) := "01";
constant due : std_logic_vector (1 downto 0) := "10";
constant tre : std_logic_vector (1 downto 0) := "11";

constant add : std_logic_vector (2 downto 0) := "000";
constant sott : std_logic_vector (2 downto 0) := "001";
constant molt : std_logic_vector (2 downto 0) := "010";
constant div : std_logic_vector (2 downto 0) := "011";
constant esp : std_logic_vector (2 downto 0) := "100";

signal tmp_result : std_logic_vector (4*N-1 downto 0);

constant zeros : std_logic_vector (N-1 downto 0) := "00000000";
signal tmp_acc: std_logic_vector (2*N-1 downto 0);
signal codice_tmp : std_logic_vector (2 downto  0) := (others =>'0');

begin

tmp_result <= result;
data_accumul <= tmp_acc;

main: process (reset_n, clock,button_2, button_3,count_in,result)
begin
	if (reset_n = '0') then -- azzero tutte le uscite
		load_op1 <= '0';
		load_op2 <= '0';
		load_acc <= '0';
		load_result <= '0';
		led <= zero;
		done <= '0';
		start <= '0';
		op_status <= '0';
		codice_tmp <= "000";
		operation_sel <= "000";
		data_or <=(others =>'0');
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
				load_acc <= '0';
			end if;
			
		elsif (count_in = due) then	-- MODE 2: SCELTA OPERAZIONE
			led <= due;
			if (button_2 = '1') then
				operation_sel <= data_in(2 downto 0);
				codice_tmp <= data_in (2 downto 0);
				done <= '0';
			elsif (button_3 = '1') then
				start <= '1';
				done  <= '1';
				op_status <= status_alu(1);
			else
				start <= '0';
			end if;
			load_result <= '1';
			
		elsif (count_in = tre) then	-- MODE 3: VISUALIZZAZIONE
			load_result <= '0';
			led <= tre;
			if (button_2 = '1') then
				if(codice_tmp = add or codice_tmp = sott or codice_tmp = esp or codice_tmp = molt) then
					data_out <= tmp_result (2*N-1 downto 0);
					tmp_acc <= tmp_result (2*N-1 downto 0);
					data_or  <= tmp_result (4*N-1 downto 2*N);
				elsif (codice_tmp = div) then
					data_out <= tmp_result((N/4+1)*N-1 downto (N/4)*N) & tmp_result(N-1 downto 0);
					tmp_acc <= zeros & tmp_result(N-1 downto 0);
					data_or <= tmp_result(4*N-1 downto (N/4+1)*N) & tmp_result(2*N-1 downto N);
				end if;
				load_acc <= '1';
			end if;
		end if;
		
	end if;
end process;

		
end Behavioral;

