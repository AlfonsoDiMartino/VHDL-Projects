----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:08:40 11/10/2015 
-- Design Name: 
-- Module Name:    carry_skip_module - Behavioral 
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

entity carry_skip_module is
	generic( N : natural := 4);
    Port ( X : in  STD_LOGIC_VECTOR (N-1 downto 0);
           Y : in  STD_LOGIC_VECTOR (N-1 downto 0);
           carry_in : in  STD_LOGIC;
           carry_out : out  STD_LOGIC;
           sum : out  STD_LOGIC_VECTOR (N-1 downto 0));
end carry_skip_module;

architecture Structural of carry_skip_module is

component skip_logic
	generic(M : natural);
	port (
			p : in std_logic_vector (M-1 downto 0);
			carry_0 : in std_logic;
			carry_1 : in std_logic;
			carry_out : out std_logic
			);
end component skip_logic;

			
component ripple_carry_adder
	generic(N: natural);
	port	( x : in  STD_LOGIC_VECTOR (N-1 downto 0);
           y : in  STD_LOGIC_VECTOR (N-1 downto 0);
           carry_in : in  STD_LOGIC;
           carry_out : out  STD_LOGIC;
           sum : out  STD_LOGIC_VECTOR (N-1 downto 0)
			  );
end component ripple_carry_adder;

signal tmp_somma : std_logic_vector(N-1 downto 0);
signal tmp_propagate : std_logic_vector(N-1 downto 0);
signal tmp_carry_0 , tmp_carry_1 : std_logic := '0';

begin

tmp_carry_0 <= carry_in;

PROP_BLOCK : for i in N-1 downto 0 generate
	tmp_propagate(i) <= X(i) xor Y(i);
end generate;

RCA_BLOCK : ripple_carry_adder
		generic map (N => N)
		port map(
					X => X,
					Y => Y, 
					carry_in => tmp_carry_0,
					carry_out => tmp_carry_1,
					sum => tmp_somma
					);
					
SKIP_LOGIC_BLOCK : skip_logic
		generic map (M => N)
		port map	(
					 p => tmp_propagate,
					 carry_0 => tmp_carry_0,
					 carry_1 => tmp_carry_1,
					 carry_out => carry_out
					 );
					 
sum <= tmp_somma;
					 
end Structural;


