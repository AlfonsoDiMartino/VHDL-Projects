----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:27:43 10/30/2015 
-- Design Name: 
-- Module Name:    ring_oscilator - Behavioral 
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

entity ring_oscilator is
    Port ( en : in  STD_LOGIC;
           osc : out  STD_LOGIC);
end ring_oscilator;

architecture Behavioral of ring_oscilator is

	component inverter_chain is
		generic (N : natural := 8;
					delay : time := 5 ns);
    Port ( i : in  STD_LOGIC;
           o : out  STD_LOGIC);
	end component inverter_chain;

constant ritardo_inverter : time := 74 ps;
constant numero_inverter : natural := 8;

signal input_chain, output_chain : std_logic;

begin

	input_chain <= output_chain nand en;
	osc <= output_chain;
	
	inv_chain_inst: inverter_chain generic map (
		N=> numero_inverter,
		delay => ritardo_inverter)
		
		PORT MAP (
			i => input_chain,
			o => output_chain
			);
				
end Behavioral;

