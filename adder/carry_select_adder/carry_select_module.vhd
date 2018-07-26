----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:39:21 11/08/2015 
-- Design Name: 
-- Module Name:    carry_select_module - Behavioral 
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

entity carry_select_module is
	generic( M : natural := 4);
	port(
			X : in std_logic_vector (M-1 downto 0);
			Y : in std_logic_vector (M-1 downto 0);
			carry_in : in std_logic;
			carry_out : out std_logic;
			sum : out std_logic_vector (M-1 downto 0)
		  );
			
end carry_select_module;

architecture Behavioral of carry_select_module is

component ripple_carry_adder 
	generic ( N : natural );
    Port ( x : in  STD_LOGIC_VECTOR (N-1 downto 0);
           y : in  STD_LOGIC_VECTOR (N-1 downto 0);
           carry_in : in  STD_LOGIC;
           carry_out : out  STD_LOGIC;
           sum : out  STD_LOGIC_VECTOR (N-1 downto 0)
			  );
end component ripple_carry_adder;

component mux_2to1_generic 
	generic(N : natural);
	port (	X : in std_logic_vector (N-1 downto 0);
				Y : in std_logic_vector (N-1 downto 0);
				S : in std_logic;
				Z : out std_logic_vector(N-1 downto 0)
				);
end component mux_2to1_generic;

component mux2_1 
	port (
			a : in std_logic;
			b : in std_logic;
			sel : in std_logic;
			o : out std_logic
			);
end component mux2_1;

signal tmp_sum_vcc, tmp_sum_gnd, tmp_somma : std_logic_vector(M-1 downto 0);
signal tmp_carry_vcc, tmp_carry_gnd : std_logic;

begin

RCA_VCC : ripple_carry_adder
	generic map ( N => M)
	port map (
					X => X,
					Y => Y,
					carry_in => '1',
					carry_out => tmp_carry_vcc,
					sum => tmp_sum_vcc
					);
					
RCA_GND : ripple_carry_adder
	generic map ( N => M)
	port map (
					X => X,
					Y => Y,
					carry_in => '0',
					carry_out => tmp_carry_gnd,
					sum => tmp_sum_gnd
					);
					
SUM_MUX : mux_2to1_generic
	generic map (N => M)
		port map (
					 X => tmp_sum_vcc,
					 Y => tmp_sum_gnd,	
					 S => carry_in,
					 Z => tmp_somma
					 );

CARRY_MUX : mux2_1
		port map	(
					 a => tmp_carry_vcc,
					 b => tmp_carry_gnd,
					 sel => carry_in,
					 o => carry_out
					 );
sum <= tmp_somma;
					 
end Behavioral;

