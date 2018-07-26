
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_module is
    Port ( Clock_in : in  STD_LOGIC;
           Clock0 : out  STD_LOGIC;
           Clock1 : out  STD_LOGIC;
           Clock2 : out  STD_LOGIC;
           Clock3 : out  STD_LOGIC);
end top_module;

architecture Behavioral of top_module is

COMPONENT DCM
	PORT(
		CLKIN_IN : IN std_logic;
		RST_IN : IN std_logic;          
		CLKDV_OUT : OUT std_logic;
		CLKFX_OUT : OUT std_logic;
		CLKIN_IBUFG_OUT : OUT std_logic;
		CLK0_OUT : OUT std_logic;
		LOCKED_OUT : OUT std_logic;
		STATUS_OUT : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	
	COMPONENT DCM_2
	PORT(
		CLKIN_IN : IN std_logic;
		RST_IN : IN std_logic;          
		CLKFX_OUT : OUT std_logic;
		CLKIN_IBUFG_OUT : OUT std_logic;
		CLK0_OUT : OUT std_logic;
		LOCKED_OUT : OUT std_logic
		);
	END COMPONENT;

	
	
	COMPONENT DCM_4
	PORT(
		CLKIN_IN : IN std_logic;
		RST_IN : IN std_logic;          
		CLKFX_OUT : OUT std_logic;
		CLKIN_IBUFG_OUT : OUT std_logic;
		CLK0_OUT : OUT std_logic
		);
	END COMPONENT;

	
signal tmp_0, tmp_1, tmp_2, tmp_3 : std_logic := '0';
signal clock_233, clock_250 : std_logic := '0';

begin


Clock0  <= tmp_0;
Clock1  <= tmp_1;
Clock2  <= tmp_2;
Clock3  <= tmp_3;


----- GENERAZIONE CLOCK 25 Mhz e 78 Mhz------
-------- ClockDv con D= 4------------
--------ClockFx con M=25 e D= 32------

	Inst_DCM: DCM PORT MAP(
		CLKIN_IN => Clock_in,
		RST_IN => '0',
		CLKDV_OUT => tmp_0,
		CLKFX_OUT => tmp_1,
		CLKIN_IBUFG_OUT => open,
		CLK0_OUT => open,
		LOCKED_OUT => open,
		STATUS_OUT => open
	);

-------- CLOCK 233.33 Mhz ---------
---------- M= 7   D = 3------------

	Inst_DCM_2: DCM_2 PORT MAP(
		CLKIN_IN => Clock_in,
		RST_IN => '0',
		CLKFX_OUT => clock_233,
		CLKIN_IBUFG_OUT => open,
		CLK0_OUT => open,
		LOCKED_OUT => open
	);
	
---------- SEGNALE DI 78 Mhz - duty cycle 70 % --------
--------DIVISIONE del segnale di 233 Mhz per 3 --------

gen_clock_78_dc70: process(Clock_233)
constant max_rising : integer := 1;
constant max_falling : integer := 3;
variable count_rising: integer :=0;

begin
	if (Clock_233='1' and Clock_233'event) then
		count_rising:= count_rising+1;
		if (count_rising = max_rising) then
			tmp_3<='1';
		end if;
		if (count_rising = max_falling) then
			tmp_3 <= '0';
			count_rising := 0;
		end if;
	end if;

end process;

-------- CLOCK 250 Mhz ------
--------- M= 5 e D= 2-------

	Inst_DCM_4: DCM_4 PORT MAP(
		CLKIN_IN => Clock_in,
		RST_IN => '0',
		CLKFX_OUT => clock_250,
		CLKIN_IBUFG_OUT => open,
		CLK0_OUT => open
	);
	
---------- SEGNALE DI 25 Mhz - duty cycle 70 % --------
-------- DIVISIONE del segnale 250 Mhz per 10 -------------

gen_clock_25_dc50: process(clock_250)
constant max_rising : integer := 3;
constant max_falling : integer := 10;
variable count_rising: integer :=0;

begin
	if (Clock_250='1' and Clock_250'event) then
		count_rising:= count_rising+1;
		if (count_rising = max_rising) then
			tmp_2<='1';
		end if;
		if (count_rising = max_falling) then
			tmp_2 <= '0';
			count_rising := 0;
		end if;
	end if;

end process;


end Behavioral;

