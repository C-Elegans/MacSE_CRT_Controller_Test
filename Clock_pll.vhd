LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MaceSeCRT_PLL is
port ( 
      REFERENCECLK: in std_logic;
      RESET: in std_logic;
      PLLOUTCORE: out std_logic;
      PLLOUTGLOBAL: out std_logic);

end entity MaceSeCRT_PLL;

architecture behavior of MaceSeCRT_PLL is 
signal clock_out	: std_logic;


begin
	--simulate Clock PLL - of course jsut pass the clock signal through
	--The intention here is to make sure CRT.vhd is structurally correct with
	--minimal modifications necessary to CRT.vhd during synthesis.
	clock_out <= '1' when REFERENCECLK = '1' else '0';
	PLLOUTCORE <= clock_out;
	PLLOUTGLOBAL <= clock_out;
end architecture behavior;
    								  
