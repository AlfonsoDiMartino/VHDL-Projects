----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:22:55 11/10/2015 
-- Design Name: 
-- Module Name:    carry_skip_adder - Behavioral 
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

entity carry_skip_adder is
	generic( N : natural := 8; M : natural :=4; P : natural := 2);
    Port ( X : in  STD_LOGIC_VECTOR (N-1 downto 0);
           Y : in  STD_LOGIC_VECTOR (N-1 downto 0);
           carry_in : in  STD_LOGIC;
           carry_out : out  STD_LOGIC;
           sum : out  STD_LOGIC_VECTOR (N-1 downto 0));
end carry_skip_adder;

architecture Structural of carry_skip_adder is

component carry_skip_module is
	generic( N : natural);
    Port ( X : in  STD_LOGIC_VECTOR (N-1 downto 0);
           Y : in  STD_LOGIC_VECTOR (N-1 downto 0);
           carry_in : in  STD_LOGIC;
           carry_out : out  STD_LOGIC;
           sum : out  STD_LOGIC_VECTOR (N-1 downto 0));
end component carry_skip_module;

signal tmp_somma : std_logic_vector(N-1 downto 0);
signal tmp_carry : std_logic_vector(P downto 0);


begin

tmp_carry(0) <= carry_in;
carry_out <= tmp_carry(P);

CARRY_SKIP_WATERFALL : for i in P-1 downto 0 generate
	Inst_carry_skip_module: carry_skip_module 
	generic map (N => M)
	port map(
		X => X(((i+1)*M)-1 downto (i*M)),
		Y => Y(((i+1)*M)-1 downto (i*M)),
		carry_in => tmp_carry(i),
		carry_out => tmp_carry(i+1),
		sum => tmp_somma(((i+1)*M)-1 downto (i*M))
	);
	
sum <= tmp_somma;

end generate;
end Structural;

