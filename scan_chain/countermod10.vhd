library ieee;
use ieee.std_logic_1164.all;

entity countermod10 is
    port ( 	areset_n : in std_logic;
			pulse : in  std_logic;
			clock : in  std_logic;
			scan_en : in std_logic;
			scan_in : in std_logic;
			count : out  std_logic_vector (3 downto 0));
end countermod10;

architecture behavioral of countermod10 is

	component muxedbuffer is
		generic (
			nbit : natural := 4;
			edge : std_logic := '1' -- 1 = rising edge, 0 = falling edge
		);
		port (	clk			: in std_logic;
				reset_n 	: in std_logic;		-- reset asincrono ha priorita' massima
				load		: in std_logic;		-- load asincrono ha priorita' su tutto eccetto che su reset
				datain		: in std_logic_vector (nbit-1 downto 0);
				dataout		: out std_logic_vector (nbit-1 downto 0);
				scanen		: in std_logic;
				scanin		: in std_logic
		);
	end component;
		
    component generic_cla_adder is
		generic (nibbles : natural := 2);	-- l'adder va instanzializzato in nibble (4 bit)
											-- es. un adder cla a 16 bit va instanzializzato usado
											-- nibbles = 4
		port (	carry_in : in  STD_LOGIC;								-- carry in ingresso
				X : in  STD_LOGIC_VECTOR ((nibbles * 4)-1 downto 0);	-- primo addendo
				Y : in  STD_LOGIC_VECTOR ((nibbles * 4)-1 downto 0);	-- secondo addendo
				sum : out  STD_LOGIC_VECTOR ((nibbles * 4)-1 downto 0);	-- risultato della somma
				carry_out : out std_logic								-- carry in uscita
			);
	end component;


	signal internal_in, internal_out : std_logic_vector (3 downto 0);
	signal one : std_logic_vector(3 downto 0) := "0000";
	signal counted10 : std_logic := '0';
	signal reset : std_logic := '0';
	
begin

	one <= "0000";
	
	counted10 <= internal_out(3) and internal_out(1);
	reset <= areset_n and not counted10;
	
	buff: muxedbuffer
			generic map (4, '1')
			port map (	clk => clock,
						reset_n => reset,
						load => '0',
						datain => internal_in,
						dataout => internal_out,
						scanen => scan_en,
						scanin => scan_in);
						
	adder : generic_cla_adder
			generic map (1)
			port map (	carry_in => pulse,
						X => one,
						Y => internal_out,
						sum => internal_in,
						carry_out => open);
	
	count <= internal_out;				

end behavioral;

