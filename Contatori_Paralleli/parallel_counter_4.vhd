----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:27:35 12/19/2015 
-- Design Name: 
-- Module Name:    parallel_counter_4 - Behavioral 
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

entity parallel_counter_4 is
    Port ( X : in  STD_LOGIC_VECTOR (3 downto 0);
           C0 : out  STD_LOGIC;
           C1 : out  STD_LOGIC;
           C2 : out  STD_LOGIC);
end parallel_counter_4;

architecture Behavioral of parallel_counter_4 is
COMPONENT full_adder
	PORT(
		add_1 : IN std_logic;
		add_2 : IN std_logic;
		carry_in : IN std_logic;          
		carry_out : OUT std_logic;
		sum : OUT std_logic
		);
	END COMPONENT;

signal tmp_cout_0, tmp_cout_1,tmp_cout_2, tmp_sum_0, tmp_sum_1, tmp_sum_2: std_logic;

begin

FA0: full_adder PORT MAP(
		add_1 => X(2),
		add_2 => X(1),
		carry_in => X(0),
		carry_out => tmp_cout_0,
		sum => tmp_sum_0
	);

FA1: full_adder PORT MAP(
		add_1 => tmp_sum_0,
		add_2 => X(3),
		carry_in => '0',
		carry_out => tmp_cout_1,
		sum => tmp_sum_1
	);
	

	
FA2: full_adder PORT MAP(
		add_1 => tmp_cout_0,
		add_2 => tmp_cout_1,
		carry_in => '0',
		carry_out => tmp_cout_2,
		sum => tmp_sum_2
	);
	
C0 <= tmp_sum_1;
C1 <= tmp_sum_2;
C2 <= tmp_cout_2;

end Behavioral;

