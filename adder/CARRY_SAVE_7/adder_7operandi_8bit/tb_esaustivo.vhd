library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_esaustivo is
end tb_esaustivo;

architecture behavior of tb_esaustivo is 

	component adder
		port(
			in0 : in  std_logic_vector(7 downto 0);
			in1 : in  std_logic_vector(7 downto 0);
			in2 : in  std_logic_vector(7 downto 0);
			in3 : in  std_logic_vector(7 downto 0);
			in4 : in  std_logic_vector(7 downto 0);
			in5 : in  std_logic_vector(7 downto 0);
			in6 : in  std_logic_vector(7 downto 0);
			sum : out  std_logic_vector(10 downto 0)
		);
	end component;


	signal in0 : std_logic_vector(7 downto 0) := (others => '0');
	signal in1 : std_logic_vector(7 downto 0) := (others => '0');
	signal in2 : std_logic_vector(7 downto 0) := (others => '0');
	signal in3 : std_logic_vector(7 downto 0) := (others => '0');
	signal in4 : std_logic_vector(7 downto 0) := (others => '0');
	signal in5 : std_logic_vector(7 downto 0) := (others => '0');
	signal in6 : std_logic_vector(7 downto 0) := (others => '0');
	signal sum : std_logic_vector(10 downto 0);

begin

	uut: adder
		port map (
			in0 => in0,
			in1 => in1,
			in2 => in2,
			in3 => in3,
			in4 => in4,
			in5 => in5,
			in6 => in6,
			sum => sum
		);

	stim_proc: process
		variable test_sum : integer := 0;
		variable error_count : integer := 0;
		
	begin		
		wait for 50 ns;

		for a in 0 to 255 loop
			in0 <= std_logic_vector(to_unsigned(a, 8));
			for b in 0 to 255 loop
				in1 <= std_logic_vector(to_unsigned(b, 8));
				for c in 0 to 255 loop
					in2 <= std_logic_vector(to_unsigned(c, 8));
					for d in 0 to 255 loop
						in3 <= std_logic_vector(to_unsigned(d, 8));
						for e in 0 to 255 loop
							in4 <= std_logic_vector(to_unsigned(e, 8));
							for f in 0 to 255 loop
								in5 <= std_logic_vector(to_unsigned(f, 8));
								for g in 0 to 255 loop
									in6 <= std_logic_vector(to_unsigned(g, 8));
									test_sum := a + b + c + d + e + f + g;
									wait for 10 ns;
									assert sum = std_logic_vector(to_unsigned(test_sum, sum'length))
										report	"Errore! " &
												"a=" & integer'image(a) &
												"b=" & integer'image(b) &
												"c=" & integer'image(c) &
												"d=" & integer'image(d) &
												"e=" & integer'image(e) &
												"f=" & integer'image(f) &
												"g=" & integer'image(g) &
												" test_sum=" & integer'image(test_sum)
										severity error;
									
									if sum /= std_logic_vector(to_unsigned(test_sum, sum'length)) then
										error_count := error_count + 1;
									end if;
										
								end loop;
							end loop;
						end loop;
					end loop;
				end loop;
			end loop;
		end loop;
		
		assert 1 = 2
			report "si sono verificati " & integer'image(error_count) & " errori"
			severity error;

		wait;
	end process;

end;
