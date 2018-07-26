----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:22:23 11/07/2015 
-- Design Name: 
-- Module Name:    carry_select_adder - Behavioral 
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

entity carry_select_adder is
	generic (N : natural := 8; M : natural := 4; P : natural := 2);
    Port ( x : in  STD_LOGIC_VECTOR (N-1 downto 0);
           y : in  STD_LOGIC_VECTOR (N-1 downto 0);
           carry_in : in  STD_LOGIC;
           carry_out : out  STD_LOGIC;
           sum : out  STD_LOGIC_VECTOR (N-1 downto 0));
end carry_select_adder;

architecture Behavioral of carry_select_adder is

component ripple_carry_adder 
	generic ( N : natural );
    Port ( x : in  STD_LOGIC_VECTOR (N-1 downto 0);
           y : in  STD_LOGIC_VECTOR (N-1 downto 0);
           carry_in : in  STD_LOGIC;
           carry_out : out  STD_LOGIC;
           sum : out  STD_LOGIC_VECTOR (N-1 downto 0)
			  );
end component ripple_carry_adder;

component carry_select_module is
	generic( M : natural);
	port(
			X : in std_logic_vector (M-1 downto 0);
			Y : in std_logic_vector (M-1 downto 0);
			carry_in : in std_logic;
			carry_out : out std_logic;
			sum : out std_logic_vector (M-1 downto 0)
		  );		
end component carry_select_module;


signal tmp_carry : std_logic_vector (p downto 0);
signal tmp_somma : std_logic_vector (N-1 downto 0);
begin

tmp_carry(0) <= carry_in;
carry_out <= tmp_carry(p);
sum <= tmp_somma;					 

-- Istanzio il primo RCA --
RCA_1 : ripple_carry_adder
	generic map(N => M)
	port map	(
				 x => x(M-1 downto 0),
				 y => y(M-1 downto 0),
				 carry_in => tmp_carry(0),
				 carry_out => tmp_carry(1),
				 sum => tmp_somma(M-1 downto 0)
				 );

-- Istanzio i restanti blocchi usando generate --
CARRY_SELECT_WATERFALL : for i in p-1 downto 1 generate

CARRY_SELECT_MODULE_INST : carry_select_module
		generic map (M => M)
		port map	(
					 X => X((((i+1)*M)-1) downto (i*M)),
					 Y => Y((((i+1)*M)-1) downto (i*M)),
					 carry_in => tmp_carry(i),
					 carry_out => tmp_carry(i+1),
					 sum => tmp_somma((((i+1)*m)-1) downto (i*M))
					 );

end generate;		
end Behavioral;
					 
