----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:06:55 12/11/2015 
-- Design Name: 
-- Module Name:    stored_carry_encoder_3to2 - Behavioral 
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

entity stored_carry_encoder_3to2 is
    Port ( u : in  STD_LOGIC_VECTOR (7 downto 0);
           v : in  STD_LOGIC_VECTOR (7 downto 0);
           w : in  STD_LOGIC_VECTOR (7 downto 0);
           t : out  STD_LOGIC_VECTOR (7 downto 0);
           cs : out  STD_LOGIC_VECTOR (7 downto 0));
end stored_carry_encoder_3to2;

architecture Behavioral of stored_carry_encoder_3to2 is



	COMPONENT carry_save_3
	PORT(
		x0 : IN std_logic;
		x1 : IN std_logic;
		x2 : IN std_logic;          
		y0 : OUT std_logic; --somma
		y1 : OUT std_logic --riporto
		);
	END COMPONENT;

	


	
begin

--cs(0) <='0';

CS_3: for i in 0 to 7 generate

Inst_carry_save_3: carry_save_3 PORT MAP(
		x0 => u(i),
		x1 => v(i),
		x2 => w(i),
		y0 => t(i),
		y1 => cs(i)
	);

end generate;

end Behavioral;

