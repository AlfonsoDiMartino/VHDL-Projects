----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:56:11 11/20/2015 
-- Design Name: 
-- Module Name:    sette_segmenti - Behavioral 
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

entity display_7seg is
    Port ( data_in : IN std_logic_vector(7 downto 0);
			  reset : IN std_logic;
			  msb : IN std_logic;
			  lsb : IN std_logic;
			  dot : IN std_logic;
			  clock : IN std_logic;
           anodi : out  STD_LOGIC_VECTOR (3 downto 0);
           catodi : out  STD_LOGIC_VECTOR (6 downto 0);
           punto : out  STD_LOGIC);
end display_7seg;

architecture Behavioral of display_7seg is
COMPONENT display
	PORT(
		display_enable : IN std_logic_vector(3 downto 0);
		clk : IN std_logic;
		data_in : IN std_logic_vector(15 downto 0);
		dots : IN std_logic_vector(3 downto 0);
		reset_n : IN std_logic;          
		anodi : OUT std_logic_vector(3 downto 0);
		catodi : OUT std_logic_vector(6 downto 0);
		punto : OUT std_logic
		);
	END COMPONENT;
COMPONENT control_unit
	PORT(
		data_in : IN std_logic_vector(7 downto 0);
		reset_n : IN std_logic;
		msb : IN std_logic;
		lsb : IN std_logic;
		dot : IN std_logic;
		clock : IN std_logic;          
		data_out : OUT std_logic_vector(15 downto 0);
		display_enable : OUT std_logic_vector(3 downto 0);
		dots : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;

signal temp_data_out : std_logic_vector(15 downto 0);
signal temp_enable : std_logic_vector(3 downto 0);
signal temp_dots : std_logic_vector(3 downto 0);
	
begin

Inst_control_unit: control_unit PORT MAP(
		data_in => data_in,
		reset_n => not reset,
		msb => msb,
		lsb => lsb,
		dot => dot,
		clock => clock,
		data_out => temp_data_out,
		display_enable => temp_enable,
		dots => temp_dots
	);
Inst_Display: Display PORT MAP(
		display_enable => temp_enable,
		clk => clock,
		data_in => temp_data_out,
		dots => temp_dots,
		reset_n => not reset,
		anodi => anodi,
		catodi => catodi,
		punto => punto
	);

end Behavioral;

