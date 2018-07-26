library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_generic_cla_adder is
end tb_generic_cla_adder;
 
architecture behavior of tb_generic_cla_adder is 
 
    -- component declaration for the unit under test (uut)
 
    component generic_cla_adder
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
    
   --inputs
   signal carry_in : std_logic := '0';
   signal X : std_logic_vector(7 downto 0) := (others => '0');
   signal Y : std_logic_vector(7 downto 0) := (others => '0');

 	--outputs
   signal sum : std_logic_vector(7 downto 0);
   signal carry_out : std_logic;
 
begin

	-- instantiate the unit under test (uut)
	uut: generic_cla_adder
		port map (
			carry_in => carry_in,
			X => X,
			Y => Y,
			sum => sum,
			carry_out => carry_out
		);

	-- stimulus process
	stim_proc: process
		variable tmp : integer;
		variable error_count : integer := 0;
	begin		
		-- hold reset state for 100 ns.
		wait for 10 ns;	

		-- insert stimulus here
		
		-- test con carry_in basso
		carry_in <= '0';
		for i in 0 to 255 loop
			X <= std_logic_vector(to_unsigned(i, 8));
			
			for j in 0 to 255 loop
			
				tmp := i + j;
				Y <= std_logic_vector(to_unsigned(j, 8));
				
				wait for 20 ns;
				
				assert sum = std_logic_vector(to_unsigned(tmp, 8))
					report "Errore : i=" & integer'image(i) & " j=" & integer'image(j)
					severity error;
					
					if sum /= std_logic_vector(to_unsigned(tmp, 8)) then
						error_count := error_count + 1;
					end if;
				
			end loop;
		end loop;
		
		-- test con carry_in alto
		carry_in <= '1';
		for i in 0 to 255 loop
			X <= std_logic_vector(to_unsigned(i, 8));
			
			for j in 0 to 255 loop
			
				tmp := i + j + 1;
				Y <= std_logic_vector(to_unsigned(j, 8));
				
				wait for 20 ns;
				
				assert sum = std_logic_vector(to_unsigned(tmp, 8))
					report "Errore : i=" & integer'image(i) & " j=" & integer'image(j)
					severity error;
					
					if sum /= std_logic_vector(to_unsigned(tmp, 8)) then
						error_count := error_count + 1;
					end if;
				
			end loop;
		end loop;
		
		assert (1 = 2)
		report "Si sono verificati " & integer'image(error_count) & " errori durante il test";

		wait;
	end process;

end;
