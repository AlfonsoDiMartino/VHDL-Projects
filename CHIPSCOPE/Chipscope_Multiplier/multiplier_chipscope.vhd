----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:21:44 01/04/2016 
-- Design Name: 
-- Module Name:    multiplier_chipscope - Behavioral 
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

entity multiplier_chipscope is
end multiplier_chipscope;

architecture Behavioral of multiplier_chipscope is


	COMPONENT parallel_multiplier_righe
	PORT(
		X : IN std_logic_vector(63 downto 0);
		Y : IN std_logic_vector(63 downto 0);          
		PROD : OUT std_logic_vector(127 downto 0)
		);
	END COMPONENT;

component vio_fattore
  PORT (
    CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
    ASYNC_OUT : OUT STD_LOGIC_VECTOR(63 DOWNTO 0));

end component;

component icon
  PORT (
    CONTROL0 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
    CONTROL1 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
    CONTROL2 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0));

end component;

component vio_prodotto
  PORT (
    CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
    ASYNC_IN : IN STD_LOGIC_VECTOR(127 DOWNTO 0));

end component;

signal control0, control1, control2: std_logic_vector (35 downto 0);
signal fatt1, fatt2 : std_logic_vector (63 downto 0);
signal tmp_prod : std_logic_vector (127 downto 0);

begin


Inst_parallel_multiplier_righe: parallel_multiplier_righe PORT MAP(
	X => fatt1,
	Y => fatt2,
	PROD => tmp_prod
);
		

FATTORE1: vio_fattore
  port map (
    CONTROL => CONTROL0,
    ASYNC_OUT => fatt1);


FATTORE2: vio_fattore
  port map (
    CONTROL => CONTROL1,
    ASYNC_OUT => fatt2);

	
PRODOTTO: vio_prodotto
  port map (
    CONTROL => CONTROL2,
    ASYNC_IN => tmp_prod);


	 
your_instance_name : icon
  port map (
    CONTROL0 => CONTROL0,
    CONTROL1 => CONTROL1,
    CONTROL2 => CONTROL2);


end Behavioral;

