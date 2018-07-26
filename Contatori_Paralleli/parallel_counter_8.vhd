----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:54:53 12/19/2015 
-- Design Name: 
-- Module Name:    parallel_counter_8 - Behavioral 
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

entity parallel_counter_8 is
    Port ( X : in  STD_LOGIC_VECTOR (7 downto 0);
           C0 : out  STD_LOGIC;
           C1 : out  STD_LOGIC;
           C2 : out  STD_LOGIC;
           C3 : out  STD_LOGIC);
end parallel_counter_8;

architecture Behavioral of parallel_counter_8 is

COMPONENT full_adder
	PORT(
		add_1 : IN std_logic;
		add_2 : IN std_logic;
		carry_in : IN std_logic;          
		carry_out : OUT std_logic;
		sum : OUT std_logic
		);
	END COMPONENT;

signal tmp_sum_0, tmp_sum_1, tmp_sum_2, tmp_sum_3,tmp_sum_4, tmp_sum_5, tmp_sum_6: std_logic;
signal tmp_cout_0, tmp_cout_1,tmp_cout_2, tmp_cout_3,tmp_cout_4, tmp_cout_5,tmp_cout_6: std_logic;

begin

FA0: full_adder PORT MAP(
		add_1 => X(1),
		add_2 => X(0),
		carry_in => '0',
		carry_out => tmp_cout_0,
		sum => tmp_sum_0
	);

FA1: full_adder PORT MAP(
		add_1 => X(4),
		add_2 => X(3),
		carry_in => X(2),
		carry_out => tmp_cout_1,
		sum => tmp_sum_1
	);
	
FA2: full_adder PORT MAP(
		add_1 => X(7),
		add_2 => X(6),
		carry_in => X(5),
		carry_out => tmp_cout_2,
		sum => tmp_sum_2
	);
	



FA3: full_adder PORT MAP(
		add_1 => tmp_sum_0,
		add_2 => tmp_sum_1,
		carry_in => tmp_sum_2,
		carry_out => tmp_cout_3,
		sum => tmp_sum_3
	);
	
FA4: full_adder PORT MAP(
		add_1 => tmp_cout_0,
		add_2 => tmp_cout_1,
		carry_in => tmp_cout_2,
		carry_out => tmp_cout_4,
		sum => tmp_sum_4
	);
FA5: full_adder PORT MAP(
		add_1 => tmp_cout_3,
		add_2 => tmp_sum_4,
		carry_in => '0',
		carry_out => tmp_cout_5,
		sum => tmp_sum_5
	);
	
FA6: full_adder PORT MAP(
		add_1 => tmp_cout_4,
		add_2 => tmp_cout_5,
		carry_in => '0',
		carry_out => tmp_cout_6,
		sum => tmp_sum_6
	);
	
C0 <= tmp_sum_3;
C1 <= tmp_sum_5;
C2 <= tmp_sum_6;
C3 <= tmp_cout_6;
	


end Behavioral;

