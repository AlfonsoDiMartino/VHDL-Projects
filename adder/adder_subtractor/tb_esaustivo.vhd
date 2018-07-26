LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_esaustivo IS
END tb_esaustivo;
 
ARCHITECTURE behavior OF tb_esaustivo IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT adder
    PORT(
         X : IN  std_logic_vector(7 downto 0);
         Y : IN  std_logic_vector(7 downto 0);
         carry_in : IN  std_logic;
         carry_out : OUT  std_logic;
         sum : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    
    for all : adder use entity work.generic_cla_adder;
    

   --Inputs
   signal X : std_logic_vector(7 downto 0) := (others => '0');
   signal Y : std_logic_vector(7 downto 0) := (others => '0');
   signal carry_in : std_logic := '0';

 	--Outputs
   signal carry_out : std_logic;
   signal sum : std_logic_vector(7 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: adder PORT MAP (
          X => X,
          Y => Y,
          carry_in => carry_in,
          carry_out => carry_out,
          sum => sum
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
				
				wait for 1 ns;
				
				assert sum = std_logic_vector(to_unsigned(tmp, 8))
					report "Errore somma : i=" & integer'image(i) & " j=" & integer'image(j)
					severity error;
					
					if sum /= std_logic_vector(to_unsigned(tmp, 8)) then
						error_count := error_count + 1;
					end if;
					
					if (tmp>255) then
						assert carry_out = '1'
						report "Errore carry out : i=" & integer'image(i) & " j=" & integer'image(j)
						severity error;
					end if;
					
					if (tmp > 255) then
						if (carry_out /= '1') then
							error_count := error_count + 1;
						end if;
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
				
				wait for 1 ns;
				
				assert sum = std_logic_vector(to_unsigned(tmp, 8))
					report "Errore somma: i=" & integer'image(i) & " j=" & integer'image(j)
					severity error;
					
					if sum /= std_logic_vector(to_unsigned(tmp, 8)) then
						error_count := error_count + 1;
					end if;
					
				
					if (tmp > 255) then
						assert carry_out = '1'
						report "Errore carry out : i=" & integer'image(i) & " j=" & integer'image(j)
						severity error;
					end if;
					
					if (tmp > 255) then
						if (carry_out /= '1') then
							error_count := error_count + 1;
						end if;
					end if;
				
			end loop;
		end loop;
		
		assert false
		report "Si sono verificati " & integer'image(error_count) & " errori durante il test";

		wait;
	end process;

END;
