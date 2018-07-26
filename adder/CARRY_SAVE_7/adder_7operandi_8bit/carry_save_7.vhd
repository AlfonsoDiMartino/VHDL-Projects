----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:53:30 12/11/2015 
-- Design Name: 
-- Module Name:    carry_save_7 - Behavioral 
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

entity carry_save_7 is
    Port ( x0 : in  STD_LOGIC;
			  x1 : in  STD_LOGIC;
			  x2 : in  STD_LOGIC;
		     x3 : in  STD_LOGIC;
	        x4 : in  STD_LOGIC;
			  x5 : in  STD_LOGIC;
			  x6 : in  STD_LOGIC;
           y0 : out  STD_LOGIC;
			  y1 : out STD_LOGIC;
			  y2 : out STD_LOGIC
			  );
end carry_save_7;

architecture Behavioral of carry_save_7 is

COMPONENT full_adder
	PORT(
		add_1 : IN std_logic;
		add_2 : IN std_logic;
		carry_in : IN std_logic;          
		carry_out : OUT std_logic;
		sum : OUT std_logic
		);
	END COMPONENT;

signal carry_1 : std_logic_vector(2 downto 0);
signal sum_0 : std_logic_vector(1 downto 0);
signal tmp_sum : std_logic_vector(2 downto 0);

begin

	Inst_full_adder_1: full_adder 
	PORT MAP(
		add_1 => x1,
		add_2 => x2,
		carry_in => x3,
		carry_out => carry_1(0),
		sum => sum_0(0)
	);
	
	Inst_full_adder_2: full_adder 
	PORT MAP(
		add_1 => x4,
		add_2 => x5,
		carry_in => x6,
		carry_out => carry_1(1),
		sum => sum_0(1)
	);
	
	Inst_full_adder_3: full_adder 
	PORT MAP(
		add_1 => x0,
		add_2 => sum_0(0),
		carry_in => sum_0(1),
		carry_out => carry_1(2),
		sum => tmp_sum(0)
	);
	
	Inst_full_adder_4: full_adder 
	PORT MAP(
		add_1 => carry_1(0),
		add_2 => carry_1(1),
		carry_in => carry_1(2),
		carry_out => tmp_sum(2),
		sum => tmp_sum(1)
	);
	
	
y0 <= tmp_sum(0);
y1 <= tmp_sum(1);
y2 <= tmp_sum(2);

end Behavioral;

