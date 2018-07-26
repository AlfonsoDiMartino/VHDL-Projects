----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:35:40 12/18/2015 
-- Design Name: 
-- Module Name:    partial_sum_row - Behavioral 
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

entity partial_sum_diagonal is
	generic (N : natural := 8);
    Port ( X : in  STD_LOGIC_VECTOR (N-2 downto 0);
           Y : in  STD_LOGIC_VECTOR (N-1 downto 0);
           SUM : out  STD_LOGIC_VECTOR (N-2 downto 0);
           COUT : out  STD_LOGIC;
			  S: out STD_LOGIC
			  );
end partial_sum_diagonal;


architecture Behavioral of partial_sum_diagonal is

COMPONENT ripple_carry_adder
	GENERIC (N : natural);
	PORT(
		x : IN std_logic_vector(N-1 downto 0);
		y : IN std_logic_vector(N-1 downto 0);
		carry_in : IN std_logic;          
		carry_out : OUT std_logic;
		sum : OUT std_logic_vector(N-1 downto 0)
		);
	END COMPONENT;

signal tmp_cout: std_logic := '0';
signal tmp_sum : std_logic_vector (N-2 downto 0) := (others => '0');
signal tmp_Y: std_logic_vector (N-2 downto 0) := (others => '0');

begin

tmp_Y <= Y (N-1 downto 1);
Inst_ripple_carry_adder: ripple_carry_adder 
	GENERIC MAP(N-1)
	PORT MAP(
		x => X,
		y => tmp_Y,
		carry_in => '0',
		carry_out => tmp_cout,
		sum => tmp_sum
	);	

SUM <= tmp_sum(N-3 downto 0)& Y(0);
COUT <= tmp_cout;
S <= tmp_sum(N-2);

end Behavioral;

