library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity input_filter_min is
    Port ( load_in : in  STD_LOGIC;
           data_in : in  STD_LOGIC_VECTOR (7 downto 0);
           load_out : out  STD_LOGIC);
end input_filter_min;

architecture Data_Flow of input_filter_min is

begin

	load_out <= load_in and (not (data_in(7) or data_in(6) or(data_in(5) and data_in(4) and data_in(3) and data_in(2))));

end Data_Flow;

