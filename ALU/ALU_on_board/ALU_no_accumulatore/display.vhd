----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:49:18 11/21/2015 
-- Design Name: 
-- Module Name:    display - Behavioral 
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

entity display is
    Port ( display_enable : in  STD_LOGIC_VECTOR (3 downto 0);
           clk : in  STD_LOGIC;
           data_in : in  STD_LOGIC_VECTOR (15 downto 0);
           dots : in  STD_LOGIC_VECTOR (3 downto 0);
           reset_n : in  STD_LOGIC;
           anodi : out  STD_LOGIC_VECTOR (3 downto 0);
           catodi : out  STD_LOGIC_VECTOR (6 downto 0);
			  punto: out STD_LOGIC);
end display;

architecture Behavioral of Display is

COMPONENT filter is
	generic (freq_in: integer := 50000000;
				freq_out: integer :=500);
	PORT(
		clock_in : IN std_logic;
		reset_n : IN std_logic;          
		clock_out : OUT std_logic
		);
	END COMPONENT;

COMPONENT counterMod4 is
	PORT(
		reset_n : IN std_logic;
		clock : IN std_logic;
		enable : IN std_logic;          
		count : OUT std_logic_vector(1 downto 0)
		);
	END COMPONENT;

COMPONENT decoder_hex is
	PORT(
		data_in : IN std_logic_vector(3 downto 0);          
		data_out : OUT std_logic_vector(6 downto 0)
		);
	END COMPONENT;

COMPONENT mux16to4 is
	PORT(
		I : IN std_logic_vector(15 downto 0);
		sel : IN std_logic_vector(1 downto 0);          
		O : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;

COMPONENT selector
	PORT(
		data_en : IN std_logic_vector(3 downto 0);
		sel : IN std_logic_vector(1 downto 0);          
		data_out : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	
COMPONENT mux4to1
	PORT(
		i : IN std_logic_vector(3 downto 0);
		sel : IN std_logic_vector(1 downto 0);          
		o : OUT std_logic
		);
	END COMPONENT;

	
signal temp_filter_out: std_logic;
signal temp_counter_out: std_logic_vector( 1 downto 0);
signal temp_mux16_out: std_logic_vector (3 downto 0);


begin

Inst_filter: filter 
		generic map(50000000, 500)
		PORT MAP(
		clock_in => clk,
		reset_n => reset_n,
		clock_out => temp_filter_out
	);

Inst_counterMod4: counterMod4 PORT MAP(
		reset_n => reset_n,
		clock => clk,
		enable => temp_filter_out,
		count => temp_counter_out
	);

Inst_mux16to4: mux16to4 
		PORT MAP(
		I => data_in,
		sel => temp_counter_out,
		O => temp_mux16_out
	);

Inst_decoder_hex: decoder_hex PORT MAP(
		data_in => temp_mux16_out,
		data_out => catodi
	);

Inst_selector: selector PORT MAP(
		data_en => display_enable,
		sel => temp_counter_out,
		data_out => anodi
	);	

Inst_mux4to1: mux4to1 PORT MAP(
		i => dots ,
		sel => temp_counter_out,
		o => punto
	);
	
	
end Behavioral;
