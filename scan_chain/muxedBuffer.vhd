library ieee;
use ieee.std_logic_1164.all;

entity muxedbuffer is
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
end muxedbuffer;

architecture structural of muxedbuffer is

	component muxeddlatch
	  	generic (
			edge : std_logic := '1' -- 1 = rising edge, 0 = falling edge
		);
		port ( 	clk 		: in std_logic;
				reset_n 	: in std_logic;		-- reset asincrono ha priorita' massima
				load		: in std_logic;		-- load asincrono ha priorita' su tutto eccetto che su reset
				datain 		: in std_logic;
				dataout 	: out std_logic;
				scanen 		: in std_logic;
				scanin 		: in std_logic
		);
	end component;

	signal data : std_logic_vector(nbit-1 downto 0);

begin

	dataout <= data;

	mbuff: for i in 0 to nbit-1 generate
		
		fst : if i = 0 generate
			fstd : muxeddlatch
				generic map (edge => edge)
				port map (	clk => clk,
							reset_n => reset_n,
							load => load,
							datain => datain(i),
							dataout => data(i),
							scanin => scanin,
							scanen => scanen
				);
		end generate;
		
		oth : if i > 0 generate
			othd : muxeddlatch
				generic map (edge => edge)
				port map (	clk => clk,
							reset_n => reset_n,
							datain => datain(i),
							load => load,
							dataout => data(i),
							scanin => data(i-1),
							scanen => scanen
				);
		end generate;
		
	end generate;
end structural;

