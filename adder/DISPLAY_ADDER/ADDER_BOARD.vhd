----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:09:44 11/23/2015 
-- Design Name: 
-- Module Name:    ADDER_BOARD - Behavioral 
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

entity ADDER_BOARD is
    Port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           add1_en : in  STD_LOGIC;
           add2_en : in  STD_LOGIC;
           sum_en : in  STD_LOGIC;
           data_in : in  STD_LOGIC_VECTOR (7 downto 0);
          -- sum : in  STD_LOGIC_VECTOR (7 downto 0);
           anodi : out  STD_LOGIC_VECTOR (3 downto 0);
           catodi : out  STD_LOGIC_VECTOR (6 downto 0);
			  punto: out STD_LOGIC;
           carry_out : out  STD_LOGIC);
end ADDER_BOARD;

architecture Behavioral of ADDER_BOARD is

signal temp_add1: std_logic_vector (7 downto 0);
signal temp_add2: std_logic_vector (7 downto 0);
signal temp_sum: std_logic_vector (7 downto 0);
signal temp_data_out: std_logic_vector (15 downto 0);
signal temp_enable: std_logic_vector (3 downto 0);
signal temp_carry: std_logic;

COMPONENT buffer_register
	generic( n : natural := 8);
	PORT(
		I : IN std_logic_vector(n-1 downto 0);
		clk : IN std_logic;
		load : IN std_logic;
		clear : IN std_logic;          
		Q : OUT std_logic_vector(n-1 downto 0)
		);
	END COMPONENT;
	
COMPONENT adder
	PORT(
		x : IN std_logic_vector(7 downto 0);
		y : IN std_logic_vector(7 downto 0);
		carry_in : IN std_logic;          
		carry_out : OUT std_logic;
		sum : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	

COMPONENT control_unit
	PORT(
		clock : IN std_logic;
		reset_n : IN std_logic;
		add1_en : IN std_logic;
		add2_en : IN std_logic;
		sum_en : IN std_logic;
		data_in : IN std_logic_vector(7 downto 0);
		carry_in : in STD_LOGIC;
		carry_out : out STD_LOGIC;
		sum : IN std_logic_vector(7 downto 0);          
		display_en : OUT std_logic_vector(3 downto 0);
		data_out : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;

	
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

	
	
begin


BUFFER1: buffer_register 
		generic map(n =>8)
		PORT MAP(
		I => data_in,
		clk => clock,
		load => add1_en,
		clear => not reset,
		Q => temp_add1
	);
	
BUFFER2: buffer_register 
		generic map(n =>8)
		PORT MAP(
		I => data_in,
		clk => clock,
		load => add2_en,
		clear => not reset,
		Q => temp_add2
	);
	
Generic_ADDER: adder PORT MAP(
		x => temp_add1 ,
		y => temp_add2,
		carry_in => '0',
		carry_out => temp_carry,
		sum => temp_sum
	);

CU: control_unit PORT MAP(
		clock => clock ,
		reset_n => not reset,
		add1_en => add1_en,
		add2_en => add2_en,
		sum_en => sum_en,
		data_in => data_in,
		carry_in => temp_carry,
		carry_out => carry_out,
		sum => temp_sum,
		display_en => temp_enable,
		data_out => temp_data_out
	);

DISPLAY7: display PORT MAP(
		display_enable => temp_enable ,
		clk => clock,
		data_in => temp_data_out,
		dots => "1111",
		reset_n => not reset,
		anodi => anodi,
		catodi => catodi,
		punto => punto
	);	

end Behavioral;

