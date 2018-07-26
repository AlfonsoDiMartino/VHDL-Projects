library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity esercizio_6 is
    Port ( Clock_in : in  STD_LOGIC; -- clock in ingresso, 100 Mhz
           Clock0 : out  STD_LOGIC; -- 25 Mhz duty cycle 50 %
           Clock1 : out  STD_LOGIC; -- 78 Mhz duty cycle 50 %
           Clock2 : out  STD_LOGIC; -- 25 Mhz duty cycle 70 %
           Clock3 : out  STD_LOGIC); -- 78 Mhz duty cycle 70 %
end esercizio_6;

architecture Behavioral of esercizio_6 is

signal clock_100x2,clock_100x4,clock_100x8,clock_100x16,clock_100x32 : std_logic :='0';
signal clock_200,clock_400,clock_800,clock_1600,clock_3200 : std_logic :='0';
signal temp_out0, temp_out1, temp_out2, temp_out3  : std_logic := '0';
constant clk_time : time := 10 ns;

begin




---------- MOLTIPLICAZIONE X 2 del segnale di partenza ----------

gen_clock_200: process(Clock_in)

constant clk_period :time := clk_time/4;

begin
	clock_100x2<= (not Clock_in) after clk_period;
	
end process;

clock_200 <= Clock_in xor clock_100x2; 	-- clock 200 Mhz



---------- MOLTIPLICAZIONE x 4 del segnale di partenza ----------
gen_clock_400: process(clock_200)
constant clk_period :time := clk_time/8;

begin
	clock_100x4<= (not clock_200) after clk_period;
	
end process;

clock_400 <= clock_200 xor clock_100x4;		-- clock 400 Mhz


---------- MOLTIPLICAZIONE x 8 del segnale di partenza ----------
gen_clock_800: process(clock_400)
constant clk_period :time := clk_time/16;

begin
	clock_100x8<= (not clock_400) after clk_period;
	
end process;

clock_800 <= clock_400 xor clock_100x8;		-- clock 800 Mhz


---------- MOLTIPLICAZIONE x 16 del segnale di partenza ----------
gen_clock_100x16: process(clock_800)
constant clk_period : time := clk_time/32;

begin
	clock_100x16<= (not clock_800) after clk_period;
	
end process;

clock_1600 <= clock_800 xor clock_100x16;	-- clock 1600 Mhz



---------- MOLTIPLICAZIONE x 32 del segnale di partenza ----------
gen_clock_100x32: process(clock_1600)
constant clk_period :time := clk_time/64;

begin
	clock_100x32<= (not clock_1600) after clk_period;
	
end process;


clock_3200 <= clock_1600 xor clock_100x32;	-- clock 3200 Mhz

---------- SEGNALE DI 25 Mhz - duty cycle 50 % --------
------------  DIVISIONE del segnale per 4 -------------

gen_clock_25_dc50: process(Clock_in)
constant max_rising : integer := 2;
variable count_rising: integer :=0;

begin
	if (Clock_in='1' and Clock_in'event) then
		count_rising:= count_rising+1;
		if (count_rising = max_rising) then
			temp_out0<='1';
		end if;
		if (count_rising = 2*max_rising) then
			temp_out0 <= '0';
			count_rising := 0;
		end if;
	end if;

end process;

Clock0 <= temp_out0;


---------- SEGNALE DI 78 Mhz - duty cycle 50 % --------
------------  DIVISIONE del segnale per 41 -------------
gen_clock_78_dc50: process(clock_3200)
constant max_rising : integer := 21;
constant max_falling : integer := 41;
variable count_rising: integer :=0;
variable count_falling: integer :=0;

begin
	if (clock_3200='1' and clock_3200'event) then
		count_rising:= count_rising+1;
		if (count_rising = max_rising) then
			temp_out1<='1';
		end if;
	end if;
	if (clock_3200='0' and clock_3200'event) then
		count_falling := count_falling +1;
		if (count_falling = max_falling) then
			temp_out1 <= '0';
			count_falling := 0;
			count_rising := 0;
		end if;
	end if;

end process;

Clock1 <= temp_out1; 

 
 ---------- SEGNALE DI 25 Mhz - duty cycle 70 % --------
------------  DIVISIONE del segnale per 4 -------------
gen_clock_25_dc70: process(clock_800)
constant max_rising : integer := 10;
constant max_falling : integer := 32;
variable count_rising: integer :=0;
variable count_falling: integer :=0;


begin
	if (clock_800='0' and clock_800'event) then
		count_falling := count_falling + 1;
		if (count_falling = max_rising) then
			temp_out2 <= '1';
		end if;
	end if;
	if (clock_800='1' and clock_800'event) then
		count_rising:= count_rising+1;
		if (count_rising = max_falling) then
			temp_out2 <= '0';
			count_rising := 0;
			count_falling := 0;
		end if;
	end if;
end process;

Clock2 <= temp_out2;


---------- SEGNALE DI 78 Mhz - duty cycle 70 % --------
------------  DIVISIONE del segnale per 41 -------------
gen_clock_78_dc70: process(clock_3200)
constant max_rising : integer := 13;
constant max_falling : integer := 41;
variable count_rising: integer :=0;
variable count_falling: integer :=0;

begin
	if (clock_3200='1' and clock_3200'event) then
		count_rising:= count_rising+1;
		if (count_rising = max_rising) then
			temp_out3<='1';
		end if;
	end if;
	if (clock_3200='0' and clock_3200'event) then
		count_falling := count_falling +1;
		if (count_falling = max_falling) then
			temp_out3 <= '0';
			count_falling := 0;
			count_rising := 0;
		end if;
	end if;

end process;

Clock3 <= temp_out3;

end Behavioral;






