----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:21:50 11/11/2015 
-- Design Name: 
-- Module Name:    MAC_Row - Behavioral 
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

entity MAC_row is
	generic (N : natural := 4);
	port (
			X : in std_logic_vector(N-1 downto 0); 		-- X(0) , X(1) , .. , X(N-1)
			Y_in : in std_logic;										-- Y(i)
			S_in : in std_logic_vector(N-1 downto 0);		-- S_in (i) 
			C_in : in std_logic;									-- sarà sempre '0'
			S_out : out std_logic_vector(N-1 downto 0);	-- S_in (i+1)
			P_out : out std_logic--;
			--X_out : out std_logic_vector(N-1 downto 0);	-- X_out(i) => X_in(i) riga successiva
			--Y_out : out std_logic								-- Y_out andrà perso alla fine di ogni riga								
			);			
end entity MAC_row;

architecture Structural of MAC_row is

component MAC_cell 
    Port ( x_in : in  STD_LOGIC;
           y_in : in  STD_LOGIC;
           s_in : in  STD_LOGIC;
           c_in : in  STD_LOGIC;
           s_out : out  STD_LOGIC;
           c_out : out  STD_LOGIC--;
           --x_out : out  STD_LOGIC;
			  --y_out : out STD_LOGIC
			  );
end component MAC_cell;

signal tmp_S_out : std_logic_vector(N-1 downto 0); 
signal tmp_C_in : std_logic_vector(N downto 0);

begin

tmp_C_in(0) <= C_in;

MAC_CELL_WATERFALL : for i in N-1 downto 0 generate
	Inst_MAC_cell: MAC_cell PORT MAP(
		x_in => X(i),
		y_in => Y_in,
		s_in => S_in(i),
		c_in => tmp_C_in(i),
		s_out => tmp_S_out(i),
		c_out => tmp_C_in(i+1)--,
		--x_out => X_out(i),
		--y_out => Y_out
	);
end generate;
	
P_out <= tmp_S_out(0);
S_out(N-1) <= tmp_C_in(N);
S_out(N-2 downto 0) <= tmp_S_out(N-1 downto 1);
	
end Structural;


