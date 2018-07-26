----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:39:19 12/11/2015 
-- Design Name: 
-- Module Name:    stored-carry_encode_7to3 - Behavioral 
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

entity stored_carry_encoder_7to3 is
    Port ( in_0 : in  STD_LOGIC_VECTOR (7 downto 0);
           in_1 : in  STD_LOGIC_VECTOR (7 downto 0);
           in_2 : in  STD_LOGIC_VECTOR (7 downto 0);
           in_3 : in  STD_LOGIC_VECTOR (7 downto 0);
           in_4 : in  STD_LOGIC_VECTOR (7 downto 0);
           in_5 : in  STD_LOGIC_VECTOR (7 downto 0);
           in_6 : in  STD_LOGIC_VECTOR (7 downto 0);
           u : out  STD_LOGIC_VECTOR (7 downto 0);
           v : out  STD_LOGIC_VECTOR (8 downto 0);
           w : out  STD_LOGIC_VECTOR (9 downto 0)
			  );
end stored_carry_encoder_7to3;

architecture Behavioral of stored_carry_encoder_7to3 is

COMPONENT carry_save_7 
	PORT(
		x0 : in  STD_LOGIC;
		x1 : in  STD_LOGIC;
		x2 : in  STD_LOGIC;
		x3 : in  STD_LOGIC;
	   x4 : in  STD_LOGIC;
		x5 : in  STD_LOGIC;
		x6 : in  STD_LOGIC;
		y0 : OUT std_logic;
		y1 : OUT std_logic;
		y2 : OUT std_logic
		);
	END COMPONENT;


begin
	v(0) <= '0';
	w(1 downto 0) <= "00";
	
	CS_7: for i in 0 to 7 generate 

	Inst_carry_save_7 : carry_save_7
	PORT MAP(
		x0 => in_0(i), 
		x1 => in_1(i), 
		x2 => in_2(i), 
		x3 => in_3(i), 
		x4 => in_4(i), 
		x5 => in_5(i), 
		x6 => in_6(i), 
		y0 => u(i),
		y1	=> v(i+1),
		y2 => w(i+2)	
	);
	end generate ;	

end Behavioral;

