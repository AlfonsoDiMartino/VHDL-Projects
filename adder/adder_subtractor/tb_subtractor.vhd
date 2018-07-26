library ieee;
use ieee.std_logic_1164.all;

entity tb_subtractor is
end tb_subtractor;
 
architecture behavior of tb_subtractor is 
 
    component generic_adder_subtractor
    port(
         x : in  std_logic_vector(7 downto 0);
         y : in  std_logic_vector(7 downto 0);
         sub_add_n : in  std_logic;
         sum : out  std_logic_vector(7 downto 0);
         carry_out : out  std_logic;
         overflow : out  std_logic
        );
    end component;

   --inputs
   signal x : std_logic_vector(7 downto 0) := (others => '0');
   signal y : std_logic_vector(7 downto 0) := (others => '0');
   signal sub_add_n : std_logic := '0';

 	--outputs
   signal sum : std_logic_vector(7 downto 0);
   signal overflow : std_logic;

begin
 
	-- instantiate the unit under test (uut)
   uut: generic_adder_subtractor port map (
          x => x,
          y => y,
          sub_add_n => sub_add_n,
          sum => sum,
          carry_out => carry_out,
          overflow => overflow
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
		sub_add_n <= '1';
		for i in -128 to 127 loop
			x <= std_logic_vector(to_unsigned(i, 8));
			
			for j in -128 to 127 loop
			
				tmp := i - j;
				y <= std_logic_vector(to_signed(j, 8));
				
				wait for 1 ns;
				
				assert sum = std_logic_vector(to_signed(tmp, 8))
					report "errore somma : i=" & integer'image(i) & " j=" & integer'image(j)
					severity error;
					
					if sum /= std_logic_vector(to_signed(tmp, 8)) then
						error_count := error_count + 1;
					end if;
				
			end loop;
		end loop;

      wait;
   end process;

end;
