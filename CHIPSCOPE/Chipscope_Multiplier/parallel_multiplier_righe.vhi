
-- VHDL Instantiation Created from source file parallel_multiplier_righe.vhd -- 21:22:06 01/04/2016
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT parallel_multiplier_righe
	PORT(
		X : IN std_logic_vector(127 downto 0);
		Y : IN std_logic_vector(127 downto 0);          
		PROD : OUT std_logic_vector(255 downto 0)
		);
	END COMPONENT;

	Inst_parallel_multiplier_righe: parallel_multiplier_righe PORT MAP(
		X => ,
		Y => ,
		PROD => 
	);


