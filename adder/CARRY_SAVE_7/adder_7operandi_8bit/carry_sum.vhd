----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:51:45 12/12/2015 
-- Design Name: 
-- Module Name:    carry_sum - Behavioral 
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

entity carry_sum is
    Port ( u : in  STD_LOGIC_VECTOR(1 downto 0);
           v : in  STD_LOGIC;
           w : in  STD_LOGIC_VECTOR(1 downto 0);
           sum : out  STD_LOGIC_vector (2 downto 0)
			  );
end carry_sum;

architecture Behavioral of carry_sum is

	COMPONENT full_adder
	PORT(
		add_1 : IN std_logic;
		add_2 : IN std_logic;
		carry_in : IN std_logic;          
		carry_out : OUT std_logic;
		sum : OUT std_logic
		);
	END COMPONENT;


signal tmp_v1 : std_logic;
begin

	Inst_full_adder_1: full_adder PORT MAP(
		add_1 => u(0),							-- s'(8)
		add_2 => w(0),							-- w(8)
		carry_in => v,						-- v(8)
		carry_out => tmp_v1,					-- v(9),
		sum => sum(0)							-- s(9)
	);
	
	Inst_full_adder_2: full_adder PORT MAP(
		add_1 => tmp_v1,						-- v(9)
		add_2 => w(1),							-- w(9)
		carry_in => u(1),						-- u(9)
		carry_out => sum(2),					-- s(11)
		sum => sum(1)							-- s(10)
	);
	
end Behavioral;

