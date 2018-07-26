library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- adder con carry-lookahead
-- la rete di carry e' porzionata su quattro bit (nibble)
entity nibble_adder is
    Port ( adderA : in  STD_LOGIC_VECTOR (3 downto 0);	-- nibble dell'addendo A
           adderB : in  STD_LOGIC_VECTOR (3 downto 0);	-- nibble dell'addendo B
           carryIn : in  STD_LOGIC;						-- carry in ingresso
           propIn : in  STD_LOGIC;						-- segnale "propagate" in ingresso (dal blocco precedente)
           genIn : in  STD_LOGIC;						-- segnale "generate" in ingresso (dal blocco precedente)
           propOut : out  STD_LOGIC;					-- segnale "propagate" in uscita (per il blocco successivo)
           genOut : out  STD_LOGIC;						-- segnale "generate" in uscita (per il blocco successivo)
           sum : out  STD_LOGIC_VECTOR (3 downto 0));	-- nibble somma
end nibble_adder;

architecture structural of nibble_adder is
	
	-- rete di calcolo dei carry
	component cla_carry_net
		port (	prop, gen : in std_logic_vector(3 downto 0);
				carryin, propin, genin : in std_logic;
				carryout : out std_logic_vector(3 downto 0);
				propout, genout : out std_logic); 
	end component;
	
	-- cella elementare di somma
	component cla_adder_cell
		port (	add1, add2, carryin: in std_logic;
			prop, gen, sum: out std_logic);
	end component;
	
	-- segnali "propagate" e "generate" prodotti dalle singole celle adder
	-- segnale "carry" prodotto dalla rete di carry-lookahead
	signal p, g, carryGenerati : std_logic_vector(3 downto 0);
	
begin
	
	-- istanza di rete di calcolo dei carry
	cla_net:	cla_carry_net
				port map (p, g, carryIn, propIn, genIn, carryGenerati, propOut, genOut);
		
	-- istanziazione delle celle elementari di somma
	adders : for i in 0 to 3 generate		
		adder :	cla_adder_cell
				port map (adderA(i), adderB(i), carryGenerati(i), p(i), g(i), sum(i));
	end generate;

end structural;

