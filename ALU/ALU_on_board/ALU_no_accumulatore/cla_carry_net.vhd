library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cla_carry_net is
	port (	prop, gen : in std_logic_vector(3 downto 0);
			carryin, propin, genin : in std_logic;
			carryout : out std_logic_vector(3 downto 0);
			propout, genout : out std_logic); 
end cla_carry_net;

architecture dataflow of cla_carry_net is

begin
	carryout(0) <= genin or (propin and carryin);
	
	carryout(1) <= 	gen(0) or
					(prop(0) and genin) or 
					(prop(0) and propin and carryin);
	
	carryout(2) <= 	gen(1) or 
					(prop(1) and gen(0)) or
					(prop(1) and prop(0) and genin) or
					(prop(1) and prop(0) and propin and carryin);
					
	carryout(3) <= 	gen(2) or
					(prop(2) and gen(1)) or 
					(prop(2) and prop(1) and gen(0)) or
					(prop(2) and prop(1) and prop(0) and genin) or
					(prop(2) and prop(1) and prop(0) and propin and carryin);
	
	genout <=	gen(3) or
				(prop(3) and gen(2)) or
				(prop(3) and prop(2) and gen(1)) or 
				(prop(3) and prop(2) and prop(1) and gen(0)) or
				(prop(3) and prop(2) and prop(1) and prop(0) and genin);
					
	propout <=	prop(3) and prop(2) and prop(1) and prop(0) and propin;
	
end dataflow;

