library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity input_filter_hour is
    Port ( load_in : in  STD_LOGIC;
           data_in : in  STD_LOGIC_VECTOR (7 downto 0);
           load_out : out  STD_LOGIC);
end input_filter_hour;

architecture Data_Flow of input_filter_hour is

begin

	load_out <= load_in and (not (data_in(7) or data_in(6) or data_in(5) or (data_in(4) and data_in(3))));

end Data_Flow;

